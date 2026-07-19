import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'brand_asset.dart';
import 'data.dart';
import 'global_search.dart';
import 'map_screen.dart';
import 'models.dart';

class ConcordiaApp extends StatelessWidget {
  const ConcordiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2F7455),
      surface: const Color(0xFFF5F7F4),
    );

    return MaterialApp(
      title: 'III Encuentro sobre Historia de Entre Ríos',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        );
        if (child == null) {
          return const SizedBox.shrink();
        }
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.95,
          maxScaleFactor: 1.10,
          child: child,
        );
      },
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFC9D8D0)),
          ),
        ),
      ),
      home: const MobileHomeScreen(),
    );
  }
}

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favorites = <String>{};
  double _headerSearchProgress = 0;

  static const _tabs = [
    _TabSpec('Inicio', Icons.home_rounded),
    _TabSpec('Dormir', Icons.bed_rounded),
    _TabSpec('Mapa', Icons.map_rounded),
    _TabSpec('Paseos', Icons.directions_walk_rounded),
    _TabSpec('Comer', Icons.restaurant_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final searchProgress = _headerSearchProgress;
    final screen = switch (_currentIndex) {
      0 => _HomeTab(
        favoritesCount: _favorites.length,
        onOpenCategory: _openCategory,
        onCopyMessage: _copyMessage,
      ),
      1 => _OpportunityListTab(
        title: 'Dónde dormir',
        subtitle:
            'Opciones de alojamiento para distintos presupuestos y tipos de viaje.',
        items: _filterItems(OpportunityCategory.lodging),
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
      ),
      2 => _HomeTab(
        favoritesCount: _favorites.length,
        onOpenCategory: _openCategory,
        onCopyMessage: _copyMessage,
      ),
      3 => _OpportunityListTab(
        title: 'Paseos y atractivos',
        subtitle:
            'Lugares turísticos, culturales y recreativos para conocer Concordia.',
        notice:
            'Confirmá horarios, tarifas, accesibilidad y condiciones de ingreso antes de trasladarte.',
        items: _filterItems(OpportunityCategory.places),
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
        onOpenMap: _openMap,
      ),
      _ => _FoodTab(
        viandas: _filterItems(OpportunityCategory.viandas),
        gastronomy: _filterItems(OpportunityCategory.gastronomy),
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
      ),
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _MorphingTopBar(
        title: _tabs[_currentIndex].label,
        progress: searchProgress,
        onOpenSearch: _openGlobalSearch,
        onOpenMap: _currentIndex == 3 ? _openMap : null,
      ),
      body: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(top: 120 * (1 - searchProgress)),
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: screen,
            ),
          ),
        ),
      ),
      bottomNavigationBar: MediaQuery.withNoTextScaling(
        child: SafeArea(
          top: false,
          child: Container(
            height: 60,
            clipBehavior: Clip.none,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFC9D8D0))),
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const indicatorWidth = 36.0;
                final itemWidth = constraints.maxWidth / _tabs.length;
                final indicatorLeft =
                    (itemWidth * _currentIndex) +
                    ((itemWidth - indicatorWidth) / 2);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < _tabs.length; i++)
                          Expanded(
                            child: i == 2
                                ? _CenterNavItem(
                                    icon: _tabs[i].icon,
                                    label: _tabs[i].label,
                                    isSelected: _currentIndex == i,
                                    onTap: () => _selectTab(i),
                                  )
                                : _NavItem(
                                    icon: _tabs[i].icon,
                                    label: _tabs[i].label,
                                    isSelected: _currentIndex == i,
                                    onTap: () => _selectTab(i),
                                  ),
                          ),
                      ],
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      top: 0,
                      left: indicatorLeft,
                      child: Container(
                        width: indicatorWidth,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF174D3C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<OpportunityItem> _filterItems(OpportunityCategory category) {
    return opportunities
        .where((item) => item.category == category)
        .toList(growable: false);
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _openCategory(int index) {
    _selectTab(index);
  }

  void _selectTab(int index) {
    if (index < 0 || index >= _tabs.length) return;
    if (index == 2) {
      _openMap();
      return;
    }
    setState(() {
      _currentIndex = index;
      _headerSearchProgress = 0;
    });
  }

  Future<void> _openGlobalSearch() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => GlobalSearchPage(
          favorites: _favorites,
          onFavoriteToggle: _toggleFavorite,
          onOpenTab: _selectTab,
          onCopyMessage: _copyMessage,
        ),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    final progress = (notification.metrics.pixels / 60).clamp(0.0, 1.0);
    if ((progress - _headerSearchProgress).abs() < 0.01) return false;

    setState(() => _headerSearchProgress = progress);
    return false;
  }

  void _openMap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ConcordiaMapScreen()));
  }

  Future<void> _copyMessage() async {
    await Clipboard.setData(const ClipboardData(text: cannedMessage));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Consulta copiada. Ya podés pegarla en WhatsApp o correo.',
        ),
      ),
    );
  }
}

