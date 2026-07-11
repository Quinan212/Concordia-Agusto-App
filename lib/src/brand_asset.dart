import 'package:flutter/material.dart';

/// Contenedor consistente para identidades visuales institucionales.
///
/// Si el recurso no está disponible o no fue declarado en `pubspec.yaml`,
/// conserva la interfaz mediante el icono de respaldo.
class BrandAssetBox extends StatelessWidget {
  const BrandAssetBox({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.size = 48,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF174D3C),
    this.padding = const EdgeInsets.all(6),
    this.borderRadius = 12,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(fallbackIcon, color: iconColor, size: size * 0.48);

    return Semantics(
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: const Color(0xFFC9D8D0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          assetPath,
          fit: fit,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Center(child: fallback),
        ),
      ),
    );
  }
}
