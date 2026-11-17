import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> save(WidgetTester tester) async {
  // Let the navigation SnackBar expire before tapping the bottom button.
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Save'));
  await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('add card pushes the form and system back returns home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!'),
      findsOneWidget,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
    expect(find.text('Add Project Form'), findsNothing);
  });

  testWidgets('drawer replaces routes and closes after selection', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    expect(Navigator.of(tester.element(find.byType(Form))).canPop(), isFalse);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(Scaffold))).canPop(),
      isFalse,
    );
    expect(
      find.text('Explore personal projects and experiences!'),
      findsNothing,
    );
  });

  testWidgets('blank and whitespace-only required fields are rejected', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(field('Nama Proyek'), '   ');
    await tester.enterText(field('Deskripsi Proyek'), '   ');
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('confirmation shows all fields and reset prevents stale values', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Nama Proyek'), 'Portfolio');
    await tester.enterText(field('Deskripsi Proyek'), 'Aplikasi pribadi');
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Data Science').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      field('Teknologi yang Digunakan'),
      'Flutter, Django',
    );
    await tester.enterText(field('Tautan Proyek'), 'https://example.com');
    await save(tester);
    for (final text in [
      'Nama Proyek: Portfolio',
      'Deskripsi: Aplikasi pribadi',
      'Kategori: Data Science',
      'Teknologi: Flutter, Django',
      'Tautan: https://example.com',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final editable in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(editable.controller.text, isEmpty);
    }
    expect(find.text('Web Development'), findsOneWidget);
    await tester.enterText(field('Nama Proyek'), 'Kedua');
    await tester.enterText(field('Deskripsi Proyek'), 'Deskripsi kedua');
    await save(tester);
    expect(find.text('Nama Proyek: Kedua'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('form and long confirmation fit a small screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(field('Nama Proyek'), 'Proyek panjang ' * 10);
    await tester.enterText(
      field('Deskripsi Proyek'),
      'Deskripsi panjang ' * 50,
    );
    await save(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
