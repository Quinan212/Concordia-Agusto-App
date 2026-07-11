# Revisión textual de la app

Se revisaron los textos visibles contenidos en `lib/`, con foco en ortografía, claridad, consistencia, tono y precisión de las etiquetas.

## Cambios principales

- Se unificó el tono en voseo y se eliminaron formulaciones repetitivas o poco informativas.
- Se normalizaron etiquetas de contacto: `Correo`, `Sitio web`, `Llamar`, `Guía oficial`, `Más información`, `Ver tarifas` y `Cómo llegar`.
- Se corrigió la fecha de apertura del Encuentro: jueves 13 de agosto de 2026.
- Se incorporaron las fechas completas del evento: 13 y 14 de agosto de 2026.
- Se mejoró el mensaje para consultar alojamiento, incluyendo precio final, horarios y condiciones de reserva.
- Se reemplazaron anglicismos evitables, por ejemplo `room service` por `servicio a la habitación` y `single` por `individual`.
- Se revisaron descripciones de alojamientos, viandas, restaurantes, sedes y paseos para hacerlas más concretas.
- Se retiró un precio fijo de viandas que podía quedar desactualizado y se agregó una indicación para consultar el valor vigente.
- Se suavizó la afirmación sanitaria `apta para celíacos` y se agregó una advertencia sobre ingredientes, manipulación y posibles trazas.
- Se agregó una aclaración general para confirmar tarifas, horarios, disponibilidad, accesibilidad y condiciones.
- Se corrigió el singular de `1 opción guardada`.
- El resumen del mapa ahora adapta el título al filtro seleccionado y usa `ubicación` o `ubicaciones` según corresponda.
- Se corrigieron dos números de WhatsApp que estaban duplicados por error: Residencial Hotel Concordia y Espacio Saludable Concordia.

## Alcance técnico

La estructura principal y las funciones de la aplicación se conservaron. Solo se hicieron ajustes mínimos vinculados directamente con la presentación correcta de los textos.

## Recomendación de mantenimiento

Los horarios, precios, teléfonos, servicios y disponibilidad pueden cambiar. Conviene realizar una verificación final de los datos comerciales cerca de la fecha de publicación de la app.

## Segunda pasada: contraste web aplicado (10 de julio de 2026)

- Se corrigió el WhatsApp de Residencial Hotel Concordia a `+54 9 345 428-2644` y se agregaron su correo y la ficha turística municipal.
- Se corrigió el WhatsApp de Richmond Street Food Bar a `+54 9 345 406-3587`; también se incorporaron dirección y horario publicados por la Asociación Hotelera Gastronómica.
- Se retiró ConcorPass de las recomendaciones porque el portal municipal informa que el programa finalizó.
- El Profesorado Superior de Ciencias Sociales pasó a figurar como sede de apertura y cine debate. FCAD-UNER se mantiene como sede principal de mesas y exposiciones.
- Se incorporaron el correo de consultas del Encuentro y el enlace institucional de INES en las dos tarjetas de sede.
- Se completaron datos confirmados de Casa di Aqua, Alojamiento Avenida, Hospedaje V.Z. y Casa Nebel.
- Se hizo una verificación estructural de delimitadores y cadenas en todos los archivos Dart. El entorno no incluye Flutter ni Dart SDK, por lo que no fue posible ejecutar `flutter analyze` o `dart format`.
