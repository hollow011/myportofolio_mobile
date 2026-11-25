import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'test_app.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> openForm(WidgetTester tester, {ApiClient? api}) async {
  await tester.pumpWidget(testApp(api: api));
  await tester.ensureVisible(find.text('Tambah Edukasi'));
  await tester.tap(find.text('Tambah Edukasi'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

Future<void> save(WidgetTester tester) async {
  await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Simpan'));
  await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
  await tester.pumpAndSettle();
}

Future<void> selectDegree(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('education card pushes a route and back restores home', (
    tester,
  ) async {
    await openForm(tester);
    expect(find.text('Tambah Edukasi'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
  });

  testWidgets(
    'shared drawer retains project and home routes alongside education',
    (tester) async {
      await tester.pumpWidget(testApp());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Add Project'), findsOneWidget);
      await tester.tap(find.text('Add Education'));
      await tester.pumpAndSettle();
      expect(find.byType(Form), findsOneWidget);
      expect(Navigator.of(tester.element(find.byType(Form))).canPop(), isFalse);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
      expect(find.byType(Form), findsNothing);
    },
  );

  testWidgets(
    'required fields reject blanks and whitespace before showing a dialog',
    (tester) async {
      await openForm(tester);
      await save(tester);
      expect(find.text('Institusi wajib diisi.'), findsOneWidget);
      expect(find.text('Pilih jenjang pendidikan.'), findsOneWidget);
      expect(find.text('Bidang studi wajib diisi.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.enterText(field('Institusi'), '   ');
      await tester.enterText(field('Bidang Studi'), '\t  ');
      await save(tester);
      expect(find.text('Institusi wajib diisi.'), findsOneWidget);
      expect(find.text('Bidang studi wajib diisi.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets('model length limits reject 256 characters and accept 255', (
    tester,
  ) async {
    await openForm(tester);
    await selectDegree(tester, "Bachelor's degree");
    await tester.enterText(field('Institusi'), 'A' * 256);
    await tester.enterText(field('Bidang Studi'), 'B' * 256);
    await save(tester);
    expect(find.text('Institusi maksimal 255 karakter.'), findsOneWidget);
    expect(find.text('Bidang studi maksimal 255 karakter.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(field('Institusi'), 'A' * 255);
    await tester.enterText(field('Bidang Studi'), 'B' * 255);
    await save(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'confirmed write sends editable fields and opens a freshly fetched list',
    (tester) async {
      Map<String, dynamic>? saved;
      final api = ApiClient(
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/education/');
          if (request.method == 'POST') {
            expect(request.headers['authorization'], 'Token test-token');
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(body.keys.toSet(), {
              'institution',
              'degree',
              'field_of_study',
              'description',
              'website',
              'is_current',
            });
            expect(body['degree'], 'bachelor');
            expect(body['field_of_study'], 'Ilmu Komputer');
            expect(body['institution'], 'Universitas Indonesia');
            saved = {
              ...body,
              'id': '123',
              'degree_display': "Bachelor's degree",
            };
            return http.Response(jsonEncode(saved), 201);
          }
          expect(request.headers['authorization'], isNull);
          return http.Response(jsonEncode([saved!]), 200);
        }),
      );
      await openForm(tester, api: api);
      await tester.enterText(field('Institusi'), '  Universitas Indonesia  ');
      await tester.enterText(field('Bidang Studi'), '  Ilmu Komputer  ');
      await selectDegree(tester, "Bachelor's degree");
      await save(tester);
      expect(find.text('Institusi: Universitas Indonesia'), findsOneWidget);
      expect(
        find.text("Jenjang Pendidikan: Bachelor's degree"),
        findsOneWidget,
      );
      expect(find.text('Bidang Studi: Ilmu Komputer'), findsOneWidget);
      await tester.tap(find.text('Lihat Edukasi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Universitas Indonesia'));
      await tester.pumpAndSettle();
      expect(find.text('Detail Edukasi'), findsOneWidget);
      expect(find.text('Ilmu Komputer'), findsOneWidget);
    },
  );

  testWidgets('revoked Education token requests login and retains the draft', (
    tester,
  ) async {
    var attempts = 0;
    final api = ApiClient(
      client: MockClient((req) async {
        expect(req.url.path, '/api/v1/education/');
        attempts++;
        return http.Response('', 401);
      }),
    );
    await openForm(tester, api: api);
    await tester.enterText(field('Institusi'), 'UI');
    await tester.enterText(field('Bidang Studi'), 'CS');
    await selectDegree(tester, 'Diploma');
    await save(tester);
    expect(field('Password'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('UI'), findsOneWidget);
    await save(tester);
    expect(field('Password'), findsOneWidget);
    expect(attempts, 1);
  });

  testWidgets('save remains reachable on a phone with keyboard insets', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await openForm(tester);
    await selectDegree(tester, 'Diploma');
    await tester.enterText(field('Institusi'), 'Institusi');
    await tester.enterText(field('Bidang Studi'), 'Informatika');
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Lihat Edukasi'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
