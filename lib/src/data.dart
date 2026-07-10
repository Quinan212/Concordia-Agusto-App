import 'models.dart';

final homeHighlights = List<HomeHighlight>.unmodifiable([
  HomeHighlight(
    title: 'Dónde dormir',
    value: _countOpportunities(OpportunityCategory.lodging),
    caption: 'Opciones para distintos presupuestos y formas de viaje',
  ),
  HomeHighlight(
    title: 'Comida práctica',
    value: _countOpportunities(OpportunityCategory.viandas),
    caption: 'Opciones para comer entre las actividades del Encuentro',
  ),
  HomeHighlight(
    title: 'Gastronomía',
    value: _countOpportunities(OpportunityCategory.gastronomy),
    caption: 'Restaurantes, bares y pizzerías para disfrutar la ciudad',
  ),
  HomeHighlight(
    title: 'Paseos',
    value: _countOpportunities(OpportunityCategory.places),
    caption: 'Lugares para conocer durante tus ratos libres',
  ),
]);

String _countOpportunities(OpportunityCategory category) {
  return opportunities
      .where((item) => item.category == category)
      .length
      .toString();
}

const topRecommendations = <String>[
  'Si buscás una ubicación céntrica, empezá por Centro Plaza Hotel.',
  'Compará Casa Di Aqua con casas de alquiler si viajás con otras personas.',
  'Para una comida rápida entre actividades, revisá las viandas del centro.',
  'Costanera y Parque San Carlos son buenas opciones para aprovechar una tarde libre.',
  'Las sedes del Encuentro están en Yrigoyen 1352 y Av. Tavella 1424.',
];

const cannedMessage =
    'Hola, voy a asistir al III Encuentro sobre Historia de Entre Ríos en Concordia '
    'durante agosto de 2026. Quisiera consultar disponibilidad, tarifa por noche y '
    'servicios incluidos. ¿Podrían enviarme esa información? Gracias.';