class _MorphingTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _MorphingTopBar({
    required this.title,
    required this.progress,
    required this.onOpenSearch,
    this.onOpenMap,
  });

  final String title;
  final double progress;
  final VoidCallback onOpenSearch;
  final VoidCallback? onOpenMap;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0, 1.0);
    final titleOpacity = (1 - normalizedProgress * 3).clamp(0.0, 1.0);

    return AppBar(
      toolbarHeight: 100,
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFFE2F0E7),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.paddingOf(context).top,
          color: const Color(0xFFE2F0E7),
        ),
      ),
      title: SizedBox(
        width: double.infinity,
        height: 100,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: normalizedProgress,
                  child: Container(
                    height: 68,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F0E7),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: onOpenMap == null ? 76 : 118,
              top: 6,
              child: IgnorePointer(
                ignoring: titleOpacity < 0.1,
                child: Opacity(
                  opacity: titleOpacity,
                  child: Transform.translate(
                    offset: Offset(
                      -40 * normalizedProgress,
                      -6 * normalizedProgress,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 23,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF174D3C),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'III Encuentro sobre Historia de Entre Ríos',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.08,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF415D50),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Concordia · 13 y 14 de agosto de 2026',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF5F7269),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (onOpenMap != null)
              Positioned(
                top: 26,
                right: 68,
                child: Opacity(
                  opacity: titleOpacity,
                  child: IconButton(
                    tooltip: 'Ver lugares en el mapa',
                    onPressed: onOpenMap,
                    icon: const Icon(Icons.map_rounded),
                  ),
                ),
              ),
            Positioned(
              left: 16,
              right: 16,
              top: 8,
              child: _ExpandableSearchBar(
                progress: normalizedProgress,
                onOpen: onOpenSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableSearchBar extends StatelessWidget {
  const _ExpandableSearchBar({required this.progress, required this.onOpen});

  final double progress;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final normalizedProgress = progress.clamp(0.0, 1.0);
        final textOpacity = ((normalizedProgress - 0.20) / 0.80).clamp(
          0.0,
          1.0,
        );
        final width = 48 + (constraints.maxWidth - 48) * normalizedProgress;

        return Align(
          alignment: Alignment.centerRight,
          child: Semantics(
            button: true,
            label: 'Abrir búsqueda global',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpen,
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 90),
                  curve: Curves.easeOut,
                  width: width,
                  height: 48,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      const Color(0xFFE8F3EA),
                      Colors.white,
                      normalizedProgress,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFC9D8D0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.08 * normalizedProgress,
                        ),
                        blurRadius: 10 * normalizedProgress,
                        offset: Offset(0, 3 * normalizedProgress),
                      ),
                    ],
                  ),
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: 0,
                    maxWidth: constraints.maxWidth,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 46,
                            child: Icon(
                              Icons.search_rounded,
                              color: Color(0xFF174D3C),
                            ),
                          ),
                          if (normalizedProgress > 0.15)
                            Expanded(
                              child: Opacity(
                                opacity: textOpacity,
                                child: const Text(
                                  'Buscar sedes, mapa, alojamiento, comida o paseos',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF5F7269),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          if (normalizedProgress > 0.50)
                            Opacity(
                              opacity: textOpacity,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 14),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Color(0xFF5F7269),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.favoritesCount,
    required this.onOpenCategory,
    required this.onCopyMessage,
  });

  final int favoritesCount;
  final ValueChanged<int> onOpenCategory;
  final VoidCallback onCopyMessage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        const Text(
          'Tu estadía en Concordia',
          style: TextStyle(
            fontSize: 30,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: Color(0xFF174D3C),
          ),
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = constraints.maxWidth * 0.87 / 3;
            final gap = (constraints.maxWidth - (tileWidth * 3)) / 4;

            Widget tile({
              required String label,
              required IconData icon,
              required VoidCallback onTap,
              Color? backgroundColor,
            }) {
              return SizedBox(
                width: tileWidth,
                child: AspectRatio(
                  aspectRatio: 1.18,
                  child: _HomeActionTile(
                    label: label,
                    icon: icon,
                    backgroundColor: backgroundColor,
                    onTap: onTap,
                  ),
                ),
              );
            }

            return Row(
              children: [
                SizedBox(width: gap),
                tile(
                  label: 'Lugares',
                  icon: Icons.place_rounded,
                  backgroundColor: const Color(0xFFE8F3EA),
                  onTap: () => onOpenCategory(3),
                ),
                SizedBox(width: gap),
                tile(
                  label: 'Hospedajes',
                  icon: Icons.bed_rounded,
                  backgroundColor: const Color(0xFFE8F3EA),
                  onTap: () => onOpenCategory(1),
                ),
                SizedBox(width: gap),
                tile(
                  label: 'Restaurantes',
                  icon: Icons.restaurant_rounded,
                  backgroundColor: const Color(0xFFE8F3EA),
                  onTap: () => onOpenCategory(4),
                ),
                SizedBox(width: gap),
              ],
            );
          },
        ),
        const SizedBox(height: 60),
        const _EncounterInformationCard(),
        const SizedBox(height: 18),
        _HighlightsGrid(),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFFEFF6EE),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para planificar tu estadía',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF174D3C),
                  ),
                ),
                const SizedBox(height: 12),
                for (final entry in topRecommendations)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Color(0xFF2F7455),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 2),
                const Text(
                  'La información es orientativa. Confirmá tarifas, horarios, disponibilidad, accesibilidad y condiciones directamente con cada establecimiento.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5F7269)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _UsefulInformationCard(),
        const SizedBox(height: 18),
        _QuickAccessGrid(
          favoritesCount: favoritesCount,
          onOpenCategory: onOpenCategory,
        ),
      ],
    );
  }
}

