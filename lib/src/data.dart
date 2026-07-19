import 'models.dart';

final homeHighlights = List<HomeHighlight>.unmodifiable([
  HomeHighlight(
    title: 'Dónde dormir',
    value: _countOpportunities(OpportunityCategory.lodging),
    caption: 'Opciones para distintos presupuestos.',
  ),
  HomeHighlight(
    title: 'Comida práctica',
    value: _countOpportunities(OpportunityCategory.viandas),
    caption: 'Comidas para el encuentro.',
  ),
  HomeHighlight(
    title: 'Gastronomía',
    value: _countOpportunities(OpportunityCategory.gastronomy),
    caption: 'Restaurantes, bares y pizzerías.',
  ),
  HomeHighlight(
    title: 'Paseos',
    value: _countOpportunities(OpportunityCategory.places),
    caption: 'Sitios de interés para tu tiempo libre.',
  ),
]);

String _countOpportunities(OpportunityCategory category) {
  return opportunities
      .where((item) => item.category == category)
      .length
      .toString();
}

const topRecommendations = <String>[
  'Consultá disponibilidad, precio final y condiciones de reserva antes de elegir.',
  'Para una ubicación céntrica, revisá Centro Plaza Hotel, Hotel Federico I y Hotel Florida.',
  'Si viajás en grupo, compará departamentos, casas turísticas y habitaciones múltiples.',
  'Para comer entre actividades, priorizá viandas y rotiserías con pedido anticipado.',
  'La apertura y las mesas se realizan en sedes distintas; revisá el bloque del Encuentro en Inicio.',
  'Antes de visitar museos, termas o Salto Grande, confirmá horarios, acceso y condiciones vigentes.',
];

const cannedMessage =
    'Hola. Voy a asistir al III Encuentro sobre Historia de Entre Ríos en Concordia, '
    'los días 13 y 14 de agosto de 2026. Quisiera consultar disponibilidad, precio '
    'final por noche, servicios incluidos, horarios de ingreso y salida, y condiciones '
    'de reserva. ¿Podrían enviarme esa información? Gracias.';

const encounterActions = <ContactAction>[
  ContactAction(
    label: 'Consultar',
    url: 'mailto:historiadeentrerios.ines@gmail.com',
    icon: 'mail',
  ),
  ContactAction(
    label: 'Sitio oficial',
    url:
        'https://ines.conicet.gov.ar/iii-encuentro-sobre-historia-de-entre-rios/',
    icon: 'web',
  ),
];

const tourismActions = <ContactAction>[
  ContactAction(
    label: 'Guía turística oficial',
    url: 'https://www.concordia.gob.ar/turismo',
    icon: 'web',
  ),
];

