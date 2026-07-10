import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:concordia_agosto_mobile/src/app.dart';
import 'package:concordia_agosto_mobile/src/data.dart';
import 'package:concordia_agosto_mobile/src/map_screen.dart';
import 'package:concordia_agosto_mobile/src/models.dart';

void main() {
  testWidgets('loads Concordia mobile home', (WidgetTester tester) async {
    await tester.pumpWidget(const ConcordiaApp());

    expect(
      find.text('III Encuentro · Concordia · agosto 2026'),
      findsOneWidget,
    );
    expect(find.text('Dormir'), findsOneWidget);
    expect(find.text('Comer'), findsOneWidget);
  });

  test('normalizes Spanish accents for search', () {
    expect(
      normalizeSearchText('Gastronomía, Ñandú y Útil'),
      'gastronomia, nandu y util',
    );
  });

  test('opportunity ids and action URLs remain valid', () {
    final ids = opportunities.map((item) => item.id).toSet();
    expect(ids.length, opportunities.length);

    for (final item in opportunities) {
      expect(item.searchableText, isNotEmpty);
      for (final action in item.actions) {
        final uri = Uri.tryParse(action.url);
        expect(uri, isNotNull, reason: item.id);
        expect(
          const {'http', 'https', 'mailto', 'tel'},
          contains(uri!.scheme),
          reason: '${item.id}: ${action.url}',
        );
      }
    }
  });

  testWidgets('builds the Concordia map screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ConcordiaMapScreen()));

    expect(find.text('Lugares para conocer'), findsOneWidget);
    expect(find.byTooltip('Acercar'), findsOneWidget);
    expect(find.text('Hoteles'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('Paseos'), findsOneWidget);
  });

  testWidgets('expands the top search when the home scrolls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ConcordiaApp());

    expect(find.byTooltip('Abrir búsqueda'), findsOneWidget);
    await tester.drag(
      find.byKey(const ValueKey('home')),
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Buscar'), findsOneWidget);
  });
}
