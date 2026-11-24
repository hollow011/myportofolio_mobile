import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

const sample = Project(
  title: 'Portfolio',
  description: 'Demo',
  techStack: 'Flutter',
  projectUrl: 'https://example.com',
);

void main() {
  test('JSON uses API keys, omits id, and defaults missing or null image', () {
    for (final json in [
      sample.toJson()..remove('project_image_url'),
      {...sample.toJson(), 'project_image_url': null},
    ]) {
      expect(Project.fromJson(json).projectImageUrl, '');
    }
    final model = Project.fromJson({...sample.toJson(), 'id': 'uuid'});
    expect(model.id, 'uuid');
    expect(model.toJson().containsKey('id'), isFalse);
    expect(model.toJson()['tech_stack'], 'Flutter');
  });

  test(
    'public GET, token login, authenticated POST and logout use the contract',
    () async {
      final requests = <http.Request>[];
      final api = ApiClient(
        client: MockClient((request) async {
          requests.add(request);
          if (request.url.path.endsWith('/token/')) {
            return http.Response('{"token":"test-token"}', 200);
          }
          if (request.url.path.endsWith('/logout/')) {
            return http.Response('', 204);
          }
          return http.Response(
            jsonEncode(
              request.method == 'GET'
                  ? [sample.toJson()]
                  : {...sample.toJson(), 'id': 'uuid'},
            ),
            request.method == 'GET' ? 200 : 201,
          );
        }),
      );
      expect((await api.getProjects()).single.title, 'Portfolio');
      expect(requests.first.headers.containsKey('authorization'), isFalse);
      expect(await api.obtainToken('owner', 'secret'), 'test-token');
      expect(jsonDecode(requests.last.body), {
        'username': 'owner',
        'password': 'secret',
      });
      final saved = await api.createProject(sample, token: 'test-token');
      expect(saved.id, 'uuid');
      expect(requests.last.headers['authorization'], 'Token test-token');
      expect(jsonDecode(requests.last.body), sample.toJson());
      await api.logout(token: 'test-token');
      expect(requests.last.method, 'POST');
      expect(requests.last.url.path, '/api/v1/auth/logout/');
    },
  );

  test(
    'HTTP and network failures are safe errors, and logout always clears state',
    () async {
      for (final status in [400, 401, 403, 500]) {
        final api = ApiClient(
          client: MockClient(
            (_) async => http.Response('SECRET STACK TRACE', status),
          ),
        );
        await expectLater(
          api.getProjects(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', status),
          ),
        );
        expect(ApiException(status).message, isNot(contains('SECRET')));
        final auth = AuthState(api, initialToken: 'token');
        var notifications = 0;
        auth.addListener(() => notifications++);
        await expectLater(auth.logout(), throwsA(isA<ApiException>()));
        expect(auth.isLoggedIn, isFalse);
        expect(notifications, 1);
        auth.dispose();
      }
      final api = ApiClient(
        client: MockClient((_) async => throw http.ClientException('offline')),
      );
      final auth = AuthState(api, initialToken: 'token');
      await expectLater(
        auth.logout(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 0)),
      );
      expect(auth.token, isNull);
      auth.dispose();
    },
  );
}
