# Análisis completo de textos para cambiar
## De óptica de organizador → visitante/asistente del III Encuentro sobre Historia de Entre Ríos

---

## 1. Pantalla principal — `app.dart`

### 1.1 MaterialApp title
| Actual | Propuesto |
|--------|-----------|
| `'Concordia Agosto'` | `'III Encuentro ER'` |

### 1.2 Nombres de tabs
| Actual | Propuesto |
|--------|-----------|
| `'Inicio'` | `'Inicio'` (OK) |
| `'Dormir'` | `'Dormir'` (OK) |
| `'Comer'` | `'Comer'` (OK) |
| `'Paseos'` | `'Paseos'` (OK) |
| `'Guardados'` | `'Guardados'` (OK) |

### 1.3 AppBar — subtítulo
| Actual | Propuesto |
|--------|-----------|
| `'Concordia · agosto 2026'` | `'III Encuentro sobre Historia de Entre Ríos'` |

### 1.4 AppBar — tooltip botón copiar
| Actual | Propuesto |
|--------|-----------|
| `'Copiar mensaje base'` | `'Copiar mensaje de contacto'` |

### 1.5 Search hint
| Actual | Propuesto |
|--------|-----------|
| `'Buscar nombre, perfil o dato útil'` | `'Buscar alojamiento, comida o paseo'` |

### 1.6 Snackbar al copiar
| Actual | Propuesto |
|--------|-----------|
| `'Mensaje base copiado para pedir cotización.'` | `'Mensaje copiado para consultar disponibilidad.'` |

### 1.7 Subtítulo del tab Dormir
| Actual | Propuesto |
|--------|-----------|
| `'Prioridad agosto: canales directos y costo razonable.'` | `'Opciones cerca de la sede y bien ubicadas en Concordia.'` |

### 1.8 Subtítulo del tab Paseos
| Actual | Propuesto |
|--------|-----------|
| `'Lugares simples de sumar a una estadía corta.'` | `'Atractivos para conocer entre las actividades del Encuentro.'` |

---

## 2. Home Tab — `_HomeTab` en `app.dart`

### 2.1 Título principal
| Actual | Propuesto |
|--------|-----------|
| `'Concordia en agosto'` | `'III Encuentro sobre Historia de Entre Ríos'` |

### 2.2 Descripción del home
| Actual | Propuesto |
|--------|-----------|
| `'App móvil de preselección para resolver alojamiento, viandas, comida útil y paseos simples con prioridad de bajo costo.'` | `'Guía para asistentes del III Encuentro: encontrá alojamiento, comida y paseos en Concordia durante tu estadía.'` |

### 2.3 Botón copiar
| Actual | Propuesto |
|--------|-----------|
| `'Copiar mensaje base'` | `'Consultar disponibilidad'` |

### 2.4 Botón ir a alojamiento
| Actual | Propuesto |
|--------|-----------|
| `'Ir a alojamiento'` | (OK, se mantiene) |

### 2.5 Título de sección de recomendaciones
| Actual | Propuesto |
|--------|-----------|
| `'Orden recomendado'` | `'Recomendaciones para tu estadía'` |

---

## 3. Food Tab — `_FoodTab` en `app.dart`

### 3.1 Texto introductorio
| Actual | Propuesto |
|--------|-----------|
| `'Conviene resolver la base con viandas o rotisería y sumar una comida más representativa sólo cuando aporte valor real.'` | `'Durante el Encuentro: opciones rápidas para el día a día y lugares para una comida más tranquila.'` |

### 3.2 Título primera sección
| Actual | Propuesto |
|--------|-----------|
| `'Viandas y comida operativa'` | `'Comida rápida y práctica'` |

### 3.3 Subtítulo primera sección
| Actual | Propuesto |
|--------|-----------|
| `'Pensado para resolver rápido.'` | `'Ideal entre actividades del Encuentro.'` |

### 3.4 Título segunda sección
| Actual | Propuesto |
|--------|-----------|
| `'Comida destacada o accesible'` | `'Salidas gastronómicas'` |

### 3.5 Subtítulo segunda sección
| Actual | Propuesto |
|--------|-----------|
| `'Para sumar una salida más local.'` | `'Para conocer la cocina de Concordia.'` |

---

## 4. Saved Tab — `_SavedTab` en `app.dart`

### 4.1 Texto introductorio
| Actual | Propuesto |
|--------|-----------|
| `'Guardá las opciones que te sirvan para volver rápido a los contactos.'` | `'Guardá tus opciones favoritas para volver rápido a los contactos.'` |

### 4.2 Empty state
| Actual | Propuesto |
|--------|-----------|
| `'Nada guardado todavía'` / `'Marcá con la estrella los alojamientos, viandas o paseos que quieras seguir.'` | (OK, se mantiene — o cambiar a: `'Todavía no guardaste nada' / 'Usá la estrella en cada opción para guardarla acá.'`) |

---

## 5. Opportunity List Tab — `_OpportunityListTab` en `app.dart`