class _HomeActionTile extends StatelessWidget {
  const _HomeActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF174D3C);
    final hasBg = backgroundColor != null;
    return Material(
      color: backgroundColor ?? const Color(0xFFF7FBF6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFC9D8D0)),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: hasBg ? const Color(0xFF174D3C) : const Color(0xFF174D3C),
              ),
              SizedBox(height: 6),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF174D3C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncounterInformationCard extends StatelessWidget {
  const _EncounterInformationCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.event_rounded, color: Color(0xFF174D3C)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Sedes del Encuentro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF174D3C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Las actividades se realizan en dos edificios distintos.',
          style: TextStyle(color: Color(0xFF5F7269), fontSize: 13),
        ),
        const SizedBox(height: 14),
        _venue(
          icon: Icons.movie_outlined,
          assetPath: 'assets/branding/pscs_institucional.webp',
          title: 'Jueves 13 · 18:30',
          place: 'Profesorado Superior de Ciencias Sociales',
          address: 'Hipólito Yrigoyen 1352 · Apertura y cine debate',
          mapsUrl:
              'https://www.google.com/maps/search/?api=1&query=Hip%C3%B3lito+Yrigoyen+1352+Concordia',
        ),
        const Divider(height: 24),
        _venue(
          icon: Icons.groups_2_outlined,
          assetPath: 'assets/branding/fcad_uner.png',
          logoBackgroundColor: Colors.white,
          title: 'Viernes 14 · desde las 8:00',
          place: 'Facultad de Ciencias de la Administración · UNER',
          address: 'Av. Monseñor Tavella 1424 · Mesas y exposiciones',
          mapsUrl:
              'https://www.google.com/maps/search/?api=1&query=Av.+Monse%C3%B1or+Tavella+1424+Concordia',
        ),
        const SizedBox(height: 14),
        const _EncounterActionGroup(),
      ],
    );
  }

  static Widget _venue({
    required IconData icon,
    required String assetPath,
    Color logoBackgroundColor = Colors.white,
    required String title,
    required String place,
    required String address,
    required String mapsUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandAssetBox(
          assetPath: assetPath,
          fallbackIcon: icon,
          size: 46,
          borderRadius: 10,
          backgroundColor: logoBackgroundColor,
          padding: assetPath.endsWith('fcad_uner.png')
              ? const EdgeInsets.all(2)
              : assetPath.endsWith('pscs_institucional.webp')
              ? const EdgeInsets.all(2)
              : const EdgeInsets.all(6),
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF174D3C),
                ),
              ),
              const SizedBox(height: 2),
              Text(place, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(fontSize: 12, color: Color(0xFF5F7269)),
              ),
              const SizedBox(height: 6),
              _ActionButton(
                action: ContactAction(
                  label: 'Cómo llegar',
                  url: mapsUrl,
                  icon: 'web',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EncounterActionGroup extends StatelessWidget {
  const _EncounterActionGroup();

  @override
  Widget build(BuildContext context) {
    final consultAction = encounterActions.first;
    final officialAction = encounterActions.last;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFD2C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 13, 14, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contacto e información',
                  style: TextStyle(
                    color: Color(0xFF174D3C),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Comunicate con la organización o revisá la publicación institucional.',
                  style: TextStyle(color: Color(0xFF5F7269), fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 330;
              final consult = _EncounterActionCell(
                action: consultAction,
                title: 'Consultar',
                subtitle: 'Enviar un correo',
                icon: Icons.mail_outline_rounded,
              );
              final official = _EncounterActionCell(
                action: officialAction,
                title: 'Sitio oficial',
                subtitle: 'Ver la publicación',
                icon: Icons.open_in_new_rounded,
              );

              if (!horizontal) {
                return Column(
                  children: [consult, const Divider(height: 1), official],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: consult),
                    const VerticalDivider(width: 1),
                    Expanded(child: official),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EncounterActionCell extends StatelessWidget {
  const _EncounterActionCell({
    required this.action,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final ContactAction action;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => _launchExternalUrl(context, action.url),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: const Color(0xFF174D3C),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF174D3C),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF5F7269),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF5F7269),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsefulInformationCard extends StatelessWidget {
  const _UsefulInformationCard();

  @override
  Widget build(BuildContext context) {
    final action = tourismActions.first;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 12),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Color(0xFF174D3C)),
                SizedBox(width: 10),
                Text(
                  'Información útil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF174D3C),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => _launchExternalUrl(context, action.url),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(14, 13, 12, 14),
                child: Row(
                  children: [
                    _InformationIcon(),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guía turística oficial',
                            style: TextStyle(
                              color: Color(0xFF174D3C),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Atractivos, alojamiento, gastronomía y novedades de Concordia.',
                            style: TextStyle(
                              color: Color(0xFF5F7269),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: Color(0xFF5F7269),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationIcon extends StatelessWidget {
  const _InformationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.travel_explore_rounded, color: Color(0xFF174D3C)),
    );
  }
}

class _HighlightsGrid extends StatelessWidget {
  const _HighlightsGrid();

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    final items = homeHighlights;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _buildHighlightCard(items[0])),
              const SizedBox(width: spacing),
              Expanded(flex: 1, child: _buildHighlightCard(items[1])),
            ],
          ),
        ),
        const SizedBox(height: spacing),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: _buildHighlightCard(items[2])),
              const SizedBox(width: spacing),
              Expanded(flex: 2, child: _buildHighlightCard(items[3])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard(HomeHighlight item) {
    final icon = switch (item.title) {
      'Dónde dormir' => Icons.bed_rounded,
      'Comida práctica' => Icons.lunch_dining_rounded,
      'Gastronomía' => Icons.restaurant_rounded,
      'Paseos' => Icons.place_rounded,
      _ => Icons.place_rounded,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Color(0xFF5F7269)),
            ),
            const SizedBox(height: 10),
            Icon(icon, size: 32, color: const Color(0xFF174D3C)),
            const SizedBox(height: 4),
            Text(
              item.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.favoritesCount,
    required this.onOpenCategory,
  });

  final int favoritesCount;
  final ValueChanged<int> onOpenCategory;

  @override
  Widget build(BuildContext context) {
    final quickCards = [
      (
        'Dormir',
        'Alternativas para viajar solo, en pareja o en grupo.',
        Icons.bed_rounded,
        1,
      ),
      (
        'Comer',
        'Viandas, rotiserías, bares y restaurantes.',
        Icons.restaurant_rounded,
        4,
      ),
      (
        'Paseos',
        'Ideas para aprovechar tu tiempo libre en Concordia.',
        Icons.map_rounded,
        3,
      ),
      (
        'Favoritos',
        favoritesCount == 0
            ? 'Todavía no guardaste ninguna opción.'
            : favoritesCount == 1
            ? '1 opción guardada.'
            : '$favoritesCount opciones guardadas.',
        Icons.bookmark_rounded,
        0,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: quickCards
              .map((card) {
                return SizedBox(
                  width: cardWidth,
                  height: 150,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onOpenCategory(card.$4),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(card.$3, color: const Color(0xFF174D3C)),
                            const SizedBox(height: 10),
                            Text(
                              card.$1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card.$2,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF5F7269),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                })
                .toList(growable: false),
          );
        },
      );
  }
}

class _OpportunityListTab extends StatelessWidget {
  const _OpportunityListTab({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.favorites,
    required this.onFavoriteToggle,
    this.onOpenMap,
    this.notice,
  });

  final String title;
  final String subtitle;
  final List<OpportunityItem> items;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;
  final VoidCallback? onOpenMap;
  final String? notice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        Text(
          subtitle,
          style: const TextStyle(fontSize: 15, color: Color(0xFF5F7269)),
        ),
        const SizedBox(height: 12),
        if (notice != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8D9AF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 19,
                  color: Color(0xFF7A6125),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    notice!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5B4A22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else
          const SizedBox(height: 4),
        if (onOpenMap != null) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenMap,
              icon: const Icon(Icons.map_rounded),
              label: const Text('Ver lugares en el mapa'),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (items.isEmpty)
          const _EmptyState(
            title: 'No encontramos resultados',
            body: 'Probá con otro nombre o una palabra más general.',
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: OpportunityCard(
                item: item,
                isFavorite: favorites.contains(item.id),
                onFavoriteToggle: onFavoriteToggle,
              ),
            ),
          ),
      ],
    );
  }
}

class _FoodTab extends StatelessWidget {
  const _FoodTab({
    required this.viandas,
    required this.gastronomy,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  final List<OpportunityItem> viandas;
  final List<OpportunityItem> gastronomy;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('food'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        const Text(
          'Encontrá viandas para comer entre actividades y lugares para almorzar, cenar o disfrutar una salida en Concordia.',
          style: TextStyle(fontSize: 15, color: Color(0xFF5F7269)),
        ),
        const SizedBox(height: 18),
        if (viandas.isEmpty && gastronomy.isEmpty)
          const _EmptyState(
            title: 'No encontramos resultados',
            body: 'Probá con otro nombre o una palabra más general.',
          )
        else ...[
          if (viandas.isNotEmpty) ...[
            const _SectionHeading(
              title: 'Viandas y comida para llevar',
              subtitle: 'Opciones prácticas para las jornadas del Encuentro.',
            ),
            const SizedBox(height: 10),
            ...viandas.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OpportunityCard(
                  item: item,
                  isFavorite: favorites.contains(item.id),
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ),
            ),
          ],
          if (gastronomy.isNotEmpty) ...[
            const SizedBox(height: 8),
            const _SectionHeading(
              title: 'Restaurantes, bares y pizzerías',
              subtitle: 'Para almorzar, cenar o hacer una salida.',
            ),
            const SizedBox(height: 10),
            ...gastronomy.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OpportunityCard(
                  item: item,
                  isFavorite: favorites.contains(item.id),
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final OpportunityItem item;
  final bool isFavorite;
  final ValueChanged<String> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final highlight = item.tags.contains(OpportunityTag.highlighted);

    return Card(
      color: highlight ? const Color(0xFFEFF6EE) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.brandAsset != null) ...[
                  BrandAssetBox(
                    assetPath: item.brandAsset!,
                    fallbackIcon: Icons.account_balance_rounded,
                    size: 52,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF174D3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F7269),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Quitar de favoritos'
                      : 'Guardar en favoritos',
                  onPressed: () => onFavoriteToggle(item.id),
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFavorite
                        ? const Color(0xFFE3A300)
                        : const Color(0xFF5F7269),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            if (item.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.tags.map(_tagChip).toList(growable: false),
              ),
            const SizedBox(height: 12),
            ...item.highlights.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Color(0xFF2F7455),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(entry)),
                  ],
                ),
              ),
            ),
            if (item.note != null) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFC9D8D0)),
                ),
                child: Text(
                  item.note!,
                  style: const TextStyle(
                    color: Color(0xFF203129),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            if (item.actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.actions
                    .map((action) => _ActionButton(action: action))
                    .toList(growable: false),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tagChip(OpportunityTag tag) {
    final data = switch (tag) {
      OpportunityTag.group => ('Para grupos', const Color(0xFFDDEFE4)),
      OpportunityTag.budget => ('Económico', const Color(0xFFF5ECD3)),
      OpportunityTag.direct => ('Contacto directo', const Color(0xFFE6EEF7)),
      OpportunityTag.classic => ('Clásico', const Color(0xFFF3E2E2)),
      OpportunityTag.thermal => ('Termal', const Color(0xFFE4F0F4)),
      OpportunityTag.practical => ('Práctico', const Color(0xFFE9F4E6)),
      OpportunityTag.paseo => ('Para visitar', const Color(0xFFE7EFFA)),
      OpportunityTag.highlighted => ('Recomendado', const Color(0xFFE4F5EB)),
      OpportunityTag.culture => ('Cultural', const Color(0xFFF1E7F7)),
      OpportunityTag.outdoors => ('Al aire libre', const Color(0xFFE3F2E9)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: data.$2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        data.$1,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF174D3C),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final ContactAction action;

  @override
  Widget build(BuildContext context) {
    final isPrimary = action.label == 'WhatsApp';
    final iconData = switch (action.icon) {
      'whatsapp' => Icons.chat_rounded,
      'mail' => Icons.mail_outline_rounded,
      'price' => Icons.price_change_rounded,
      _ => Icons.open_in_new_rounded,
    };

    final style = FilledButton.styleFrom(
      backgroundColor: const Color(0xFFE8F3EA),
      foregroundColor: const Color(0xFF174D3C),
    );
    return FilledButton.icon(
      style: style,
      onPressed: () => _launchExternalUrl(context, action.url),
      icon: Icon(iconData),
      label: Text(action.label),
    );
  }
}

Future<void> _launchExternalUrl(BuildContext context, String rawUrl) async {
  final uri = Uri.tryParse(rawUrl);
  if (uri == null ||
      !const {'http', 'https', 'mailto', 'tel'}.contains(uri.scheme)) {
    _showExternalLaunchError(context);
    return;
  }

  bool launched = false;
  try {
    launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException {
    launched = false;
  } on FormatException {
    launched = false;
  }
  if (!context.mounted || launched) return;
  _showExternalLaunchError(context);
}

void _showExternalLaunchError(BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'No pudimos abrir el enlace. Verificá que tengas una aplicación compatible.',
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF174D3C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF5F7269), fontSize: 14),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Color(0xFF5F7269),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF5F7269)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            icon,
            size: 22,
            color: isSelected
                ? const Color(0xFF174D3C)
                : const Color(0xFF5F7269),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF174D3C)
                  : const Color(0xFF5F7269),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -27,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF174D3C),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF174D3C).withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 3,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF174D3C)
                      : const Color(0xFF5F7269),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon);

  final String label;
  final IconData icon;
}
