# Reorganización de Paseos, sedes e información útil

Fecha de revisión: 10 de julio de 2026.

## Resultado funcional

La categoría `OpportunityCategory.places` contiene ahora únicamente atractivos turísticos o culturales con ubicación concreta:

1. Parque y Castillo San Carlos.
2. Costanera de Concordia.
3. Museo Regional Palacio Arruabarrena.
4. Museo y Centro Cultural Salto Grande.
5. Vertiente de la Concordia.

Todos cuentan con coordenadas para el mapa, enlace de navegación y una fuente informativa institucional o propia.

## Contenido retirado de Paseos

- Profesorado Superior de Ciencias Sociales.
- Facultad de Ciencias de la Administración de la UNER.
- Portal de Turismo.
- Tarjeta genérica «Termas».

Las dos sedes se muestran ahora en Inicio dentro de un bloque específico llamado `Sedes del Encuentro`, con fecha, horario, actividad, dirección y botón `Cómo llegar`.

El Portal de Turismo pasó a `Información útil`, también en Inicio.

## Incorporaciones

- Bloque de sedes en Inicio.
- Acceso al correo oficial de consultas del Encuentro.
- Acceso a la publicación institucional de INES CONICET-UNER.
- Acceso al Portal de Turismo y al catálogo oficial de atractivos.
- Museo Regional Palacio Arruabarrena.
- Museo y Centro Cultural Salto Grande.
- Etiquetas `Cultural` y `Al aire libre`.
- Advertencia general para confirmar horarios, tarifas, accesibilidad y condiciones de ingreso.
- Resumen del mapa renombrado como `Paseos y atractivos`.

## Criterios de contenido

Se evitaron precios o cronogramas turísticos rígidos dentro de las tarjetas porque pueden cambiar antes de agosto. Las tarjetas remiten a la fuente correspondiente y advierten que se confirme la información vigente.

No se incorporaron playas por tratarse de una visita prevista para agosto. Tampoco se cargaron numerosos museos o tres complejos termales distintos para evitar una pantalla extensa y repetitiva.

## Fuentes consultadas

- INES CONICET-UNER: https://ines.conicet.gov.ar/iii-encuentro-sobre-historia-de-entre-rios/
- Turismo Concordia, atractivos: https://www.concordia.gob.ar/turismo/atractivos
- Parque San Carlos: https://www.concordia.gob.ar/turismo/atractivos/parque-san-carlos
- Costanera: https://www.concordia.gob.ar/turismo/atractivos/costanera
- Museo Arruabarrena: https://www.concordia.gob.ar/turismo/atractivos/museos/museo-arruabarrena
- Museo Salto Grande: https://delegacionargentinasg.org.ar/museo/
- Guía turística del Museo Salto Grande: https://www.concordia.gob.ar/turismo/atractivos/museos/museo-salto-grande
- Termas Concordia: https://termasconcordia.com/
- Oferta termal municipal: https://www.concordia.gob.ar/turismo/atractivos/termas

## Validaciones realizadas

- Llaves, paréntesis, corchetes, cadenas y comentarios balanceados en todos los archivos Dart.
- 30 identificadores de tarjetas, todos únicos.
- 5 tarjetas turísticas, todas con coordenadas.
- 76 enlaces con esquemas admitidos (`http`, `https`, `mailto` o `tel`).
- Eliminación comprobada de los identificadores antiguos de sedes y Portal de Turismo dentro de Paseos.

No fue posible ejecutar `flutter analyze` porque el entorno no dispone de Flutter ni del SDK de Dart.