const opportunities = <OpportunityItem>[
  OpportunityItem(
    id: 'centro-plaza',
    title: 'Centro Plaza Hotel',
    subtitle: 'Hotel céntrico con desayuno y cochera',
    description:
        'Ubicado en La Rioja 543, esquina Buenos Aires. Su localización permite moverse a pie por el centro y acceder con facilidad a comercios y servicios.',
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
      '27 habitaciones con capacidad total para 62 personas',
      'Desayuno incluido, bar y servicio a la habitación',
      'Cochera cerrada, sujeta a disponibilidad',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454339886',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:info@centroplazahotel.com.ar',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Sitio web',
        url: 'https://centroplazahotel.com.ar/',
        icon: 'web',
      ),
    ],
    note:
        'El establecimiento tiene planta baja y primer piso. El acceso al primer piso es únicamente por escalera.',
  ),
  OpportunityItem(
    id: 'casa-di-aqua',
    title: 'Casa di Aqua Apart Hotel',
    subtitle: 'Departamentos para grupos de 3 a 6 personas',
    description:
        'Apart hotel ubicado en Av. Eva Perón 2452. Es una alternativa para quienes viajan en grupo y prefieren compartir un departamento con mayor independencia.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.group, OpportunityTag.direct, OpportunityTag.budget],
    highlights: [
      'Departamentos para 3, 4, 5 o 6 personas',
      'Permite compartir el alojamiento y dividir gastos',
      'Las tarifas se consultan en el sitio web',
    ],
    actions: [
      ContactAction(label: 'Llamar', url: 'tel:03454273422', icon: 'web'),
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454015361',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:info@casadiaqua.com.ar',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Sitio web',
        url: 'https://casadiaqua.com.ar/',
        icon: 'web',
      ),
      ContactAction(
        label: 'Ver tarifas',
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
        'Alternativa orientada a quienes priorizan un presupuesto ajustado y aceptan la dinámica de un hostel.',
    category: OpportunityCategory.lodging,
    latitude: -31.4022527,
    longitude: -58.0182346,
    mapAddress: '9 de Julio 80',
    tags: [OpportunityTag.budget, OpportunityTag.direct, OpportunityTag.group],
    highlights: [
      'Contacto directo por WhatsApp',
      'Alternativa para presupuestos ajustados',
      'Consultá servicios, disponibilidad y normas de convivencia',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5491165983888',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Guía oficial',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/hostels/el-bicho-negro-hostel',
        icon: 'web',
      ),
      ContactAction(
        label: 'Sitio web',
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
        'Casa de alquiler turístico ubicada en San Lorenzo Oeste 789, para quienes prefieren una estadía independiente y una alternativa sencilla a la hotelería.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'Incluido en la guía turística oficial',
      'Alternativa para un presupuesto ajustado',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454745409',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:maraaldecoa87@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Guía oficial',
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
        'Hospedaje ubicado en Av. Monseñor Ricardo Rösch 4982, orientado a quienes buscan una alternativa sencilla y de menor costo.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'También permite consultas por correo',
      'Incluido en la guía turística oficial',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454129852',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:hospedajeyquinchovz@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Guía oficial',
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
        'Alojamiento pensado para combinar la estadía con servicios y actividades termales.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.thermal, OpportunityTag.direct],
    highlights: [
      'Contacto por WhatsApp y correo',
      'Servicios orientados al descanso',
      'Permite combinar alojamiento y experiencia termal',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454198179',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:consultas@termaldellago.net',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Sitio web',
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
        'Alquiler temporario con atención en Bv. San Lorenzo Este 973, pensado para grupos que prefieren alojarse juntos y compartir gastos.',
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
        label: 'Correo',
        url: 'mailto:casanebel@hotmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Sitio web',
        url: 'https://casanebel.com.ar/',
        icon: 'web',
      ),
      ContactAction(
        label: 'Guía oficial',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/casas-de-alquiler-tur%C3%ADstico/casa-nebel',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'hathor',
    title: 'Hathor Concordia',
    subtitle: 'Hotel sobre la Ruta 14 con servicios completos',
    description:
        'Ubicado fuera del centro, sobre la Ruta Nacional 14. Puede ser conveniente para quienes viajan en vehículo y priorizan servicios hoteleros.',
    category: OpportunityCategory.lodging,
    tags: [
      OpportunityTag.group,
      OpportunityTag.direct,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Contacto por WhatsApp y correo',
      'Servicios para turismo y viajes corporativos',
      'Conviene considerar el traslado hacia las sedes',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454325710',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:reservasconcordia@hathorhotels.com.ar',
        icon: 'mail',
      ),
      ContactAction(label: 'Llamar', url: 'tel:03454222362', icon: 'web'),
      ContactAction(
        label: 'Sitio web',
        url: 'https://www.hathorconcordia.com.ar/contacto/',
        icon: 'web',
      ),
    ],
    note:
        'Ubicado sobre Ruta Nacional 14, km 264,5, fuera del centro. Consultá la disponibilidad de piscinas y otros servicios de temporada antes de reservar.',
  ),
  // --- Nuevos hoteles desde lista oficial ---
  OpportunityItem(
    id: 'residencial',
    title: 'Residencial Hotel Concordia',
    subtitle: 'Hotel céntrico con estacionamiento y desayuno',
    description:
        'Ubicado en La Rioja 518. Es una alternativa sencilla para moverse por el centro durante las jornadas del Encuentro.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.budget, OpportunityTag.direct],
    highlights: [
      'Estacionamiento, Wi-Fi y desayuno incluido',
      'Ubicación céntrica',
      'Contacto directo para reservas y consultas',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454282644',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:hotelconcordiaentrerios@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Guía oficial',
        url:
            'https://www.concordia.gob.ar/turismo/donde-dormir/hoteles-y-residenciales/residencial-hotel-concordia',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'federico-i',
    title: 'Hotel Federico I',
    subtitle: 'Habitaciones individuales y para grupos',
    description:
        'Ubicado en 1.º de Mayo 248, a tres cuadras de la Plaza 25 de Mayo. Ofrece alternativas para personas solas, parejas y grupos.',
    category: OpportunityCategory.lodging,
    latitude: -31.3983556,
    longitude: -58.0138868,
    mapAddress: '1° de Mayo 248',
    tags: [OpportunityTag.group, OpportunityTag.direct],
    highlights: [
      'Habitaciones individuales, dobles, triples, cuádruples y quíntuples',
      'Baño privado, secador de pelo y TV LED o Smart TV',
      'Consultá tarifas y disponibilidad de forma directa',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454012280',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Llamar', url: 'tel:03454230847', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'florida',
    title: 'Hotel Florida',
    subtitle: 'Hotel céntrico con estacionamiento',
    description:
        'Ubicado en Hipólito Yrigoyen 717. Cuenta con habitaciones individuales, dobles, triples y cuádruples.',
    category: OpportunityCategory.lodging,
    latitude: -31.3961294,
    longitude: -58.0152538,
    mapAddress: 'Hipólito Yrigoyen 717',
    tags: [OpportunityTag.group, OpportunityTag.direct],
    highlights: [
      'Estacionamiento, Wi-Fi y desayuno incluido',
      'Baño privado y TV en habitaciones',
      'Alternativa para personas solas, parejas y grupos pequeños',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493456026078',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Llamar', url: 'tel:03454216536', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'd-charruas',
    title: "D'Charrúas Hostel",
    subtitle: 'Hostel céntrico con cocina compartida',
    description:
        'Ubicado en Aristóbulo del Valle 31. Está orientado a quienes viajan con presupuesto ajustado y valoran un ambiente social.',
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
        'Ubicado en Av. Gerardo Yoya 83 (antes J. B. Justo). Sus unidades con cocina permiten organizar las comidas con mayor independencia.',
    category: OpportunityCategory.lodging,
    latitude: -31.3847940,
    longitude: -58.0113675,
    mapAddress: 'Av. Gerardo Yoya 83',
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Unidades con cocina, aire acondicionado y calefacción',
      'Wi-Fi y estacionamiento',
      'Modalidad independiente para estadías de varios días',
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
    subtitle: 'Departamentos tipo apart en el centro',
    description:
        'Ubicado en Carlos Pellegrini 483. Ofrece una modalidad independiente en pleno centro.',
    category: OpportunityCategory.lodging,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Wi-Fi y estacionamiento',
      'Ubicación céntrica',
      'Modalidad independiente y flexible',
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
        'Ubicado en Hipólito Yrigoyen 1557. Ofrece viandas semanales, tacos, hamburguesas, empanadas y otros platos, con entrega y retiro.',
    category: OpportunityCategory.viandas,
    tags: [
      OpportunityTag.practical,
      OpportunityTag.direct,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Viandas semanales con variedad de platos',
      'Entrega y retiro disponibles',
      'Práctico para almorzar o cenar sin perder tiempo',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493455287506',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:tusviandasconcordia@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Más información',
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
        'Rotisería para comprar comida preparada entre actividades o al finalizar la jornada.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Pedidos y consultas por WhatsApp',
      'También recibe consultas por correo',
      'Permite resolver una comida sin dedicar tiempo a una atención en salón',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454210414',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Correo',
        url: 'mailto:yantarrotiseria@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Más información',
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
        'Alternativa para combinar una comida práctica con un paseo por la Costanera.',
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
        label: 'Correo',
        url: 'mailto:yantarrotiseria@gmail.com',
        icon: 'mail',
      ),
      ContactAction(
        label: 'Más información',
        url: 'https://www.concordia.gob.ar/node/271',
        icon: 'web',
      ),
    ],
  ),
  // --- Nuevas viandas desde lista oficial ---
  OpportunityItem(
    id: 'almacen-viandas',
    title: 'El Almacén de Viandas',
    subtitle: 'Viandas saludables y opciones vegetarianas',
    description:
        'Ubicado en Ramírez 324. Ofrece viandas, ensaladas y opciones livianas, cetogénicas y vegetarianas. Los pedidos se realizan por WhatsApp.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas, ensaladas y opciones vegetarianas',
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
        'Servicio de catering social y corporativo con viandas para pedidos grupales durante el Encuentro.',
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
        'Viandas caseras sin gluten, disponibles de lunes a viernes al mediodía y únicamente por pedido. Consultá el precio actualizado y las condiciones de elaboración.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas caseras sin gluten',
      'Pedidos de lunes a viernes al mediodía',
      'Consultá por ingredientes, manipulación y posibles trazas',
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
    subtitle: 'Viandas y planes semanales',
    description:
        'Ubicado en Carriego 33. Ofrece viandas y planes semanales con opciones equilibradas para almuerzos y cenas.',
    category: OpportunityCategory.viandas,
    tags: [OpportunityTag.practical, OpportunityTag.direct],
    highlights: [
      'Viandas y planes semanales',
      'Opciones saludables',
      'Consultá menús, modalidades y precios por WhatsApp',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454268915',
        icon: 'whatsapp',
      ),
    ],
  ),
  OpportunityItem(
    id: 'bar-idea',
    title: 'Bar Ideal',
    subtitle: 'Un clásico gastronómico de Concordia',
    description:
        'Ubicado en 1.º de Mayo 51, esquina Urquiza, frente a la Plaza 25 de Mayo. Bar y restaurante tradicional con pizzas, empanadas y otros platos, con servicio de entrega.',
    category: OpportunityCategory.gastronomy,
    latitude: -31.3978458,
    longitude: -58.0177876,
    mapAddress: '1° de Mayo 51',
    tags: [OpportunityTag.classic, OpportunityTag.highlighted],
    highlights: [
      'Pizzas, empanadas y platos tradicionales',
      'Servicio de entrega y consultas para grupos',
      'Ubicación frente a Plaza 25 de Mayo',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454091184',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Llamar', url: 'tel:03454212668', icon: 'web'),
      ContactAction(
        label: 'Más información',
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
        'Ubicada en Carlos Pellegrini 580. Ofrece pizzas, empanadas, sándwiches y otros platos. Horario informado: de lunes a domingo, de 19:00 a 00:30.',
    category: OpportunityCategory.gastronomy,
    tags: [OpportunityTag.classic, OpportunityTag.direct],
    highlights: [
      'Pizzas, empanadas y sándwiches',
      'Horario informado: todos los días, de 19:00 a 00:30',
      'Pedidos por WhatsApp',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454154991',
        icon: 'whatsapp',
      ),
      ContactAction(label: 'Llamar', url: 'tel:03454222822', icon: 'web'),
    ],
  ),
  OpportunityItem(
    id: 'parrilla-el-gordo',
    title: 'Parrilla El Gordo',
    subtitle: 'Parrilla de ambiente sencillo y porciones abundantes',
    description:
        'Ubicada en 1.º de Mayo 194. Ofrece parrilla, pastas y minutas en un ambiente sencillo.',
    category: OpportunityCategory.gastronomy,
    latitude: -31.3982169,
    longitude: -58.0149046,
    mapAddress: '1° de Mayo 194',
    tags: [OpportunityTag.classic, OpportunityTag.direct],
    highlights: [
      'Consultas por WhatsApp',
      'Propuesta para almorzar o cenar',
      'Consultá precios y disponibilidad antes de ir',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454226311',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Guía oficial',
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
        'Propuesta informal dentro de Mercado Plaza, en 1.º de Mayo 101. Abre todos los días desde las 11:00 hasta el cierre, según su ficha institucional.',
    category: OpportunityCategory.gastronomy,
    tags: [OpportunityTag.direct, OpportunityTag.paseo],
    highlights: [
      'Contacto directo por WhatsApp',
      'Ubicado en Mercado Plaza',
      'Horario publicado: todos los días desde las 11:00',
    ],
    actions: [
      ContactAction(
        label: 'WhatsApp',
        url: 'https://wa.me/5493454063587',
        icon: 'whatsapp',
      ),
      ContactAction(
        label: 'Más información',
        url: 'https://ahgconcordia.com.ar/asociado/richmond-street-food-bar/',
        icon: 'web',
      ),
    ],
  ),
  OpportunityItem(
    id: 'parque-san-carlos',
    title: 'Parque y Castillo San Carlos',
    subtitle: 'Naturaleza, patrimonio y El Principito',
    description:
        'Área natural protegida de 98 hectáreas, ubicada a pocos minutos del centro. Dentro del parque se encuentran las ruinas del Castillo San Carlos, vinculadas con la estadía de Antoine de Saint-Exupéry en Concordia.',
    category: OpportunityCategory.places,
    latitude: -31.3661114,
    longitude: -57.9985275,
    mapAddress: 'Parque San Carlos, Concordia',
    tags: [
      OpportunityTag.paseo,
      OpportunityTag.outdoors,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Área protegida con senderos, miradores y espacios verdes',
      'Incluye el Castillo San Carlos y referencias a El Principito',
      'Adecuado para una recorrida de media tarde',
    ],
    actions: [
      ContactAction(
        label: 'Cómo llegar',
        url:
            'https://www.google.com/maps/search/?api=1&query=Parque+San+Carlos+Concordia+Entre+R%C3%ADos',
        icon: 'web',
      ),
      ContactAction(
        label: 'Guía oficial',
        url:
            'https://www.concordia.gob.ar/turismo/atractivos/parque-san-carlos',
        icon: 'web',
      ),
    ],
    note:
        'Es un paseo principalmente al aire libre. Revisá el pronóstico y consultá las condiciones de acceso al Castillo antes de ir.',
  ),
  OpportunityItem(
    id: 'costanera',
    title: 'Costanera de Concordia',
    subtitle: 'Paseo urbano junto al río Uruguay',
    description:
        'Sector ribereño para caminar, descansar y recorrer espacios como el Parque Mitre. Incluye un circuito de movilidad sustentable señalizado de aproximadamente tres kilómetros.',
    category: OpportunityCategory.places,
    latitude: -31.4025007,
    longitude: -58.0051035,
    mapAddress: 'Costanera de Concordia',
    tags: [OpportunityTag.paseo, OpportunityTag.outdoors],
    highlights: [
      'Alternativa cercana para una visita breve',
      'Circuito al aire libre para caminar o andar en bicicleta',
      'Se puede combinar con gastronomía y otros puntos del centro',
    ],
    actions: [
      ContactAction(
        label: 'Cómo llegar',
        url:
            'https://www.google.com/maps/search/?api=1&query=Costanera+de+Concordia+Entre+R%C3%ADos',
        icon: 'web',
      ),
      ContactAction(
        label: 'Guía oficial',
        url: 'https://www.concordia.gob.ar/turismo/atractivos/costanera',
        icon: 'web',
      ),
    ],
    note:
        'La experiencia depende del clima y del estado del paseo ribereño. Consultá avisos locales si hubo lluvias o crecidas.',
  ),
  OpportunityItem(
    id: 'museo-arruabarrena',
    title: 'Museo Regional Palacio Arruabarrena',
    subtitle: 'Historia regional en un palacio de comienzos del siglo XX',
    description:
        'Museo municipal ubicado frente a la Plaza Urquiza, en un edificio construido entre 1916 y 1919. Sus salas reúnen objetos, fotografías y testimonios vinculados con la historia de Concordia y la región.',
    category: OpportunityCategory.places,
    latitude: -31.3914250,
    longitude: -58.0174850,
    mapAddress: 'Ramírez y Entre Ríos, Concordia',
    tags: [
      OpportunityTag.paseo,
      OpportunityTag.culture,
      OpportunityTag.highlighted,
    ],
    highlights: [
      'Propuesta especialmente vinculada con la historia local',
      'Edificio patrimonial frente a la Plaza Urquiza',
      'Opción céntrica y adecuada para una visita breve',
    ],
    actions: [
      ContactAction(
        label: 'Cómo llegar',
        url:
            'https://www.google.com/maps/search/?api=1&query=Museo+Regional+Palacio+Arruabarrena+Concordia',
        icon: 'web',
      ),
      ContactAction(
        label: 'Guía oficial',
        url:
            'https://www.concordia.gob.ar/turismo/atractivos/museos/museo-arruabarrena',
        icon: 'web',
      ),
    ],
    note:
        'Los horarios de museos pueden modificarse por actividades especiales o feriados. Confirmalos antes de organizar la visita.',
  ),
  OpportunityItem(
    id: 'museo-salto-grande',
    title: 'Museo y Centro Cultural Salto Grande',
    subtitle: 'Historia, tecnología e integración binacional',
    description:
        'Espacio situado dentro del Complejo Hidroeléctrico Salto Grande, a unos 18 kilómetros del centro. Presenta la historia de la represa, su construcción y su importancia para Argentina y Uruguay.',
    category: OpportunityCategory.places,
    latitude: -31.2748667,
    longitude: -57.9385917,
    mapAddress: 'Complejo Hidroeléctrico Salto Grande, Ruta Nacional 015',
    brandAsset: 'assets/branding/salto_grande.webp',
    tags: [OpportunityTag.paseo, OpportunityTag.culture],
    highlights: [
      'Recorrido histórico y tecnológico sobre la represa',
      'Aproximadamente 18 kilómetros desde el centro de Concordia',
      'Requiere prever traslado y tiempo adicional',
    ],
    actions: [
      ContactAction(
        label: 'Cómo llegar',
        url:
            'https://www.google.com/maps/search/?api=1&query=Museo+y+Centro+Cultural+Salto+Grande+Concordia',
        icon: 'web',
      ),
      ContactAction(
        label: 'Sitio oficial',
        url: 'https://delegacionargentinasg.org.ar/museo/',
        icon: 'web',
      ),
      ContactAction(
        label: 'Guía turística',
        url:
            'https://www.concordia.gob.ar/turismo/atractivos/museos/museo-salto-grande',
        icon: 'web',
      ),
    ],
    note:
        'Verificá horarios, modalidad de ingreso y disponibilidad de visitas guiadas antes de trasladarte al complejo.',
  ),
  OpportunityItem(
    id: 'termas-vertiente',
    title: 'Vertiente de la Concordia',
    subtitle: 'Complejo termal al norte de la ciudad',
    description:
        'Complejo termal ubicado en el acceso hacia Salto Grande. Es una alternativa apropiada para una jornada de descanso durante el invierno.',
    category: OpportunityCategory.places,
    latitude: -31.2955902,
    longitude: -58.0041958,
    mapAddress: 'Av. Monseñor Rösch y acceso a Salto Grande',
    tags: [
      OpportunityTag.paseo,
      OpportunityTag.thermal,
      OpportunityTag.outdoors,
    ],
    highlights: [
      'Propuesta termal adecuada para los días fríos',
      'Requiere más tiempo que un paseo urbano',
      'Conviene consultar tarifas, servicios y piscinas habilitadas',
    ],
    actions: [
      ContactAction(
        label: 'Cómo llegar',
        url:
            'https://www.google.com/maps/search/?api=1&query=Vertiente+de+la+Concordia+Entre+R%C3%ADos',
        icon: 'web',
      ),
      ContactAction(
        label: 'Sitio web',
        url: 'https://termasconcordia.com/',
        icon: 'web',
      ),
      ContactAction(
        label: 'Oferta termal oficial',
        url: 'https://www.concordia.gob.ar/turismo/atractivos/termas',
        icon: 'web',
      ),
    ],
    note:
        'La oferta, los horarios y las condiciones de funcionamiento pueden cambiar. Consultá directamente antes de viajar.',
  ),
];
