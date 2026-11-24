import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);
Future<void> save(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Save'));
  await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('authenticated card pushes form and system back returns home', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
  });
  testWidgets('authenticated drawer replaces form and returns Home', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(Form), findsOneWidget);
    expect(Navigator.of(tester.element(find.byType(Form))).canPop(), isFalse);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
  });
  testWidgets('required text and unsafe URLs are rejected', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.text('Kolom ini wajib diisi.'), findsNWidgets(3));
    await tester.enterText(field('Title'), '   ');
    await tester.enterText(field('Project URL'), 'javascript:alert(1)');
    await save(tester);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.textContaining('Masukkan URL http/https'), findsOneWidget);
  });
  testWidgets('server confirmation shows fields and resets on a small screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp());
    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    for (final entry in {
      'Title': 'Portfolio',
      'Description': 'Aplikasi pribadi',
      'Tech Stack': 'Flutter',
      'Project URL': 'https://example.com',
    }.entries) {
      await tester.ensureVisible(field(entry.key));
      await tester.enterText(field(entry.key), entry.value);
    }
    await save(tester);
    expect(find.text('Proyek berhasil disimpan!'), findsOneWidget);
    expect(find.textContaining('Tech Stack: Flutter'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final editable in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(editable.controller.text, isEmpty);
    }
  });
}
