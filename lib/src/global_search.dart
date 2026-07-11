import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'brand_asset.dart';
import 'data.dart';
import 'map_screen.dart';
import 'models.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
    required this.onOpenTab,
    required this.onCopyMessage,
  });

  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<int> onOpenTab;
  final VoidCallback onCopyMessage;

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final Set<String> _favorites = Set<String>.of(widget.favorites);
  String _query = '';

  static const _shortcuts = <_SearchShortcut>[
    _SearchShortcut(
      id: 'map-all',
      title: 'Abrir mapa completo',
      subtitle: 'Alojamientos, comidas y paseos en una sola vista.',
      icon: Icons.map_rounded,
      keywords:
          'mapa map ubicacion ubicaciones puntos geolocalizacion donde queda donde estan como llegar llegar direcciones calles todos los lugares',
      action: _ShortcutAction.map,
      featured: true,
    ),
    _SearchShortcut(
      id: 'map-lodging',
      title: 'Mapa de alojamientos',
      subtitle: 'Ver hoteles, hostels, casas y departamentos.',
      icon: Icons.hotel_rounded,
      keywords:
          'mapa dormir alojamiento alojamientos hotel hoteles hostel hospedaje habitacion habitaciones casa departamento apart estadia reserva',
      action: _ShortcutAction.map,
      mapCategory: OpportunityCategory.lodging,
    ),
    _SearchShortcut(
      id: 'map-food',
      title: 'Mapa de comidas',
      subtitle: 'Ver viandas, bares, restaurantes y pizzerías.',
      icon: Icons.restaurant_rounded,
      keywords:
          'mapa comer comida comidas vianda viandas restaurante restaurantes bar bares pizzeria gastronomia almuerzo cena',
      action: _ShortcutAction.map,
      mapCategory: OpportunityCategory.viandas,
    ),
    _SearchShortcut(
      id: 'map-places',
      title: 'Mapa de paseos',
      subtitle: 'Ver atractivos turísticos y culturales.',
      icon: Icons.place_rounded,
      keywords:
          'mapa paseo paseos turismo atractivo atractivos museo museos parque costanera termas visitar cultura aire libre',
      action: _ShortcutAction.map,
      mapCategory: OpportunityCategory.places,
    ),
    _SearchShortcut(
      id: 'tab-lodging',
      title: 'Dónde dormir',
      subtitle: 'Explorar todas las opciones de alojamiento.',
      icon: Icons.bed_rounded,
      keywords:
          'dormir alojamiento alojamientos hotel hoteles hostel hospedaje hospedajes habitacion habitaciones apart departamento casa estadia economico barato reserva',
      action: _ShortcutAction.tab,
      tabIndex: 1,
      featured: true,
    ),
    _SearchShortcut(
      id: 'tab-food',
      title: 'Dónde comer',
      subtitle: 'Viandas, rotiserías, bares y restaurantes.',
      icon: Icons.restaurant_menu_rounded,
      keywords:
          'comer comida comidas vianda viandas rotiseria restaurante restaurantes bar bares pizzeria gastronomia almorzar cenar desayuno gluten celiaco',
      action: _ShortcutAction.tab,
      tabIndex: 4,
      featured: true,
    ),
    _SearchShortcut(
      id: 'tab-places',
      title: 'Paseos y atractivos',
      subtitle: 'Museos, parque, Costanera y propuesta termal.',
      icon: Icons.directions_walk_rounded,
      keywords:
          'paseo paseos turismo turista visitar atractivo atractivos museo museos parque costanera termas cultura historico aire libre salida',
      action: _ShortcutAction.tab,
      tabIndex: 3,
      featured: true,
    ),
    _SearchShortcut(
      id: 'encounter-home',
      title: 'Información del Encuentro',
      subtitle: 'Fechas, sedes, horarios y accesos principales.',
      icon: Icons.event_rounded,
      keywords:
          'encuentro evento historia entre rios fecha fechas horario horarios programa agenda sede sedes jueves viernes 13 14 agosto informacion inicio',
      action: _ShortcutAction.tab,
      tabIndex: 0,
      featured: true,
    ),
    _SearchShortcut(
      id: 'encounter-contact',
      title: 'Consultar a la organización',
      subtitle: 'Escribir al correo oficial del Encuentro.',
      icon: Icons.mail_outline_rounded,
      keywords:
          'consulta consultar contacto contactar correo mail email organizacion organizadores duda pregunta inscripcion participar',
      action: _ShortcutAction.external,
      url: 'mailto:historiadeentrerios.ines@gmail.com',
    ),
    _SearchShortcut(
      id: 'encounter-official',
      title: 'Sitio oficial del Encuentro',
      subtitle: 'Abrir la publicación institucional de INES.',
      icon: Icons.open_in_new_rounded,
      keywords:
          'sitio oficial informacion oficial programa convocatoria encuentro ines conicet uner organizadores instituciones',
      action: _ShortcutAction.external,
      url:
          'https://ines.conicet.gov.ar/iii-encuentro-sobre-historia-de-entre-rios/',
    ),
    _SearchShortcut(
      id: 'tourism-guide',
      title: 'Guía turística oficial',
      subtitle: 'Atractivos, alojamiento, gastronomía y novedades.',
      icon: Icons.travel_explore_rounded,
      keywords:
          'turismo guia oficial concordia informacion util turista agenda ciudad atractivos servicios portal',
      action: _ShortcutAction.external,
      url: 'https://www.concordia.gob.ar/turismo',
    ),
    _SearchShortcut(
      id: 'copy-message',
      title: 'Copiar consulta de alojamiento',
      subtitle: 'Mensaje preparado para WhatsApp o correo.',
      icon: Icons.content_copy_rounded,
      keywords:
          'copiar mensaje consulta alojamiento whatsapp correo reserva precio disponibilidad preguntar plantilla texto',
      action: _ShortcutAction.copy,
    ),
  ];

  static const _venues = <_SearchVenue>[
    _SearchVenue(
      id: 'pscs',
      title: 'Profesorado Superior de Ciencias Sociales',
      subtitle: 'Apertura y cine debate · Jueves 13 · 18:30',
      address: 'Hipólito Yrigoyen 1352',
      assetPath: 'assets/branding/pscs_institucional.webp',
      keywords:
          'sede sedes pscs profesorado superior ciencias sociales apertura cine debate documental jueves 13 18 30 hipolito yrigoyen 1352',
      mapsUrl:
          'https://www.google.com/maps/search/?api=1&query=Hip%C3%B3lito+Yrigoyen+1352+Concordia',
    ),
    _SearchVenue(
      id: 'fcad',
      title: 'Facultad de Ciencias de la Administración · UNER',
      subtitle: 'Mesas y exposiciones · Viernes 14 · desde las 8:00',
      address: 'Av. Monseñor Tavella 1424',
      assetPath: 'assets/branding/fcad_uner.png',
      keywords:
          'sede sedes fcad uner facultad ciencias administracion mesas exposiciones ponencias viernes 14 8 tavella monsenor 1424',
      mapsUrl:
          'https://www.google.com/maps/search/?api=1&query=Av.+Monse%C3%B1or+Tavella+1424+Concordia',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalized = _normalizeQuery(_query);
    final shortcutResults = _rankShortcuts(normalized);
    final venueResults = _rankVenues(normalized);
    final opportunityResults = _rankOpportunities(normalized);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: '¿Qué necesitás encontrar?',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Borrar búsqueda',
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                        _focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFC9D8D0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFC9D8D0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: Color(0xFF2F7455),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: normalized.isEmpty
            ? _emptySearchBody()
            : _resultsBody(
                normalized,
                shortcutResults,
                venueResults,
                opportunityResults,
              ),
      ),
    );
  }

  Widget _emptySearchBody() {
    final featured = _shortcuts.where((item) => item.featured).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        const Text(
          'Accesos rápidos',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF174D3C),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'También podés escribir pocas letras, una dirección o lo que querés hacer.',
          style: TextStyle(color: Color(0xFF5F7269)),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 10.0;
            final width = constraints.maxWidth >= 560
                ? (constraints.maxWidth - spacing * 2) / 3
                : (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: featured
                  .map(
                    (item) => SizedBox(
                      width: width,
                      child: _ShortcutCard(
                        shortcut: item,
                        compact: true,
                        onTap: () => _runShortcut(item),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Búsquedas sugeridas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF174D3C),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Cómo llegar a la FCAD',
            'Sedes del Encuentro',
            'Mapa de alojamientos',
            'Comida sin gluten',
            'Hotel económico',
            'Paseos históricos',
            'Termas',
            'Contacto oficial',
          ].map((label) {
            return ActionChip(
              avatar: const Icon(Icons.north_west_rounded, size: 17),
              label: Text(label),
              onPressed: () {
                _controller.text = label;
                _controller.selection = TextSelection.collapsed(
                  offset: label.length,
                );
                setState(() => _query = label);
                _focusNode.requestFocus();
              },
            );
          }).toList(growable: false),
        ),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFFEFF6EE),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF174D3C)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'La búsqueda reconoce abreviaturas, palabras incompletas, tildes y varios errores frecuentes de escritura.',
                    style: TextStyle(color: Color(0xFF203129)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultsBody(
    String normalized,
    List<_ScoredShortcut> shortcuts,
    List<_ScoredVenue> venues,
    List<_ScoredOpportunity> items,
  ) {
    final total = shortcuts.length + venues.length + items.length;
    if (total == 0) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 52),
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF5F7269)),
          const SizedBox(height: 12),
          const Text(
            'No encontramos una coincidencia clara',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Probá con una palabra más general, como “mapa”, “sede”, “hotel”, “comer” o “paseos”.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF5F7269)),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () => _openMap(),
            icon: const Icon(Icons.map_rounded),
            label: const Text('Abrir mapa completo'),
          ),
        ],
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
      children: [
        Text(
          total == 1 ? '1 resultado útil' : '$total resultados útiles',
          style: const TextStyle(color: Color(0xFF5F7269), fontSize: 13),
        ),
        if (shortcuts.isNotEmpty) ...[
          const SizedBox(height: 14),
          const _ResultHeading('Acciones y accesos'),
          const SizedBox(height: 8),
          ...shortcuts.take(5).map(
                (result) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ShortcutCard(
                    shortcut: result.shortcut,
                    onTap: () => _runShortcut(result.shortcut),
                  ),
                ),
              ),
        ],
        if (venues.isNotEmpty) ...[
          const SizedBox(height: 14),
          const _ResultHeading('Sedes del Encuentro'),
          const SizedBox(height: 8),
          ...venues.map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _VenueCard(
                venue: result.venue,
                onDirections: () => _launchExternal(result.venue.mapsUrl),
                onOfficial: () => _launchExternal(
                  'https://ines.conicet.gov.ar/iii-encuentro-sobre-historia-de-entre-rios/',
                ),
              ),
            ),
          ),
        ],
        if (items.isNotEmpty) ...[
          const SizedBox(height: 14),
          const _ResultHeading('Lugares y servicios'),
          const SizedBox(height: 8),
          ...items.take(18).map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OpportunitySearchCard(
                item: result.item,
                isFavorite: _favorites.contains(result.item.id),
                onFavorite: () => _toggleFavorite(result.item.id),
                onDetails: () => _showOpportunityDetails(result.item),
                onMap: result.item.hasMapLocation
                    ? () => _openMap(itemId: result.item.id)
                    : null,
                onPrimaryAction: _primaryAction(result.item) == null
                    ? null
                    : () => _launchExternal(_primaryAction(result.item)!.url),
                primaryActionLabel: _primaryAction(result.item)?.label,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<_ScoredShortcut> _rankShortcuts(String query) {
    if (query.isEmpty) return const [];
    final results = <_ScoredShortcut>[];
    for (final shortcut in _shortcuts) {
      final score = _scoreText(
        query,
        '${shortcut.title} ${shortcut.subtitle} ${shortcut.keywords}',
      );
      if (score >= _minimumScore(query)) {
        results.add(_ScoredShortcut(shortcut, score));
      }
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  List<_ScoredVenue> _rankVenues(String query) {
    if (query.isEmpty) return const [];
    final results = <_ScoredVenue>[];
    for (final venue in _venues) {
      final score = _scoreText(
        query,
        '${venue.title} ${venue.subtitle} ${venue.address} ${venue.keywords}',
      );
      if (score >= _minimumScore(query)) {
        results.add(_ScoredVenue(venue, score));
      }
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  List<_ScoredOpportunity> _rankOpportunities(String query) {
    if (query.isEmpty) return const [];
    final results = <_ScoredOpportunity>[];
    for (final item in opportunities) {
      final categoryAliases = _categoryAliases(item.category);
      final tagAliases = item.tags.map(_tagAliases).join(' ');
      final text = [
        item.searchableText,
        item.mapAddress ?? '',
        categoryAliases,
        tagAliases,
        _itemAliases(item),
      ].join(' ');
      final score = _scoreText(query, text);
      if (score >= _minimumScore(query)) {
        results.add(_ScoredOpportunity(item, score));
      }
    }
    results.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.item.title.compareTo(b.item.title);
    });
    return results;
  }

  int _minimumScore(String query) {
    if (query.length <= 2) return 22;
    if (query.length <= 4) return 26;
    return 30;
  }

  int _scoreText(String rawQuery, String rawTarget) {
    final query = _normalizeQuery(rawQuery);
    final target = _normalizeQuery(rawTarget);
    if (query.isEmpty || target.isEmpty) return 0;

    var score = 0;
    if (target == query) score += 180;
    if (target.startsWith(query)) score += 90;
    if (target.contains(query)) score += 72;

    final queryTokens = query.split(' ').where((token) => token.isNotEmpty);
    final targetTokens = target.split(' ').where((token) => token.isNotEmpty).toList();
    var matchedTokens = 0;

    for (final queryToken in queryTokens) {
      var best = 0;
      for (final targetToken in targetTokens) {
        if (targetToken == queryToken) {
          best = math.max(best, 38).toInt();
        } else if (targetToken.startsWith(queryToken)) {
          best = math.max(best, queryToken.length <= 2 ? 24 : 31).toInt();
        } else if (queryToken.startsWith(targetToken) && targetToken.length >= 3) {
          best = math.max(best, 20).toInt();
        } else if (queryToken.length >= 4 && targetToken.length >= 4) {
          final distance = _levenshtein(queryToken, targetToken);
          if (distance == 1) {
            best = math.max(best, 22).toInt();
          } else if (distance == 2 && queryToken.length >= 6) {
            best = math.max(best, 13).toInt();
          }
        }
      }
      if (best > 0) matchedTokens++;
      score += best;
    }

    final tokenCount = queryTokens.length;
    if (tokenCount > 1 && matchedTokens == tokenCount) score += 42;
    if (tokenCount > 1 && matchedTokens < tokenCount) score -= 18;
    return score;
  }

  String _normalizeQuery(String value) {
    return normalizeSearchText(value)
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var previous = List<int>.generate(b.length + 1, (index) => index);
    for (var i = 0; i < a.length; i++) {
      final current = List<int>.filled(b.length + 1, 0);
      current[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final insertion = current[j] + 1;
        final deletion = previous[j + 1] + 1;
        final substitution = previous[j] + (a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1);
        current[j + 1] = math.min(
          insertion,
          math.min(deletion, substitution),
        ).toInt();
      }
      previous = current;
    }
    return previous.last;
  }

  String _categoryAliases(OpportunityCategory category) {
    return switch (category) {
      OpportunityCategory.lodging =>
        'dormir alojamiento alojamientos hotel hoteles hostel hospedaje habitacion habitaciones apart departamento casa estadia reserva',
      OpportunityCategory.viandas =>
        'comer comida vianda viandas rotiseria almuerzo cena practico pedido retiro entrega',
      OpportunityCategory.gastronomy =>
        'comer comida restaurante restaurantes bar bares pizzeria gastronomia almuerzo cena salida',
      OpportunityCategory.places =>
        'paseo paseos turismo atractivo atractivos museo parque costanera termas visitar cultura historico aire libre',
    };
  }

  String _tagAliases(OpportunityTag tag) {
    return switch (tag) {
      OpportunityTag.group => 'grupo grupos compartir colegas varias personas',
      OpportunityTag.budget => 'economico economica barato barata presupuesto bajo costo',
      OpportunityTag.direct => 'contacto directo whatsapp telefono correo',
      OpportunityTag.classic => 'clasico tradicional historico',
      OpportunityTag.thermal => 'termal termas agua caliente descanso spa',
      OpportunityTag.practical => 'practico rapido cercano sencillo',
      OpportunityTag.paseo => 'paseo visitar turismo',
      OpportunityTag.highlighted => 'recomendado destacado sugerido',
      OpportunityTag.culture => 'cultura cultural historia museo patrimonio',
      OpportunityTag.outdoors => 'aire libre naturaleza parque caminar',
    };
  }


  String _itemAliases(OpportunityItem item) {
    final searchable = item.searchableText;
    final aliases = <String>[];
    if (searchable.contains('gluten')) {
      aliases.add('celiaco celiaca celiaquia sin tacc gluten free');
    }
    if (searchable.contains('termal') || searchable.contains('termas')) {
      aliases.add('spa agua caliente pileta descanso complejo termal');
    }
    if (searchable.contains('museo')) {
      aliases.add('historia patrimonio cultura exposicion visitar');
    }
    if (item.category == OpportunityCategory.lodging) {
      aliases.add('reservar noche pernoctar quedarse alojamiento estadia');
    }
    if (item.actions.any((action) => action.label == 'WhatsApp')) {
      aliases.add('whatsapp mensaje contacto telefono consultar');
    }
    return aliases.join(' ');
  }

  ContactAction? _primaryAction(OpportunityItem item) {
    for (final action in item.actions) {
      if (action.label == 'WhatsApp') return action;
    }
    for (final action in item.actions) {
      if (action.label == 'Llamar') return action;
    }
    return item.actions.isEmpty ? null : item.actions.first;
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
    widget.onFavoriteToggle(id);
  }

  void _runShortcut(_SearchShortcut shortcut) {
    switch (shortcut.action) {
      case _ShortcutAction.tab:
        final tabIndex = shortcut.tabIndex;
        if (tabIndex == null) return;
        Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onOpenTab(tabIndex);
        });
        return;
      case _ShortcutAction.map:
        _openMap(category: shortcut.mapCategory);
        return;
      case _ShortcutAction.external:
        final url = shortcut.url;
        if (url != null) _launchExternal(url);
        return;
      case _ShortcutAction.copy:
        widget.onCopyMessage();
        return;
    }
  }

  void _openMap({OpportunityCategory? category, String? itemId}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConcordiaMapScreen(
          initialCategory: category,
          initialItemId: itemId,
        ),
      ),
    );
  }

  Future<void> _launchExternal(String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || !const {'http', 'https', 'mailto', 'tel'}.contains(uri.scheme)) {
      _showLaunchError();
      return;
    }

    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on PlatformException {
      launched = false;
    } on FormatException {
      launched = false;
    }
    if (!mounted || launched) return;
    _showLaunchError();
  }

  void _showLaunchError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No pudimos abrir el enlace en este dispositivo.'),
      ),
    );
  }

  Future<void> _showOpportunityDetails(OpportunityItem item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.brandAsset != null) ...[
                    BrandAssetBox(
                      assetPath: item.brandAsset!,
                      fallbackIcon: Icons.place_rounded,
                      size: 58,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF174D3C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: const TextStyle(color: Color(0xFF5F7269)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(item.description, style: const TextStyle(fontSize: 15)),
              if (item.mapAddress != null) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.mapAddress!)),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              ...item.highlights.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
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
                      const SizedBox(width: 9),
                      Expanded(child: Text(entry)),
                    ],
                  ),
                ),
              ),
              if (item.note != null) ...[
                const SizedBox(height: 8),
                Card(
                  color: const Color(0xFFFFF8E7),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(item.note!),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (item.hasMapLocation)
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        _openMap(itemId: item.id);
                      },
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('Ver en el mapa'),
                    ),
                  ...item.actions.map(
                    (action) => OutlinedButton.icon(
                      onPressed: () => _launchExternal(action.url),
                      icon: Icon(_actionIcon(action)),
                      label: Text(action.label),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _actionIcon(ContactAction action) {
    return switch (action.icon) {
      'whatsapp' => Icons.chat_rounded,
      'mail' => Icons.mail_outline_rounded,
      'price' => Icons.price_change_rounded,
      _ => Icons.open_in_new_rounded,
    };
  }
}

class _ResultHeading extends StatelessWidget {
  const _ResultHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF174D3C),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.shortcut,
    required this.onTap,
    this.compact = false,
  });

  final _SearchShortcut shortcut;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 13 : 15),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(shortcut.icon, color: const Color(0xFF174D3C)),
                    const SizedBox(height: 14),
                    Text(
                      shortcut.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(shortcut.icon, color: const Color(0xFF174D3C)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shortcut.title,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            shortcut.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5F7269),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.venue,
    required this.onDirections,
    required this.onOfficial,
  });

  final _SearchVenue venue;
  final VoidCallback onDirections;
  final VoidCallback onOfficial;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEFF6EE),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandAssetBox(
                  assetPath: venue.assetPath,
                  fallbackIcon: Icons.account_balance_rounded,
                  size: 56,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(3),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF174D3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(venue.subtitle),
                      const SizedBox(height: 3),
                      Text(
                        venue.address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5F7269),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.directions_rounded),
                  label: const Text('Cómo llegar'),
                ),
                OutlinedButton.icon(
                  onPressed: onOfficial,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Información oficial'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunitySearchCard extends StatelessWidget {
  const _OpportunitySearchCard({
    required this.item,
    required this.isFavorite,
    required this.onFavorite,
    required this.onDetails,
    this.onMap,
    this.onPrimaryAction,
    this.primaryActionLabel,
  });

  final OpportunityItem item;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onDetails;
  final VoidCallback? onMap;
  final VoidCallback? onPrimaryAction;
  final String? primaryActionLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.brandAsset != null) ...[
                  BrandAssetBox(
                    assetPath: item.brandAsset!,
                    fallbackIcon: _categoryIcon(item.category),
                    size: 48,
                  ),
                  const SizedBox(width: 11),
                ] else ...[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _categoryIcon(item.category),
                      color: const Color(0xFF174D3C),
                    ),
                  ),
                  const SizedBox(width: 11),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF174D3C),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5F7269),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite ? 'Quitar de favoritos' : 'Guardar en favoritos',
                  onPressed: onFavorite,
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFavorite ? const Color(0xFFE3A300) : const Color(0xFF5F7269),
                  ),
                ),
              ],
            ),
            if (item.mapAddress != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 17),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      item.mapAddress!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 11),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text('Ver ficha'),
                ),
                if (onMap != null)
                  OutlinedButton.icon(
                    onPressed: onMap,
                    icon: const Icon(Icons.map_rounded),
                    label: const Text('Mapa'),
                  ),
                if (onPrimaryAction != null)
                  FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(primaryActionLabel == 'WhatsApp'
                        ? Icons.chat_rounded
                        : Icons.open_in_new_rounded),
                    label: Text(primaryActionLabel ?? 'Abrir'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(OpportunityCategory category) {
    return switch (category) {
      OpportunityCategory.lodging => Icons.bed_rounded,
      OpportunityCategory.viandas => Icons.lunch_dining_rounded,
      OpportunityCategory.gastronomy => Icons.restaurant_rounded,
      OpportunityCategory.places => Icons.place_rounded,
    };
  }
}

enum _ShortcutAction { tab, map, external, copy }

class _SearchShortcut {
  const _SearchShortcut({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.keywords,
    required this.action,
    this.tabIndex,
    this.mapCategory,
    this.url,
    this.featured = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String keywords;
  final _ShortcutAction action;
  final int? tabIndex;
  final OpportunityCategory? mapCategory;
  final String? url;
  final bool featured;
}

class _SearchVenue {
  const _SearchVenue({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.address,
    required this.assetPath,
    required this.keywords,
    required this.mapsUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String address;
  final String assetPath;
  final String keywords;
  final String mapsUrl;
}

class _ScoredShortcut {
  const _ScoredShortcut(this.shortcut, this.score);
  final _SearchShortcut shortcut;
  final int score;
}

class _ScoredVenue {
  const _ScoredVenue(this.venue, this.score);
  final _SearchVenue venue;
  final int score;
}

class _ScoredOpportunity {
  const _ScoredOpportunity(this.item, this.score);
  final OpportunityItem item;
  final int score;
}
