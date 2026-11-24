import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode);
  final int statusCode;

  String get message => switch (statusCode) {
    0 => 'Tidak dapat menghubungi server. Periksa koneksi dan coba lagi.',
    400 => 'Data atau kredensial tidak valid (400). Periksa isian Anda.',
    401 => 'Sesi tidak valid (401). Silakan login kembali.',
    403 =>
      'Akses ditolak (403). Hanya pemilik portofolio dapat menambah proyek.',
    _ => 'Permintaan gagal ($statusCode). Silakan coba lagi.',
  };

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();
  final http.Client _client;
  final String baseUrl;

  Future<http.Response> _request(
    String path, {
    Map<String, dynamic>? body,
    String? token,
    bool post = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = {
      'Accept': 'application/json',
      if (post) 'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Token $token',
    };
    try {
      final response =
          await (post
                  ? _client.post(
                      uri,
                      headers: headers,
                      body: body == null ? null : jsonEncode(body),
                    )
                  : _client.get(uri, headers: headers))
              .timeout(const Duration(seconds: 20));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(response.statusCode);
      }
      return response;
    } on http.ClientException {
      throw const ApiException(0);
    } on TimeoutException {
      throw const ApiException(0);
    }
  }

  Future<List<Project>> getProjects() async {
    final response = await _request('/api/v1/projects/');
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>)
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _request(
      '/api/v1/projects/',
      post: true,
      token: token,
      body: project.toJson(),
    );
    if (response.statusCode != 201) throw ApiException(response.statusCode);
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _request(
      '/api/v1/auth/token/',
      post: true,
      body: {'username': username, 'password': password},
    );
    final token = (jsonDecode(response.body) as Map<String, dynamic>)['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Missing token');
    }
    return token;
  }

  Future<void> logout({required String token}) async {
    await _request('/api/v1/auth/logout/', post: true, token: token);
  }

  void close() => _client.close();
}
