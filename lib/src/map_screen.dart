import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'models.dart';

class ConcordiaMapScreen extends StatefulWidget {
  const ConcordiaMapScreen({super.key});

  @override
  State<ConcordiaMapScreen> createState() => _ConcordiaMapScreenState();
}

class _ConcordiaMapScreenState extends State<ConcordiaMapScreen> {
  static const _initialCenter = LatLng(-31.3848811, -58.0129170);
  static const _initialZoom = 13.0;
  static const _minZoom = 11.5;
  static const _maxZoom = 18.0;
  static const _zoomStep = 0.65;
  static const _labelZoom = 15.5;

  final MapController _mapController = MapController();
  final ValueNotifier<MapCamera?> _cameraNotifier = ValueNotifier(null);

  OpportunityItem? _selectedItem;
  OpportunityCategory? _selectedCategory;

  List<OpportunityItem> get _mapItems => opportunities
      .where((item) => item.hasMapLocation)
      .toList(growable: false);

  List<OpportunityItem> get _visibleMapItems =>
      _mapItems.where(_matchesSelectedCategory).toList(growable: false);

  bool _matchesSelectedCategory(OpportunityItem item) {
    final selectedCategory = _selectedCategory;
    if (selectedCategory == null) return true;
    if (selectedCategory == OpportunityCategory.viandas) {
      return item.category == OpportunityCategory.viandas ||
          item.category == OpportunityCategory.gastronomy;
    }
    return item.category == selectedCategory;
  }

  @override
  void dispose() {
    _cameraNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F4),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              minZoom: _minZoom,
              maxZoom: _maxZoom,
              onPositionChanged: (camera, _) {
                _cameraNotifier.value = camera;
              },
              onTap: (_, _) {
                if (_selectedItem != null) {
                  setState(() => _selectedItem = null);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'ar.maillet.encuentroer',
                tileDisplay: const TileDisplay.instantaneous(),
              ),
              ValueListenableBuilder<MapCamera?>(
                valueListenable: _cameraNotifier,
                builder: (context, camera, _) {
                  final zoom = camera?.zoom ?? _initialZoom;
                  return MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      markers: _buildMarkers(showLabels: zoom >= _labelZoom),
                      builder: _buildCluster,
                      maxClusterRadius: 60,
                      size: const Size(42, 42),
                      padding: const EdgeInsets.all(48),
                      maxZoom: _maxZoom,
                      disableClusteringAtZoom: 16,
                      zoomToBoundsOnClick: true,
                      centerMarkerOnClick: false,
                      spiderfyCluster: false,
                      showPolygon: false,
                      animationsOptions: const AnimationsOptions(
                        zoom: Duration(milliseconds: 180),
                        fitBound: Duration(milliseconds: 180),
                        centerMarker: Duration(milliseconds: 120),
                        spiderfy: Duration(milliseconds: 0),
                      ),
                      onMarkerTap: _handleMarkerTap,
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 16,
            child: _MapControl(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Volver a paseos',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 190,
            right: 16,
            child: _zoomControls(),
          ),
          Positioned(
            left: 4,
            right: 4,
            bottom: bottomInset + 104,
            child: _categoryFilters(),
          ),
          Positioned(
            bottom: bottomInset + 126,
            right: 22,
            child: const Opacity(
              opacity: 0,
              child: Text(
                '© OSM · CARTO',
                style: TextStyle(color: Color(0xFF5F7269), fontSize: 7),
              ),
            ),
          ),
          if (_selectedItem == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomInset + 16,
              child: _mapSummary(),
            )
          else
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomInset + 16,
              child: _selectedCard(_selectedItem!),
            ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers({required bool showLabels}) {
    return _visibleMapItems
        .map(
          (item) => Marker(
            key: ValueKey(item.id),
            point: LatLng(item.latitude!, item.longitude!),
            width: showLabels ? 190 : 44,
            height: 48,
            child: _MapMarker(
              item: item,
              showLabel: showLabels,
              isSelected: item.id == _selectedItem?.id,
              color: _categoryColor(item.category),
              icon: _categoryIcon(item.category),
            ),
          ),
        )
        .toList(growable: false);
  }

  Widget _buildCluster(BuildContext context, List<Marker> markers) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF174D3C),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE8F3EA), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        markers.length.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _handleMarkerTap(Marker marker) {
    final key = marker.key;
    if (key is! ValueKey<String>) return;

    final item = _mapItems.where((candidate) => candidate.id == key.value);
    if (item.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _ItemDetailPage(item: item.first)),
    );
  }

