import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  testWidgets('shows the owner profile and menu', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final text in [
      'MyPortfolio',
      '2506657005',
      'Mohammad Adzka Aulia',
      'PBP F',
      'Selamat datang di MyPortfolio Mobile!',
      'Lihat Proyek',
      'Tambah Proyek',
      'Logout',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('action cards have distinct readable backgrounds', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final cards = tester.widgetList<Material>(
      find.descendant(
        of: find.byType(ItemCard),
        matching: find.byType(Material),
      ),
    );
    expect(cards, hasLength(3));
    expect(cards.map((card) => card.color).toSet(), hasLength(3));
    for (final card in cards) {
      expect(card.color, isNotNull);
      final contrast = 1.05 / (card.color!.computeLuminance() + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5));
    }
  });

  testWidgets(
    'each menu button shows its message and replaces the previous one',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      String? previous;
      for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
        if (previous != null) {
          expect(
            find.text('Kamu telah menekan tombol $previous!'),
            findsNothing,
          );
        }
        previous = label;
      }
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('layout has no overflow at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MyApp());
      expect(tester.takeException(), isNull);
      expect(find.text('Logout'), findsOneWidget);
    });
  }
}