const opportunities = <OpportunityItem>[
  OpportunityItem(
    id: 'centro-plaza',
    title: 'Centro Plaza Hotel',
    subtitle: 'Hotel céntrico con habitaciones y desayuno',
    description:
        'Sobre La Rioja 543, esquina Buenos Aires. Una alternativa cómoda si querés alojarte en el centro y tener los principales servicios cerca.',
    category: OpportunityCategory.lodging,
    latitude: -31.3992923,
    longitude: -58.0148745,
    mapAddress: 'La Rioja 543',
    tags: [
      OpportunityTag.group,
      OpportunityTag.direct,
      OpportunityTag.highlighted,
    ],
    highlights: [
      '27 habitaciones y 62 plazas',
      'Desayuno incluido, bar y room service',
      'Cochera cerrada sujeta a disponibilidad',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454339886',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:info@centroplazahotel.com.ar',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Web',
        url: 'https://centroplazahotel.com.ar/',
        icon: 'web',
      ),
    ],
    note: 'Planta baja y primer piso; acceso al primer piso por escalera.',
  ),
  OpportunityItem(
    id: 'casa-di-aqua',
    title: 'Casa Di Aqua Apart Hotel',
    subtitle: 'Departamentos para compartir entre 3 y 6 personas',
    description:
        'Puede resultarte cómodo si viajás con colegas y prefieren compartir un departamento.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.group, OpportunityTag.direct, OpportunityTag.budget],
    highlights: [
      'Unidades para 3, 4, 5 y 6 personas',
      'Permite alojarse en grupos pequeños',
      'Tarifas disponibles en su sitio web',
    ],
    actions: [
      ContactAction(
        label: 'Mail',
        url: 'mailto:info@casadiaqua.com.ar',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Web',
        url: 'https://casadiaqua.com.ar/',
        icon: 'web',
      ),
      ContactAction(
        label: 'Tarifas',
        url: 'https://casadiaqua.com.ar/tarifas/',
        icon: 'price',
      ),
    ],
  ),
  OpportunityItem(
    id: 'el-bicho-negro',
    title: 'El Bicho Negro Hostel',
    subtitle: 'Hostel económico con alojamiento compartido',
    description:
        'Ideal si priorizás el precio y te resulta cómodo alojarte en un hostel.',
    category: OpportunityCategory.lodging,
    latitude: -31.4022527,
    longitude: -58.0182346,
    mapAddress: '9 de Julio 80',
    tags: [OpportunityTag.budget, OpportunityTag.direct, OpportunityTag.group],
    highlights: [
      'Contacto directo por WhatsApp',
      'Opción orientada a presupuestos ajustados',
      'Ambiente y servicios propios de un hostel',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5491165983888',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Guía',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/hostels/el-bicho-negro-hostel',
        icon: 'web',
      ),
      ContactAction(
        label: 'Sitio',
        url: 'https://www.elbichonegrohostel.com/',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'alojamiento-avenida',
    title: 'Alojamiento Avenida',
    subtitle: 'Casa de alquiler turístico con contacto directo',
    description:
        'Puede servirte si preferís una casa de alquiler y buscás una alternativa sencilla a la hotelería.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'Incluida en la guía turística oficial',
      'Opción para considerar con presupuesto ajustado',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454745409',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:maraaldecoa87@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Guía',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/casas-de-alquiler-tur%C3%ADstico/alojamiento-avenida',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'hospedaje-vz',
    title: 'Hospedaje V.Z.',
    subtitle: 'Hospedaje sencillo con contacto directo',
    description:
        'Una alternativa para quienes buscan un alojamiento simple y posiblemente más económico.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'También recibe consultas por correo',
      'Incluido en la guía turística oficial',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454129852',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:hospedajeyquinchovz@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Guía',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/casas-de-alquiler-tur%C3%ADstico/hospedaje-vz-hospedaje-y-quincho',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'termal-del-lago',
    title: 'Termal del Lago',
    subtitle: 'Alojamiento con entorno y servicios termales',
    description:
        'Buena opción si valorás la comodidad y querés sumar una experiencia termal a la estadía.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.thermal, OpportunityTag.direct],
    highlights: [
      'Contacto por WhatsApp y correo',
      'Servicios pensados para una estadía confortable',
      'Interesante para combinar alojamiento y descanso',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454198179',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:consultas@termaldellago.net',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Web',
        url: 'https://termaldellago.net/',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'casa-nebel',
    title: 'Casa Nebel',
    subtitle: 'Casa turística para compartir con otras personas',
    description:
        'Puede resultarte conveniente si viajás con colegas y prefieren alojarse juntos en una casa.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct, OpportunityTag.group],
    highlights: [
      'Consultas por WhatsApp',
      'Incluida en la guía turística local',
      'Permite compartir el alojamiento y dividir gastos',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454927363',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Guía',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/casas-de-alquiler-tur%C3%ADstico/casa-nebel',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'hathor',
    title: 'Hathor Concordia',
    subtitle: 'Hotel con servicios completos y atención directa',
    description:
        'Una alternativa de perfil hotelero formal, útil si buscás mayor comodidad y servicios completos.',
    category: OpportunityCategory.lodging,
    tags: [
      OpportunityTag.group,
      OpportunityTag.direct,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Contacto por WhatsApp y correo',
      'Hotel preparado también para viajes corporativos',
      'Buena alternativa cuando preferís una estadía con más servicios',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454325710',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:reservasconcordia@hathorhotels.com.ar',
        icon: 'mail',
      ),
      ContactAction(label: 'Fijo', url: 'tel:03454222362', icon: 'web'),
      ContactAction(
        label: 'Web',
        url: 'https://www.hathorconcordia.com.ar/contacto/',
        icon: 'web',
      ),
    ],
    note:
        'Ubicado sobre Ruta Nacional 14, km 264,5 (fuera del centro). Cuenta con piscinas de temporada; la climatizada abre en julio y fines de semana largos de invierno.',
  ),
  // --- Nuevos hoteles desde lista oficial ---
  OpportunityItem(
    id: 'residencial',
    title: 'Residencial Hotel Concordia',
    subtitle: 'Hotel céntrico con estacionamiento y desayuno',
    description:
        'Sobre La Rioja 518. Un hotel sencillo y bien ubicado para moverte por el centro durante los días del Encuentro.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Estacionamiento, Wi-Fi y desayuno incluido',
      'Ubicación céntrica',
      'Trato directo y sencillo',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454282644',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'federico-i',
    title: 'Hotel Federico I',
    subtitle: 'Habitaciones para todos los tamaños de grupo',
    description:
        'Sobre 1º de Mayo 248, a tres cuadras de Plaza 25 de Mayo. Ideal si viajás solo, en pareja o con un grupo de colegas.',
    category: OpportunityCategory.lodging,
    latitude: -31.3983556,
    longitude: -58.0138868,
    mapAddress: '1° de Mayo 248',
    tags: [OpportunityTag.group, OpportunityTag.direct],
    highlights: [
      'Habitaciones single, dobles, triples, cuádruples y quíntuples',
      'Baño privado con secador, TV LED/Smart',
      'Tarifas directas publicadas en su sitio',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454012280',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Fijo', url: 'tel:03454230847', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'florida',
    title: 'Hotel Florida',
    subtitle: 'Hotel céntrico con estacionamiento',
    description:
        'Sobre Hipólito Yrigoyen 717. Bien ubicado, con habitaciones individuales, dobles, triples y cuádruples.',
    category: OpportunityCategory.lodging,
    latitude: -31.3961294,
    longitude: -58.0152538,
    mapAddress: 'Hipólito Yrigoyen 717',
    tags: [OpportunityTag.group, OpportunityTag.direct],
    highlights: [
      'Estacionamiento, Wi-Fi y desayuno incluido',
      'Baño privado y TV en habitaciones',
      'Buena opción para grupos chicos',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493456026078',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Fijo', url: 'tel:03454216536', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'd-charruas',
    title: "D'Charrúas Hostel",
    subtitle: 'Hostel céntrico con cocina compartida',
    description:
        'Sobre Aristóbulo del Valle 31. Ideal si viajás con presupuesto ajustado y querés un ambiente más social.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Habitaciones privadas y compartidas',
      'Cocina compartida equipada, patio y parrilla',
      'Wi-Fi y sala común',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454941601',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'apart-avenida',
    title: 'Apart Avenida',
    subtitle: 'Apart hotel con modalidad independiente',
    description:
        'Sobre Av. Gerardo Yoya 83 (ex J. B. Justo). Unidad con cocina para quienes prefieren resolver sus propias comidas.',
    category: OpportunityCategory.lodging,
    latitude: -31.3847940,
    longitude: -58.0113675,
    mapAddress: 'Av. Gerardo Yoya 83',
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Unidades con cocina, aire acondicionado y calefacción',
      'Wi-Fi y estacionamiento',
      'Modalidad independiente, ideal para estadías medias',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454335450',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'centro-apart',
    title: 'Concordia Centro Apart',
    subtitle: 'Apart céntrico con Wi-Fi',
    description:
        'Sobre Carlos Pellegrini 483. Un apart bien ubicado para quienes buscan independencia en pleno centro.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Wi-Fi y estacionamiento',
      'Ubicación céntrica',
      'Modalidad apart con flexibilidad',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454952351',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'tus-viandas',
    title: 'Tus Viandas Concordia',
    subtitle: 'Viandas semanales para llevar',
    description:
        'Sobre Hipólito Yrigoyen 1557. Viandas semanales, tacos, hamburguesas, empanadas y otros platos. Delivery y retiro disponibles.',
    category: OpportunityCategory.viandas,
    tags: [
      OpportunityTag.practical,
      OpportunityTag.direct,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Viandas semanales con variedad de platos',
      'Delivery y retiro publicados',
      'Práctico para almorzar o cenar sin perder tiempo',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493455287506',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:tusviandasconcordia@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Ficha',
        url: 'https://www.concordia.gob.ar/node/11393',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'yantar-centro',
    title: 'Yantar Rotisería',
    subtitle: 'Rotisería para una comida completa y práctica',
    description:
        'Buena opción para comprar comida preparada entre actividades o al terminar la jornada.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Pedidos y consultas por WhatsApp',
      'También dispone de correo',
      'Útil para resolver una comida sin sentarte en un restaurante',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454210414',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:yantarrotiseria@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Ficha',
        url: 'https://www.concordia.gob.ar/node/267',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'yantar-costa',
    title: 'Yantar de la Costa',
    subtitle: 'Comida preparada cerca de la Costanera',
    description:
        'Puede servirte para combinar una comida práctica con un paseo por la Costanera.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.paseo],
    highlights: [
      'Buena opción para comer durante una salida',
      'Pedidos y consultas por WhatsApp',
      'Ubicación conveniente para recorrer la zona',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454112829',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Mail',
        url: 'mailto:yantarrotiseria@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Ficha',
        url: 'https://www.concordia.gob.ar/node/271',
        icon: 'web',
      ),
    ],
  ),
  // --- Nuevas viandas desde lista oficial ---
  OpportunityItem(
    id: 'almacen-viandas',
    title: 'El Almacén de Viandas',
    subtitle: 'Viandas saludables, light y veggie',
    description:
        'Sobre Ramírez 324. Viandas saludables, light, ensaladas, keto y veggie. Pedidos por WhatsApp.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas saludables, light, keto y veggie',
      'Pedidos por WhatsApp',
      'Opción vegetariana disponible',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454100222',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'cool-kitchen',
    title: 'Cool Kitchen Catering',
    subtitle: 'Catering y viandas para empresas',
    description:
        'Catering social y corporativo con servicio de viandas publicado. Buena opción para pedidos grupales durante el Encuentro.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.group, OpportunityTag.practical],
    highlights: [
      'Catering social y corporativo',
      'Servicio de viandas para grupos',
      'Adecuado para pedidos institucionales',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493456251800',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'lo-de-pauli',
    title: 'Lo de Pauli · Gluten Free',
    subtitle: 'Viandas caseras sin gluten',
    description:
        'Viandas caseras y nutritivas, de lunes a viernes al mediodía, por pedido. Precio publicado: \$7.500.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas caseras y nutritivas sin gluten',
      'De lunes a viernes al mediodía',
      'Apta para celíacos',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454936391',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'espacio-saludable',
    title: 'Espacio Saludable Concordia',
    subtitle: 'Viandas personalizadas por nutricionistas',
    description:
        'Sobre Carriego 33. Viandas personalizadas elaboradas por nutricionistas y chefs. Opciones saludables.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas personalizadas por nutricionistas',
      'Opciones saludables',
      'Contacto por perfil comercial',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454282644',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'bar-idea',
    title: 'Bar Ideal',
    subtitle: 'Un clásico gastronómico de Concordia',
    description:
        'Sobre 1º de Mayo 51, esquina Urquiza, frente a Plaza 25 de Mayo. Bar y restaurante tradicional con pizzas, empanadas y comidas. Delivery publicado.',
    category: OpportunityCategory.gastronomy,
    latitude: -31.3978458,
    longitude: -58.0177876,
    mapAddress: '1° de Mayo 51',
    tags: [OpportunityTag.classic, OpportunityTag.highlighted],
    highlights: [
      'Pizzas, empanadas y platos tradicionales',
      'Delivery y precios especiales para grupos',
      'Ubicación frente a Plaza 25 de Mayo',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454091184',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Fijo', url: 'tel:03454212668', icon: 'web'),
      ContactAction(
        label: 'Ficha',
        url: 'https://ahgconcordia.com.ar/asociado/bar-ideal/',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'reloj-centro',
    title: 'Pizzería El Reloj del Centro',
    subtitle: 'Pizza y platos de pizzería en el centro',
    description:
        'Sobre Carlos Pellegrini 580. Pizzas, empanadas, sándwiches y platos de pizzería. Atención de lunes a domingo, 19:00 a 00:30.',
    category: OpportunityCategory.gastronomy,
    tags: [OpportunityTag.classic, OpportunityTag.direct],
    highlights: [
      'Pizzas, empanadas y sándwiches',
      'Abierto lunes a domingo de 19 a 00:30',
      'Pedidos por WhatsApp',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454154991',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Fijo', url: 'tel:03454222822', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'parrilla-el-gordo',
    title: 'Parrilla El Gordo',
    subtitle: 'Parrilla accesible para una comida abundante',
    description:
        'Sobre 1º de Mayo 194. Parrilla, pastas y minutas. Buena opción si buscás una comida abundante en un ambiente sencillo.',
    category: OpportunityCategory.gastronomy,
    latitude: -31.3982169,
    longitude: -58.0149046,
    mapAddress: '1° de Mayo 194',
    tags: [OpportunityTag.classic, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'Propuesta sencilla para almorzar o cenar',
      'Compatible con un presupuesto moderado',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454226311',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Guía',
        url: 'https://www.concordia.gob.ar/node/4394',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'richmond',
    title: 'Richmond Street Food Bar',
    subtitle: 'Opción urbana en Mercado Plaza',
    description:
        'Ideal para una salida informal, con una propuesta moderna dentro del circuito gastronómico.',
    category: OpportunityCategory.gastronomy,
    tags: [OpportunityTag.direct, OpportunityTag.paseo],
    highlights: [
      'Consultas por WhatsApp',
      'Ambiente casual',
      'Buena ubicación para una salida breve',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454146822',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Ficha',
        url: 'https://ahgconcordia.com.ar/asociado/richmond-street-food-bar/',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'sede-profesorado',
    title: 'Profesorado de Ciencias Sociales',
    subtitle: 'Sede de apertura · H. Yrigoyen 1352',
    description:
        'Apertura del III Encuentro sobre Historia de Entre Ríos. Miércoles 13/08 a las 18:30 con cine-debate. Hipólito Yrigoyen 1352.',
    category: OpportunityCategory.places,
    latitude: -31.3848811,
    longitude: -58.0129170,
    mapAddress: 'Hipólito Yrigoyen 1352',
    tags: [OpportunityTag.paseo, OpportunityTag.highlighted],
    highlights: [
      'Sede oficial del Encuentro',
      'Cine-debate de apertura el 13/08',
      'Edificio del Profesorado de Ciencias Sociales',
    ],
    actions: [
      ContactAction(
        label: 'Abrir mapa',
        url:
            'https://www.google.com/maps/search/?api=1&query=Hip%C3%B3lito+Yrigoyen+1352+Concordia',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'sede-fcad',
    title: 'FCAD · UNER',
    subtitle: 'Sede de mesas · Av. Tavella 1424',
    description:
        'Mesas y exposiciones del III Encuentro. Viernes 14/08 desde las 8:00 en la Facultad de Ciencias de la Administración, UNER.',
    category: OpportunityCategory.places,
    latitude: -31.3817858,
    longitude: -58.0229796,
    mapAddress: 'Av. Monseñor Tavella 1424',
    tags: [OpportunityTag.paseo, OpportunityTag.highlighted],
    highlights: [
      'Sede principal de mesas y exposiciones',
      'Actividades desde las 8:00 el 14/08',
      'Facultad de Ciencias de la Administración',
    ],
    actions: [
      ContactAction(
        label: 'Abrir mapa',
        url:
            'https://www.google.com/maps/search/?api=1&query=Av.+Monse%C3%B1or+Tavella+1424+Concordia',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'parque-san-carlos',
    title: 'Parque San Carlos',
    subtitle: 'Naturaleza e historia en un paseo emblemático',
    description:
        'Uno de los lugares más reconocidos de Concordia, con espacios verdes y referencias históricas.',
    category: OpportunityCategory.places,
    latitude: -31.3661114,
    longitude: -57.9985275,
    mapAddress: 'Parque San Carlos',
    tags: [OpportunityTag.paseo, OpportunityTag.highlighted],
    highlights: [
      'Lugar representativo de la ciudad',
      'Ideal para una tarde libre',
      'Se puede combinar con la Costanera o una salida gastronómica',
    ],
    actions: [
      ContactAction(
        label: 'Ver sitio',
        url:
            'https://www.concordia.gob.ar/turismo/atractivos/parque-san-carlos',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'costanera',
    title: 'Costanera',
    subtitle: 'Paseo al aire libre junto al río',
    description:
        'Una opción fácil para caminar, descansar y aprovechar un rato libre durante el Encuentro.',
    category: OpportunityCategory.places,
    latitude: -31.4025007,
    longitude: -58.0051035,
    mapAddress: 'Costanera de Concordia',
    tags: [OpportunityTag.paseo],
    highlights: [
      'Acceso sencillo',
      'Se puede combinar con comida o merienda',
      'Ideal para una visita corta',
    ],
    actions: [
      ContactAction(
        label: 'Ver sitio',
        url: 'https://www.concordia.gob.ar/turismo/atractivos/costanera',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'termas',
    title: 'Termas',
    subtitle: 'Una salida ideal para el invierno',
    description:
        'Uno de los principales atractivos de Concordia, especialmente agradable durante agosto.',
    category: OpportunityCategory.places,
    latitude: -31.2958618,
    longitude: -58.0030047,
    mapAddress: 'Termas de Concordia',
    tags: [OpportunityTag.paseo, OpportunityTag.thermal],
    highlights: [
      'Buena opción para los días fríos',
      'Requiere más tiempo que un paseo urbano',
      'Experiencia turística característica de la ciudad',
    ],
    actions: [
      ContactAction(
        label: 'Ver sitio',
        url: 'https://www.concordia.gob.ar/turismo/atractivos/termas',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'concorpass',
    title: 'ConcorPass',
    subtitle: 'Beneficios y propuestas turísticas desde el celular',
    description:
        'Te permite consultar beneficios y descubrir opciones turísticas oficiales para tu estadía.',
    category: OpportunityCategory.places,
    tags: [OpportunityTag.paseo, OpportunityTag.practical],
    highlights: [
      'Herramienta oficial de turismo',
      'Útil para encontrar propuestas durante tu visita',
      'Pensada para consultar desde el celular',
    ],
    actions: [
      ContactAction(
        label: 'Ver sitio',
        url: 'https://www.concordia.gob.ar/turismo/concorpass',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'portal-turismo',
    title: 'Portal de Turismo',
    subtitle: 'Información oficial sobre paseos y servicios',
    description:
        'Una referencia rápida para buscar alojamientos, gastronomía, actividades y otros servicios turísticos.',
    category: OpportunityCategory.places,
    tags: [OpportunityTag.paseo, OpportunityTag.practical],
    highlights: [
      'Información turística oficial',
      'Reúne recorridos y servicios',
      'Útil para seguir explorando opciones',
    ],
    actions: [
      ContactAction(
        label: 'Ver sitio',
        url: 'https://www.concordia.gob.ar/turismo',
        icon: 'web',
      ),
    ],
  ),
];
