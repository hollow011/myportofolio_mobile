import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

ApiClient mockApi() => ApiClient(
  client: MockClient((request) async {
    if (request.url.path.endsWith('/token/')) {
      return http.Response('{"token":"test-token"}', 200);
    }
    if (request.url.path.endsWith('/logout/')) return http.Response('', 204);
    if (request.method == 'GET') return http.Response('[]', 200);
    return http.Response(
      jsonEncode({
        ...jsonDecode(request.body) as Map<String, dynamic>,
        'id': 'uuid',
      }),
      201,
    );
  }),
);

Widget testApp({ApiClient? api, bool loggedIn = true, Widget? home}) {
  final client = api ?? mockApi();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: client),
      ChangeNotifierProvider(
        create: (_) =>
            AuthState(client, initialToken: loggedIn ? 'test-token' : null),
      ),
    ],
    child: MaterialApp(home: home ?? MyHomePage()),
  );
}
