import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'brand_asset.dart';
import 'data.dart';
import 'models.dart';

class ConcordiaMapScreen extends StatefulWidget {
  const ConcordiaMapScreen({
    super.key,
    this.initialCategory,
    this.initialItemId,
  });

  final OpportunityCategory? initialCategory;
  final String? initialItemId;

  @override
  State<ConcordiaMapScreen> createState() => _ConcordiaMapScreenState();
}

class _ConcordiaMapScreenState extends State<ConcordiaMapScreen>
    with SingleTickerProviderStateMixin {
  static const _initialCenter = LatLng(-31.3848811, -58.0129170);
  static const _initialZoom = 13.0;
  static const _minZoom = 11.5;
  static const _maxZoom = 18.0;
  static const _zoomStep = 0.65;
  static const _labelZoom = 16.5;
  static const _markerFocusZoom = 15.2;

  static final LatLngBounds _concordiaBounds = LatLngBounds(
    const LatLng(-31.55, -58.24),
    const LatLng(-31.18, -57.80),
  );

  final MapController _mapController = MapController();
  final NetworkTileProvider _tileProvider = NetworkTileProvider();

  late final AnimationController _cameraAnimationController;
  Animation<LatLng>? _centerAnimation;
  Animation<double>? _zoomAnimation;

  OpportunityItem? _selectedItem;
  OpportunityCategory? _selectedCategory;
  LatLng _currentCenter = _initialCenter;
  double _currentZoom = _initialZoom;
  bool _showAllMarkerLabels = false;
  bool _mapReady = false;

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
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    final initialItemId = widget.initialItemId;
    if (initialItemId != null) {
      for (final item in opportunities) {
        if (item.id == initialItemId && item.hasMapLocation) {
          _selectedItem = item;
          break;
        }
      }
    }
    _cameraAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(_applyCameraAnimation);
  }

  @override
  void dispose() {
    _cameraAnimationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEE9),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedItem == null
                  ? _initialCenter
                  : LatLng(
                      _selectedItem!.latitude!,
                      _selectedItem!.longitude!,
                    ),
              initialZoom: _selectedItem == null
                  ? _initialZoom
                  : _markerFocusZoom,
              minZoom: _minZoom,
              maxZoom: _maxZoom,
              cameraConstraint: CameraConstraint.containCenter(
                bounds: _concordiaBounds,
              ),
              backgroundColor: const Color(0xFFE8EEE9),
              onMapReady: () {
                _mapReady = true;
                final camera = _mapController.camera;
                _currentCenter = camera.center;
                _currentZoom = camera.zoom;
                if (_selectedItem == null && _selectedCategory != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _fitVisibleItems();
                  });
                }
              },
              onPositionChanged: (camera, _) {
                _currentCenter = camera.center;
                _currentZoom = camera.zoom;

                final shouldShowLabels = camera.zoom >= _labelZoom;
                if (shouldShowLabels != _showAllMarkerLabels && mounted) {
                  setState(() => _showAllMarkerLabels = shouldShowLabels);
                }
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
                    'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'ar.maillet.encuentroer',
                tileProvider: _tileProvider,
                retinaMode: RetinaMode.isHighDensity(context),
                maxNativeZoom: 18,
                keepBuffer: 2,
                panBuffer: 1,
                tileDisplay: const TileDisplay.instantaneous(),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: _buildMarkers(),
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
              ),
            ],
          ),
          Positioned(
            top: safeTop + 12,
            left: 16,
            child: _MapControl(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Volver',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            top: safeTop + 12,
            right: 16,
            child: const _MapAttribution(),
          ),
          Positioned(
            top: safeTop + 58,
            right: 16,
            child: _zoomControls(),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: bottomInset + 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _categoryFilters(),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _selectedItem == null
                      ? KeyedSubtree(
                          key: ValueKey(
                            'summary-${_selectedCategory?.name ?? 'all'}',
                          ),
                          child: _mapSummary(),
                        )
                      : KeyedSubtree(
                          key: ValueKey('selected-${_selectedItem!.id}'),
                          child: _selectedCard(_selectedItem!),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    return _visibleMapItems.map((item) {
      final isSelected = item.id == _selectedItem?.id;
      final showLabel = isSelected || _showAllMarkerLabels;

      return Marker(
        key: ValueKey<String>(item.id),
        point: LatLng(item.latitude!, item.longitude!),
        width: showLabel ? 190 : 46,
        height: 50,
        child: _MapMarker(
          item: item,
          showLabel: showLabel,
          isSelected: isSelected,
          color: _categoryColor(item.category),
          icon: _categoryIcon(item.category),
        ),
      );
    }).toList(growable: false);
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

    OpportunityItem? tappedItem;
    for (final item in _mapItems) {
      if (item.id == key.value) {
        tappedItem = item;
        break;
      }
    }
    if (tappedItem == null) return;

    if (_selectedItem?.id == tappedItem.id) {
      _openDetails(tappedItem);
      return;
    }

    setState(() => _selectedItem = tappedItem);
    final targetZoom = _currentZoom < _markerFocusZoom
        ? _markerFocusZoom
        : _currentZoom;
    _animateCameraTo(
      LatLng(tappedItem.latitude!, tappedItem.longitude!),
      targetZoom,
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
          const Divider(height: 1, indent: 8, endIndent: 8),
          _MapControl(
            icon: Icons.center_focus_strong_rounded,
            tooltip: 'Centrar en Concordia',
            onPressed: _recenterMap,
          ),
        ],
      ),
    );
  }

  Widget _categoryFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 430) {
          return SizedBox(
            width: double.infinity,
            child: SegmentedButton<OpportunityCategory?>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment<OpportunityCategory?>(
                  value: null,
                  icon: Icon(Icons.layers_rounded),
                  label: Text('Todos'),
                ),
                ButtonSegment<OpportunityCategory?>(
                  value: OpportunityCategory.lodging,
                  icon: Icon(Icons.hotel_rounded),
                  label: Text('Dormir'),
                ),
                ButtonSegment<OpportunityCategory?>(
                  value: OpportunityCategory.viandas,
                  icon: Icon(Icons.restaurant_rounded),
                  label: Text('Comida'),
                ),
                ButtonSegment<OpportunityCategory?>(
                  value: OpportunityCategory.places,
                  icon: Icon(Icons.place_rounded),
                  label: Text('Paseos'),
                ),
              ],
              selected: <OpportunityCategory?>{_selectedCategory},
              style: SegmentedButton.styleFrom(
                foregroundColor: const Color(0xFF174D3C),
                backgroundColor: Colors.white,
                selectedForegroundColor: Colors.white,
                selectedBackgroundColor: const Color(0xFF174D3C),
                side: const BorderSide(color: Color(0xFFC9D8D0)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                visualDensity: VisualDensity.compact,
              ),
              onSelectionChanged: (selection) {
                if (selection.isEmpty) return;
                _selectCategory(selection.first);
              },
            ),
          );
        }

        return Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _categoryChip(
                  label: 'Todos',
                  icon: Icons.layers_rounded,
                ),
                const SizedBox(width: 8),
                _categoryChip(
                  label: 'Dormir',
                  icon: Icons.hotel_rounded,
                  category: OpportunityCategory.lodging,
                ),
                const SizedBox(width: 8),
                _categoryChip(
                  label: 'Comida',
                  icon: Icons.restaurant_rounded,
                  category: OpportunityCategory.viandas,
                ),
                const SizedBox(width: 8),
                _categoryChip(
                  label: 'Paseos',
                  icon: Icons.place_rounded,
                  category: OpportunityCategory.places,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _categoryChip({
    required String label,
    required IconData icon,
    OpportunityCategory? category,
  }) {
    final selected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? Colors.white : _categoryColor(category),
      ),
      selected: selected,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF174D3C),
        fontWeight: FontWeight.w700,
      ),
      selectedColor: const Color(0xFF174D3C),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFC9D8D0)),
      onSelected: (_) => _selectCategory(category),
    );
  }

  void _selectCategory(OpportunityCategory? category) {
    if (_selectedCategory == category && _selectedItem == null) return;

    setState(() {
      _selectedCategory = category;
      if (_selectedItem != null &&
          !_matchesSelectedCategory(_selectedItem!)) {
        _selectedItem = null;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fitVisibleItems();
    });
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
    final nextZoom = (_currentZoom + delta)
        .clamp(_minZoom, _maxZoom)
        .toDouble();
    if ((nextZoom - _currentZoom).abs() < 0.01) return;
    _animateCameraTo(_currentCenter, nextZoom);
  }

  void _recenterMap() {
    _animateCameraTo(_initialCenter, _initialZoom);
  }

  void _fitVisibleItems() {
    if (!_mapReady) return;

    final coordinates = _visibleMapItems
        .map((item) => LatLng(item.latitude!, item.longitude!))
        .toList(growable: false);
    if (coordinates.isEmpty) return;

    _cameraAnimationController.stop();
    if (coordinates.length == 1) {
      _animateCameraTo(coordinates.first, _markerFocusZoom);
      return;
    }

    final fittedCamera = CameraFit.coordinates(
      coordinates: coordinates,
      padding: const EdgeInsets.fromLTRB(54, 120, 54, 235),
      maxZoom: 15.4,
    ).fit(_mapController.camera);
    _animateCameraTo(fittedCamera.center, fittedCamera.zoom);
  }

  void _animateCameraTo(LatLng targetCenter, double targetZoom) {
    if (!_mapReady) return;

    final curve = CurvedAnimation(
      parent: _cameraAnimationController,
      curve: Curves.easeOutCubic,
    );
    _centerAnimation = LatLngTween(
      begin: _currentCenter,
      end: targetCenter,
    ).animate(curve);
    _zoomAnimation = Tween<double>(
      begin: _currentZoom,
      end: targetZoom.clamp(_minZoom, _maxZoom).toDouble(),
    ).animate(curve);

    _cameraAnimationController
      ..stop()
      ..reset()
      ..forward();
  }

  void _applyCameraAnimation() {
    if (!_mapReady) return;
    final center = _centerAnimation?.value;
    final zoom = _zoomAnimation?.value;
    if (center == null || zoom == null) return;
    _mapController.move(center, zoom);
  }

  String get _mapSummaryTitle => switch (_selectedCategory) {
    OpportunityCategory.lodging => 'Dónde dormir',
    OpportunityCategory.viandas => 'Dónde comer',
    OpportunityCategory.places => 'Paseos y atractivos',
    null => 'Lugares en el mapa',
    OpportunityCategory.gastronomy => 'Dónde comer',
  };

  String get _mapSummaryCount {
    final count = _visibleMapItems.length;
    return count == 1
        ? '1 ubicación visible en Concordia'
        : '$count ubicaciones visibles en Concordia';
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
                  Text(
                    _mapSummaryTitle,
                    style: const TextStyle(
                      color: Color(0xFF174D3C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$_mapSummaryCount · Tocá un marcador para ver acciones',
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
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                if (item.brandAsset != null)
                  BrandAssetBox(
                    assetPath: item.brandAsset!,
                    fallbackIcon: _categoryIcon(item.category),
                    size: 48,
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _categoryColor(
                        item.category,
                      ).withValues(alpha: 0.14),
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
                      const SizedBox(height: 3),
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
                  tooltip: 'Cerrar selección',
                  onPressed: () => setState(() => _selectedItem = null),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openLocation(item),
                    icon: const Icon(Icons.directions_rounded),
                    label: const Text('Cómo llegar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _openDetails(item),
                    icon: const Icon(Icons.info_outline_rounded),
                    label: const Text('Ver detalles'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(OpportunityItem item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _ItemDetailPage(item: item)));
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

class _MapAttribution extends StatelessWidget {
  const _MapAttribution();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x99C9D8D0)),
        ),
        child: const Text(
          '© OpenStreetMap contributors · © CARTO',
          style: TextStyle(
            color: Color(0xFF4E6259),
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
                  if (item.brandAsset != null) ...[
                    BrandAssetBox(
                      assetPath: item.brandAsset!,
                      fallbackIcon: Icons.account_balance_rounded,
                      size: 72,
                    ),
                    const SizedBox(height: 12),
                  ],
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
      const SnackBar(
        content: Text(
          'No pudimos abrir el enlace. Verificá que tengas una aplicación compatible.',
        ),
      ),
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