  Widget _zoomControls() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _MapControl(
            icon: Icons.add_rounded,
            tooltip: 'Acercar',
            onPressed: () => _zoomBy(_zoomStep),
          ),
          const Divider(height: 1, indent: 8, endIndent: 8),
          _MapControl(
            icon: Icons.remove_rounded,
            tooltip: 'Alejar',
            onPressed: () => _zoomBy(-_zoomStep),
          ),
        ],
      ),
    );
  }

  Widget _categoryFilters() {
    return Row(
      children: [
        Expanded(
          child: _categoryChip(
            label: 'Todos',
            icon: Icons.layers_rounded,
            overlap: 0,
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: _categoryChip(
            label: 'Hoteles',
            icon: Icons.hotel_rounded,
            category: OpportunityCategory.lodging,
            overlap: 3,
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: _categoryChip(
            label: 'Comida',
            icon: Icons.restaurant_rounded,
            category: OpportunityCategory.viandas,
            overlap: 6,
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: _categoryChip(
            label: 'Paseos',
            icon: Icons.place_rounded,
            category: OpportunityCategory.places,
            overlap: 9,
          ),
        ),
      ],
    );
  }

  Widget _categoryChip({
    required String label,
    required IconData icon,
    OpportunityCategory? category,
    double overlap = 0,
  }) {
    final selected = _selectedCategory == category;
    return SizedBox(
      width: double.infinity,
      child: Transform.translate(
        offset: Offset(-overlap, 0),
        child: Transform.scale(
          // Cada filtro gana otros 5 px sin convertir la fila en scrollable.
          scaleX: 1.10,
          child: ChoiceChip(
            label: Text(label, overflow: TextOverflow.ellipsis),
            avatar: Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : _categoryColor(category),
            ),
            selected: selected,
            showCheckmark: false,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
            labelPadding: const EdgeInsets.only(left: 2, right: 2),
            labelStyle: TextStyle(
              color: selected ? Colors.white : const Color(0xFF174D3C),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            selectedColor: const Color(0xFF174D3C),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFC9D8D0)),
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
                if (_selectedItem != null &&
                    !_matchesSelectedCategory(_selectedItem!)) {
                  _selectedItem = null;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Color _categoryColor(OpportunityCategory? category) {
    return switch (category) {
      OpportunityCategory.lodging => const Color(0xFF2F7455),
      OpportunityCategory.viandas ||
      OpportunityCategory.gastronomy => const Color(0xFFE07A2D),
      OpportunityCategory.places => const Color(0xFF3F6FB5),
      null => const Color(0xFF174D3C),
    };
  }

  IconData _categoryIcon(OpportunityCategory category) {
    return switch (category) {
      OpportunityCategory.lodging => Icons.hotel_rounded,
      OpportunityCategory.viandas ||
      OpportunityCategory.gastronomy => Icons.restaurant_rounded,
      OpportunityCategory.places => Icons.place_rounded,
    };
  }

  void _zoomBy(double delta) {
    final camera = _cameraNotifier.value;
    final center = camera?.center ?? _initialCenter;
    final zoom = camera?.zoom ?? _initialZoom;
    final nextZoom = (zoom + delta).clamp(_minZoom, _maxZoom).toDouble();
    if ((nextZoom - zoom).abs() < 0.01) return;
    _mapController.move(center, nextZoom);
  }

  Widget _mapSummary() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            const Icon(Icons.map_rounded, color: Color(0xFF174D3C)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lugares para conocer',
                    style: TextStyle(
                      color: Color(0xFF174D3C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${_visibleMapItems.length} ubicaciones visibles en Concordia',
                    style: const TextStyle(
                      color: Color(0xFF5F7269),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.touch_app_rounded, color: Color(0xFF5F7269)),
          ],
        ),
      ),
    );
  }

  Widget _selectedCard(OpportunityItem item) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _categoryColor(item.category).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _categoryIcon(item.category),
                color: _categoryColor(item.category),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF174D3C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.mapAddress ?? item.subtitle,
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
              tooltip: 'Abrir ubicación',
              onPressed: () => _openLocation(item),
              icon: const Icon(Icons.directions_rounded),
            ),
            IconButton(
              tooltip: 'Cerrar selección',
              onPressed: () => setState(() => _selectedItem = null),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocation(OpportunityItem item) async {
    final query = item.mapAddress ?? item.title;
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$query, Concordia, Entre Ríos',
    });
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!mounted || launched) return;
      _showMessage('No pudimos abrir la ubicación.');
    } catch (_) {
      if (mounted) _showMessage('No pudimos abrir la ubicación.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MapControl extends StatelessWidget {
  const _MapControl({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: const Color(0xFF174D3C)),
      ),
    );
  }
}

class _ItemDetailPage extends StatelessWidget {
  const _ItemDetailPage({required this.item});

  final OpportunityItem item;

  @override
  Widget build(BuildContext context) {
    final highlight = item.tags.contains(OpportunityTag.highlighted);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F4),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF174D3C)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          Card(
            color: highlight ? const Color(0xFFEFF6EE) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                          .map((action) => _DetailActionButton(action: action))
                          .toList(growable: false),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
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

class _DetailActionButton extends StatelessWidget {
  const _DetailActionButton({required this.action});

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

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.item,
    required this.showLabel,
    required this.isSelected,
    required this.color,
    required this.icon,
  });

  final OpportunityItem item;
  final bool showLabel;
  final bool isSelected;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final markerColor = isSelected ? color.withValues(alpha: 0.82) : color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 42 : 34,
          height: isSelected ? 42 : 34,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
        if (showLabel) ...[
          const SizedBox(width: 5),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF174D3C),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
