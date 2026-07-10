# Prompt para agente de textos

Che, necesito un laburo grosísimo de análisis textual. Te paso la carpeta `lib/` de una app Flutter. La app originalmente fue pensada desde la óptica de un **organizador de viaje grupal** (ponele, un coordinador que negocia bloques de habitaciones, calcula costos, etc.). Pero la realidad es que la app la van a usar **visitantes/asistentes** al **III Encuentro sobre Historia de Entre Ríos** en Concordia.

Necesito que:

1. **Leas todos los archivos Dart** de la carpeta `lib/` (`app.dart`, `data.dart`, `models.dart`).
2. **Encontrés TODOS los textos visibles** — cada string literal que aparece en la interfaz: títulos, subtítulos, descripciones, subtítulos de tabs, botones, tooltips, hint del buscador, snackbars, etiquetas de chips, empty states, y especialmente los ~16 items de datos (alojamientos, viandas, gastronomía, paseos) con sus subtítulos, descripciones, highlights y notas.
3. **Para cada texto**, anotá:
   - Archivo y línea exacta donde está
   - El texto actual
   - Una propuesta de texto nuevo desde la óptica del **visitante** (no del organizador)

La posta: tenés que cambiar el tono de TODO. Ejemplos de lo que NO va más:
- `"Sirve cuando el grupo puede dividirse..."` → es organizador
- `"Rinde para una comida más fuerte..."` → es organizador
- `"Pedir primero un bloqueo grupal..."` → es organizador
- `"Conviene resolver la base con viandas..."` → es organizador

Ejemplos de lo que SÍ va:
- `"Ideal si viajás solo o en pareja..."` → es visitante
- `"Perfecto para una tarde libre durante el Encuentro."` → es visitante
- `"Buena opción para comprar comida preparada entre actividades."` → es visitante

La carpeta está en:
```
C:\Users\alanm\Desktop\StudioProjects\concordia_agosto_mobile\lib\
```

Archivos a revisar:
- `lib/src/app.dart` (~891 líneas) — toda la UI
- `lib/src/data.dart` (~566 líneas) — todos los datos textuales
- `lib/src/models.dart` (~60 líneas) — solo modelos, sin textos visibles

**Importante:** No te olvides de:
- Los chips de etiquetas (`_tagChip`) que tienen labels como "Más barato", "Canal directo", "Prioridad", etc.
- Los textos de los `OpportunityCard` (título, subtítulo, descripción, highlights, note)
- Los `homeHighlights` captions
- Las `topRecommendations`
- El `cannedMessage`
- Los empty states
- El hint del buscador
- Los tooltips y snackbars

**Formato de salida:** Un markdown con TODA la data tabulada. Tres columnas: `Archivo:línea | Texto actual | Texto propuesto`. Agrupá por archivo. Ponelo en español argentino relajado pero prolijo.

Hacelo completo, no te zarpes con resumir al pedo. Aunque sean 100+ textos, quiero todos.
