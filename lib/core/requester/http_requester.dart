import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wisemen_council/core/requester/http_request_options.dart';
import 'package:wisemen_council/core/requester/requester.dart';

class HttpRequester implements Requester<HttpRequestOptions> {
  final http.Client _httpClient;

  HttpRequester(this._httpClient);

  @override
  Future<dynamic> delete(String url, [HttpRequestOptions options]) {
    final request = _createRequest("DELETE", url, options: options);
    return _send(request);
  }

  @override
  Future<dynamic> get(String url, [HttpRequestOptions options]) async {
    final request = _createRequest("GET", url, options: options);
    return _send(request);
  }

  @override
  Future<dynamic> post(String url, Map<String, dynamic> body, [HttpRequestOptions options]) {
    final request = _createRequest("POST", url, options: options, body: body);
    return _send(request);
  }

  @override
  Future<dynamic> put(String url, Map<String, dynamic> body, [HttpRequestOptions options]) {
    final request = _createRequest("PUT", url, options: options, body: body);
    return _send(request);
  }

  http.BaseRequest _createRequest(String method, String url, { Map<String, dynamic> body, HttpRequestOptions options }) {
    final uri = Uri.parse(url);
    final headers = options == null || options.headers == null
        ? <String, String>{}
        : options.headers;

    final request = http.Request(method, uri);
    request.headers.clear();
    request.headers.addAll(headers);

    if (body != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    return request;
  }

  dynamic _send(http.BaseRequest request) async {
    final response = await _httpClient.send(request);
    final jsonString = await response.stream.bytesToString();

    return jsonDecode(jsonString);
  }
}
