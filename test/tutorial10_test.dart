import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'test_app.dart';

const projectJson = {
  'id': 'uuid',
  'title': 'Live project',
  'description': 'From Django',
  'tech_stack': 'Dart',
  'project_url': 'https://example.com',
};
Finder field(String label) => find.widgetWithText(TextFormField, label);
Future<void> login(WidgetTester tester) async {
  await tester.enterText(field('Username'), 'owner');
  await tester.enterText(field('Password'), 'password');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'guard can be cancelled then login opens requested form and logout updates drawer',
    (tester) async {
      await tester.pumpWidget(MyApp(apiClient: mockApi()));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();
      expect(field('Password'), findsOneWidget);
      expect(find.text('Add Project Form'), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Mohammad Adzka Aulia'), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();
      await login(tester);
      expect(find.text('Add Project Form'), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Logout'), findsOneWidget);
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    },
  );

  testWidgets(
    'login failure remains usable and does not expose server response',
    (tester) async {
      final api = ApiClient(
        client: MockClient((_) async => http.Response('SECRET', 400)),
      );
      await tester.pumpWidget(MyApp(apiClient: api));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();
      await login(tester);
      expect(find.textContaining('(400)'), findsOneWidget);
      expect(find.textContaining('SECRET'), findsNothing);
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Login'),
            )
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'list loads once, shows detail, and handles failed retry then empty refresh',
    (tester) async {
      final first = Completer<http.Response>();
      var requests = 0;
      final api = ApiClient(
        client: MockClient((_) async {
          requests++;
          if (requests == 1) return first.future;
          if (requests == 2) return http.Response('SECRET', 500);
          return http.Response('[]', 200);
        }),
      );
      await tester.pumpWidget(
        testApp(api: api, home: const ProjectListScreen()),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      first.complete(http.Response(jsonEncode([projectJson]), 200));
      await tester.pumpAndSettle();
      expect(requests, 1);
      await tester.tap(find.text('Live project'));
      await tester.pumpAndSettle();
      expect(find.text('URL Proyek: https://example.com'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(requests, 1);
      await tester.tap(find.byTooltip('Refresh'));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
      expect(find.textContaining('SECRET'), findsNothing);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('No projects found.'), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 400),
      );
      await tester.pumpAndSettle();
      expect(requests, 4);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'expired token prompts login without retrying an unsafe POST automatically',
    (tester) async {
      var creates = 0;
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/token/')) {
            return http.Response('{"token":"new-token"}', 200);
          }
          if (request.url.path.endsWith('/logout/')) {
            return http.Response('', 401);
          }
          creates++;
          return http.Response('', 401);
        }),
      );
      await tester.pumpWidget(testApp(api: api));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();
      for (final entry in {
        'Title': 'Demo',
        'Description': 'Text',
        'Tech Stack': 'Dart',
        'Project URL': 'https://example.com',
      }.entries) {
        await tester.ensureVisible(field(entry.key));
        await tester.enterText(field(entry.key), entry.value);
      }
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(field('Password'), findsOneWidget);
      await login(tester);
      expect(find.text('Add Project Form'), findsOneWidget);
      expect(creates, 1);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