### 5.1 Empty state
| Actual | Propuesto |
|--------|-----------|
| `'No hay coincidencias'` / `'Probá con otra búsqueda dentro de esta sección.'` | (OK, se mantiene) |

---

## 6. Chips de etiquetas — `_tagChip` en `app.dart`

### 6.1 Etiquetas de OpportunityTag
| Tag | Label actual | Propuesto |
|-----|-------------|-----------|
| `group` | `'Grupo'` | `'Ideal para grupos'` |
| `budget` | `'Más barato'` | `'Económico'` |
| `direct` | `'Canal directo'` | `'Contacto directo'` |
| `classic` | `'Clásico'` | `'Clásico'` (OK) |
| `thermal` | `'Termal'` | `'Termal'` (OK) |
| `practical` | `'Práctico'` | `'Práctico'` (OK) |
| `paseo` | `'Paseo'` | `'Paseo'` (OK) |
| `highlighted` | `'Prioridad'` | `'Recomendado'` |

---

## 7. Datos — `data.dart`

### 7.1 `homeHighlights` captions
| Actual | Propuesto |
|--------|-----------|
| `'Opciones prioritarias para consultar primero'` | `'Opciones de alojamiento para tu estadía'` |
| `'Canales prácticos para resolver comida'` | `'Dónde comer durante el evento'` |
| `'Lugares simples de sumar en una estadía corta'` | `'Atractivos para conocer en tu tiempo libre'` |

### 7.2 `topRecommendations`
| Actual | Propuesto |
|--------|-----------|
| `'Pedir primero un bloqueo grupal a Centro Plaza Hotel.'` | `'Centro Plaza Hotel: céntrico y con buena capacidad para asistentes.'` |
| `'Medir ahorro real con Casa Di Aqua y opciones de alquiler turístico.'` | `'Casa Di Aqua: departamentos flexibles si viajás en grupo.'` |
| `'Resolver comida base con Tus Viandas o Yantar.'` | `'Tus Viandas y Yantar: opciones rápidas y accesibles.'` |
| `'Usar Costanera y Parque San Carlos como paseos simples y rendidores.'` | `'Costanera y Parque San Carlos: ideales para una tarde libre.'` |

### 7.3 `cannedMessage`
| Actual | Propuesto |
|--------|-----------|
| `'Hola, consulto disponibilidad y tarifa para agosto para un grupo. Buscamos una opción práctica y económica. ¿Podrían pasar capacidad, precio y qué incluye?'` | `'Hola, soy asistente del III Encuentro sobre Historia de Entre Ríos en Concordia. Quería consultar disponibilidad y tarifa para las fechas del evento. ¿Podrían pasarme precios y qué incluye?'` |

### 7.4 Oportunidades de alojamiento

#### Centro Plaza Hotel
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'La consulta más fuerte para concentrar el grupo'` | `'Céntrico y con buena capacidad'` |
| description | `'Es la mejor opción cuando conviene resolver muchas plazas en un solo edificio céntrico.'` | `'Muy bien ubicado en el centro de Concordia. Ideal por su capacidad y desayuno incluido.'` |
| highlights[2] | `'Buena base para una sola sede'` | `'Cerca de la sede del Encuentro'` |
| note | `'Conviene pedir tarifa por bloque y condiciones de desayuno.'` | `'Consultar disponibilidad con anticipación por las fechas del Encuentro.'` |

#### Casa Di Aqua Apart Hotel
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Flexible para repartir gente y bajar costo por unidad'` | `'Departamentos para grupos o familias'` |
| description | `'Rinde cuando el grupo puede dividirse en departamentos más chicos sin perder orden operativo.'` | `'Buena opción si viajás con compañeros del Encuentro y preferís departamentos con cocina.'` |
| highlights[1] | `'Perfil apto para contingentes'` | `'Cocina incluida en cada unidad'` |

#### El Bicho Negro Hostel
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Hostel de perfil más agresivo en costo'` | `'Hostel económico y bien conectado'` |
| description | `'Sirve cuando el objetivo principal es reducir gasto y aceptar formato compartido.'` | `'Perfecto si viajás con presupuesto ajustado y preferís un ambiente más social.'` |

#### Alojamiento Avenida
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Casa de alquiler turística accesible'` | (OK, se mantiene) |
| description | `'Buena línea para salir de hotelería clásica y abrir una negociación más económica.'` | `'Alternativa económica con trato directo. Ideal para estadías independientes.'` |
| highlights[2] | `'Útil como opción de costo contenido'` | `'Buen costo para estadías largas'` |

#### Hospedaje V.Z.
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Alternativa económica y directa'` | (OK, se mantiene) |
| description | `'Sirve para ampliar capacidad con un formato más simple y probablemente más barato.'` | `'Opción sencilla y económica para quien prioriza el precio.'` |

