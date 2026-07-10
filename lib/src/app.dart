import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
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
      title: 'III Encuentro ER',
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
  String _query = '';
  final Set<String> _favorites = <String>{};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;
  double _headerSearchProgress = 0;

  static const _tabs = [
    _TabSpec('Inicio', Icons.home_rounded),
    _TabSpec('Dormir', Icons.bed_rounded),
    _TabSpec('Mapa', Icons.map_rounded),
    _TabSpec('Paseos', Icons.directions_walk_rounded),
    _TabSpec('Comer', Icons.restaurant_rounded),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProgress = _isSearchExpanded ? 1.0 : _headerSearchProgress;
    final screen = switch (_currentIndex) {
      0 => _HomeTab(
        favoritesCount: _favorites.length,
        onOpenCategory: _openCategory,
        onCopyMessage: _copyMessage,
      ),
      1 => _OpportunityListTab(
        title: 'Dónde dormir',
        subtitle: 'Opciones para distintos presupuestos y formas de viaje.',
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
        title: 'Paseos y lugares para conocer',
        subtitle: 'Ideas para aprovechar tus ratos libres en Concordia.',
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
      appBar: _MorphingTopBar(
        title: _tabs[_currentIndex].label,
        progress: searchProgress,
        controller: _searchController,
        focusNode: _searchFocusNode,
        showSearchClose: _isSearchExpanded,
        onExpandSearch: _expandSearch,
        onCollapseSearch: _collapseSearch,
        onSearchChanged: (value) => setState(() => _query = value),
        onOpenMap: _currentIndex == 3 ? _openMap : null,
      ),
      body: SafeArea(
        top: false,
        child: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: screen,
          ),
        ),
      ),
      bottomNavigationBar: MediaQuery.withNoTextScaling(
        child: Container(
          height: 51,
          clipBehavior: Clip.none,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFC9D8D0)),
            ),
          ),
          child: Row(
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
        ),
      ),
    );
  }

  List<OpportunityItem> _filterItems(OpportunityCategory category) {
    final base = opportunities.where((item) => item.category == category);
    final query = normalizeSearchText(_query);
    if (query.isEmpty) {
      return base.toList(growable: false);
    }
    return base
        .where((item) => item.searchableText.contains(query))
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
      _query = '';
      _isSearchExpanded = false;
      _headerSearchProgress = 0;
    });
    _searchFocusNode.unfocus();
    _searchController.clear();
  }

  void _expandSearch() {
    if (_isSearchExpanded) {
      _searchFocusNode.requestFocus();
      return;
    }
    setState(() => _isSearchExpanded = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _collapseSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _query = '';
      _isSearchExpanded = false;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isSearchExpanded) return false;
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
    required this.controller,
    required this.focusNode,
    required this.showSearchClose,
    required this.onExpandSearch,
    required this.onCollapseSearch,
    required this.onSearchChanged,
    this.onOpenMap,
  });

  final String title;
  final double progress;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showSearchClose;
  final VoidCallback onExpandSearch;
  final VoidCallback onCollapseSearch;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onOpenMap;

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0, 1.0);
    final titleOpacity = (1 - normalizedProgress * 3).clamp(0.0, 1.0);

    return AppBar(
      toolbarHeight: 78,
      titleSpacing: 0,
      title: SizedBox(
        width: double.infinity,
        height: 78,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              right: 116,
              top: 7,
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
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF174D3C),
                          ),
                        ),
                        const Text(
                          'III Encuentro · Concordia · agosto 2026',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
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
                top: 15,
                right: 68,
                child: Opacity(
                  opacity: titleOpacity,
                  child: Transform.translate(
                    offset: Offset(0, -8 * normalizedProgress),
                    child: IconButton(
                      tooltip: 'Ver lugares en el mapa',
                      onPressed: onOpenMap,
                      icon: const Icon(Icons.map_rounded),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 16,
              right: 16,
              top: 15,
              child: _ExpandableSearchBar(
                progress: normalizedProgress,
                showClose: showSearchClose,
                controller: controller,
                focusNode: focusNode,
                onExpand: onExpandSearch,
                onCollapse: onCollapseSearch,
                onChanged: onSearchChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableSearchBar extends StatelessWidget {
  const _ExpandableSearchBar({
    required this.progress,
    required this.showClose,
    required this.controller,
    required this.focusNode,
    required this.onExpand,
    required this.onCollapse,
    required this.onChanged,
  });

  final double progress;
  final bool showClose;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final normalizedProgress = progress.clamp(0.0, 1.0);
        final textOpacity = ((normalizedProgress - 0.25) / 0.75).clamp(
          0.0,
          1.0,
        );
        final width = 48 + (constraints.maxWidth - 48) * normalizedProgress;
        final interactive = normalizedProgress > 0.92;

        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedContainer(
            duration: Duration(milliseconds: showClose ? 340 : 70),
            curve: showClose ? Curves.easeOutCubic : Curves.linear,
            width: width,
            height: 48,
            clipBehavior: Clip.antiAlias,
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
                  color: Color.fromRGBO(0, 0, 0, 0.08 * normalizedProgress),
                  blurRadius: 10 * normalizedProgress,
                  offset: Offset(0, 3 * normalizedProgress),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: !interactive,
                    child: Opacity(
                      opacity: textOpacity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 44, right: 42),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: onChanged,
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(
                            color: Color(0xFF203129),
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Buscar alojamiento, comida o paseo',
                            hintStyle: TextStyle(color: Color(0xFF5F7269)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: interactive ? 'Buscar' : 'Abrir búsqueda',
                    onPressed: onExpand,
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF174D3C),
                    ),
                  ),
                ),
                if (showClose)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Cerrar búsqueda',
                      onPressed: onCollapse,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF5F7269),
                        size: 20,
                      ),
                    ),
                  ),
              ],
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
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFFF7FBF6), Color(0xFFE8F3EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFC9D8D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10),
              const Text(
                'Guía práctica para quienes asisten al III Encuentro sobre '
                'Historia de Entre Ríos: dónde dormir, qué comer y qué hacer en los ratos libres.',
                style: TextStyle(fontSize: 15, color: Color(0xFF203129)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onCopyMessage,
                    icon: const Icon(Icons.content_copy_rounded),
                    label: const Text('Copiar consulta de alojamiento'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => onOpenCategory(1),
                    icon: const Icon(Icons.bed_rounded),
                    label: const Text('Ver dónde dormir'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                  'Para organizar tu estadía',
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _QuickAccessGrid(
          favoritesCount: favoritesCount,
          onOpenCategory: onOpenCategory,
        ),
      ],
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF5F7269),
              ),
            ),
            const SizedBox(height: 14),
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
        'Opciones para viajar solo, en pareja o con colegas.',
        Icons.bed_rounded,
        1,
      ),
      (
        'Comer',
        'Viandas, rotiserías y lugares para sentarte a comer.',
        Icons.restaurant_rounded,
        4,
      ),
      (
        'Paseos',
        'Ideas para aprovechar los ratos libres en Concordia.',
        Icons.map_rounded,
        3,
      ),
      (
        'Favoritos',
        favoritesCount == 0
            ? 'Todavía no guardaste ninguna opción.'
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onOpenCategory(card.$4),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(card.$3, color: const Color(0xFF174D3C)),
                            const SizedBox(height: 16),
                            Text(
                              card.$1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              card.$2,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
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
  });

  final String title;
  final String subtitle;
  final List<OpportunityItem> items;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;
  final VoidCallback? onOpenMap;

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
        const SizedBox(height: 16),
        if (onOpenMap != null) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenMap,
              icon: const Icon(Icons.map_rounded),
              label: const Text('Ver mapa de lugares'),
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
          'Encontrá viandas para comer entre actividades y lugares para disfrutar una salida en Concordia.',
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
              title: 'Viandas y comida rápida',
              subtitle: 'Opciones prácticas para los días del Encuentro.',
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
              title: 'Restaurantes y sabores locales',
              subtitle: 'Para almorzar, cenar o aprovechar una salida.',
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
      OpportunityTag.group => ('Para varias personas', const Color(0xFFDDEFE4)),
      OpportunityTag.budget => ('Económico', const Color(0xFFF5ECD3)),
      OpportunityTag.direct => ('Contacto directo', const Color(0xFFE6EEF7)),
      OpportunityTag.classic => ('Clásico', const Color(0xFFF3E2E2)),
      OpportunityTag.thermal => ('Termal', const Color(0xFFE4F0F4)),
      OpportunityTag.practical => ('Práctico', const Color(0xFFE9F4E6)),
      OpportunityTag.paseo => ('Para visitar', const Color(0xFFE7EFFA)),
      OpportunityTag.highlighted => ('Recomendado', const Color(0xFFE4F5EB)),
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

    return isPrimary
        ? FilledButton.icon(
            onPressed: () => _open(context, action.url),
            icon: Icon(iconData),
            label: Text(action.label),
          )
        : OutlinedButton.icon(
            onPressed: () => _open(context, action.url),
            icon: Icon(iconData),
            label: Text(action.label),
          );
  }

  Future<void> _open(BuildContext context, String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null ||
        !const {'http', 'https', 'mailto', 'tel'}.contains(uri.scheme)) {
      _showLaunchError(context, rawUrl);
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
    _showLaunchError(context, rawUrl);
  }

  void _showLaunchError(BuildContext context, String rawUrl) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No pudimos abrir este enlace: $rawUrl')),
    );
  }
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
            color: isSelected ? const Color(0xFF174D3C) : const Color(0xFF5F7269),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF174D3C) : const Color(0xFF5F7269),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Transform.translate(
            offset: const Offset(0, -14),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF174D3C)
                    : const Color(0xFFE8F3EA),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF174D3C).withValues(alpha: isSelected ? 0.35 : 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF174D3C),
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF174D3C) : const Color(0xFF5F7269),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon);

  final String label;
  final IconData icon;
}
