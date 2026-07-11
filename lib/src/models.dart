enum OpportunityCategory { lodging, viandas, gastronomy, places }

enum OpportunityTag {
  group,
  budget,
  direct,
  classic,
  thermal,
  practical,
  paseo,
  highlighted,
  culture,
  outdoors,
}

/// Normaliza texto para búsquedas en español sin alterar el texto mostrado.
String normalizeSearchText(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');
}

class ContactAction {
  const ContactAction({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final String icon;
}

class OpportunityItem {
  const OpportunityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.tags,
    required this.highlights,
    required this.actions,
    this.note,
    this.latitude,
    this.longitude,
    this.mapAddress,
    this.brandAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final OpportunityCategory category;
  final List<OpportunityTag> tags;
  final List<String> highlights;
  final List<ContactAction> actions;
  final String? note;
  final double? latitude;
  final double? longitude;
  final String? mapAddress;
  final String? brandAsset;

  bool get hasMapLocation => latitude != null && longitude != null;

  /// Índice de texto utilizado por el buscador de la aplicación.
  String get searchableText => normalizeSearchText(
    [
      title,
      subtitle,
      description,
      note ?? '',
      ...highlights,
      ...actions.map((action) => action.label),
    ].join(' '),
  );
}

class HomeHighlight {
  const HomeHighlight({
    required this.title,
    required this.value,
    required this.caption,
  });

  final String title;
  final String value;
  final String caption;
}