#### Termal del Lago
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Más completo que económico'` | `'Comodidad y entorno termal'` |
| description | `'Sirve cuando se prioriza comodidad y entorno termal por encima del costo más bajo.'` | `'Para quienes buscan una experiencia más completa con pileta termal y buenos servicios.'` |
| highlights[2] | `'Mejor para una estadía más cuidada'` | `'Buena relación comodidad-precio'` |

#### Casa Nebel
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Casa turística para sumar plazas con canal directo'` | `'Casa de alquiler con trato directo'` |
| description | `'Sirve para ampliar capacidad fuera del formato hotelero tradicional y pelear un costo más flexible.'` | `'Alquiler completo con buena capacidad. Ideal si viajás en grupo de compañeros.'` |

#### Hathor Concordia
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Plan B de escala hotelera más completa'` | `'Hotel formal como alternativa'` |
| description | `'No es la línea más barata, pero sirve como respaldo cuando se necesita una operación más cerrada y formal.'` | `'Hotel de perfil corporativo. Buena opción si querés asegurar reserva formal.'` |
| highlights[2] | `'Útil como respaldo si falla la primera línea económica'` | `'Reserva formal y segura'` |

### 7.5 Oportunidades de viandas

#### Tus Viandas Concordia
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'La opción más directa para resolver viandas'` | `'Viandas prácticas para el día a día'` |
| description | `'Es la referencia más alineada con comida operativa, simple y accionable.'` | `'Perfecto para llevar comida resuelta durante los días del Encuentro.'` |
| highlights[0] | `'Perfil específico de viandas'` | `'Opción práctica para almuerzos'` |
| highlights[2] | `'Muy útil para resolver base alimentaria'` | `'Buena relación precio-cantidad'` |

#### Yantar Rotisería
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Comida rendidora y operativa'` | `'Rotisería céntrica y accesible'` |
| description | `'Muy buena alternativa para resolver una comida completa sin complejidad.'` | `'Buena para comprar comida preparada y seguir con las actividades.'` |

#### Yantar de la Costa
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Comida práctica con salida combinada'` | `'Comida en la zona de la Costanera'` |
| description | `'Puede funcionar para vincular comida y paseo en la zona de Costanera.'` | `'Ideal para combinar una comida con una caminata por la Costanera.'` |

### 7.6 Oportunidades de gastronomía

#### Bar Ideal
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Clásico de Concordia'` | (OK, se mantiene) |
| description | `'Sirve cuando se quiere una comida más identitaria sin mucha producción extra.'` | `'Un clásico de Concordia para una comida tradicional sin vueltas.'` |

#### Parrilla El Gordo
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Parrilla accesible y utilizable'` | `'Buena parrilla a precio razonable'` |
| description | `'Rinde para una comida más fuerte con perfil simple y accionable.'` | `'Para una comida contundente sin gastar de más. Ideal para cerrar el día.'` |

#### Richmond Street Food Bar
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Opción urbana dentro de Mercado Plaza'` | `'Comida casual en pleno centro'` |
| description | `'Sirve para una salida más liviana y moderna dentro del circuito gastronómico.'` | `'Opción moderna y rápida en el centro. Buena para una salida entre actividades.'` |

### 7.7 Oportunidades de paseos

#### Parque San Carlos
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| description | `'Uno de los puntos más reconocibles de la ciudad, con mezcla de naturaleza e historia.'` | (OK, se mantiene — habla de historia, buen fit) |
| highlights[0] | `'Muy representativo de Concordia'` | `'Naturaleza e historia en un solo lugar'` |

#### Costanera
| Descripción | (OK, se mantiene) |
|---|---|

#### Termas
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Salida fuerte para invierno'` | `'Plan termal para agosto'` |
| description | `'Uno de los grandes atractivos de Concordia y un argumento claro para agosto.'` | `'Imperdible de Concordia. Perfecto para una tarde libre durante el Encuentro.'` |

#### ConcorPass
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| description | `'Sirve para revisar beneficios y apoyarse en la oferta turística oficial antes de cerrar el plan de paseo.'` | `'Pase turístico oficial para acceder a beneficios y descuentos durante tu estadía.'` |

#### Portal de Turismo
| Campo | Actual | Propuesto |
|-------|--------|-----------|
| subtitle | `'Base oficial para ampliar agenda y servicios'` | `'Web oficial de turismo de Concordia'` |
| description | `'Sirve como referencia rápida para ampliar hospedajes, gastronomía y destacados sin salir del entorno oficial.'` | `'Toda la información turística de Concordia en un solo lugar para completar tu agenda.'` |
| highlights[0] | `'Fuente oficial consolidada'` | `'Guía oficial de la ciudad'` |

---

## 8. Resumen de archivos a modificar

| Archivo | Cantidad de cambios |
|---------|---------------------|
| `lib/src/app.dart` | ~16 textos |
| `lib/src/data.dart` | ~50+ textos (títulos, subtítulos, descripciones, highlights, notas) |
| `lib/src/models.dart` | 0 (solo estructura, no textos visibles) |

**Total estimado: ~70 textos a actualizar.**
