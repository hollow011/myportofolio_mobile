import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('shows the tutorial profile and menu', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final text in [
      'MyPortfolio',
      '2406000001',
      'Burhan',
      'PBP A',
      'Selamat datang di MyPortfolio Mobile!',
      'Lihat Proyek',
      'Tambah Proyek',
      'Logout',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    expect(find.byType(FloatingActionButton), findsNothing);
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
