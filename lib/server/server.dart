import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:it_book_search/config.dart';
import 'package:it_book_search/exceptions/http.dart';

class ServerResponse {
  final int statusCode;
  final dynamic data;

  ServerResponse(this.statusCode, {this.data});
}

class Server {
  static final Client _client = Client();

  static const String _server = Config.server;

  static final _singleton = Server();

  factory Server() => _singleton;

  static final Map<String, String> _globalHeaders = {
    'Accept': 'application/json; charset=UTF-8',
    'Referrer-Policy': 'origin',
    'content-type': 'application/json',
  };

  static Response _handleServerErrors(
      Response response,
      Uri uri,
      int expectedStatusCode,
      ) {
    var statusCode = response.statusCode;
    if (statusCode < 400) {
      if (statusCode == expectedStatusCode) {
        return response;
      } else {
        throw StatusCodeException(uri, statusCode, expectedStatusCode);
      }
    }
    throw HolupHttpException(uri, statusCode);
  }

  static Map<String, String> _setHeaders(
      Map<String, String>? headers, String? token) {
    var allHeaders = Map.of(_globalHeaders);
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (token != null) {
      allHeaders[HttpHeaders.authorizationHeader] = token;
    }
    return allHeaders;
  }

  static Future<Response> get(
      String endPoint,
      int expectedStatusCode, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        String? token,
      }) async {
    Uri uri = Uri.https(_server, '/1.0/$endPoint', body);
    return await _client
        .get(uri, headers: _setHeaders(headers, token))
        .then((response) {
      return _handleServerErrors(response, uri, expectedStatusCode);
    }).timeout(const Duration(seconds: Config.timeout));
  }

  static Future<Response> post(
      String endPoint,
      int expectedStatusCode, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        String? token,
      }) async {
    Uri uri = Uri.https(_server, '/1.0/$endPoint');
    return await _client
        .post(uri,
        headers: _setHeaders(headers, token),
        body: body == null ? '' : jsonEncode(body))
        .then((response) {
      return _handleServerErrors(response, uri, expectedStatusCode);
    }).timeout(const Duration(seconds: Config.timeout));
  }
}
