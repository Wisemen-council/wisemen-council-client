import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:wisemen_council/core/requester/http_request_options.dart';
import 'package:wisemen_council/core/requester/http_requester.dart';

void main() {
  group('get', () {
    final url = 'my/url';
    final response = { 'id': 1, 'attr': 'val' };
    final headers = <String, String>{ 'user-agent': 'GoogleBot' };

    test('sends http GET request with URL and headers', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      await requester.get(url, HttpRequestOptions(headers: headers));

      Request request = verify(client.send(captureThat(isA<BaseRequest>()))).captured.first;
      expect(request.url, Uri.parse(url));
      expect(request.method, 'GET');
      expect(request.headers, headers);
    });

    test('sends http GET request and returns decoded response', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      final actual = await requester.get(url, HttpRequestOptions(headers: headers));

      expect(actual, response);
    });
  });

  group('delete', () {
    final url = 'my/url';
    final response = { 'id': 1, 'attr': 'val' };
    final headers = <String, String>{ 'user-agent': 'GoogleBot' };

    test('sends http DELETE request with URL and headers', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      await requester.delete(url, HttpRequestOptions(headers: headers));

      Request request = verify(client.send(captureThat(isA<BaseRequest>()))).captured.first;
      expect(request.url, Uri.parse(url));
      expect(request.method, 'DELETE');
      expect(request.headers, headers);
    });

    test('sends http DELETE request and returns decoded response', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      final actual = await requester.delete(url, HttpRequestOptions(headers: headers));

      expect(actual, response);
    });
  });

  group('post', () {
    final url = 'my/url';
    final response = { 'id': 1, 'attr': 'val' };
    final headers = <String, String>{ 'user-agent': 'GoogleBot' };
    final body = <String, dynamic>{ 'username': 'jondoe', 'password': 'password' };

    test('sends http POST request with URL and headers', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      await requester.post(url, body, HttpRequestOptions(headers: headers));

      Request request = verify(client.send(captureThat(isA<BaseRequest>()))).captured.first;
      expect(request.url, Uri.parse(url));
      expect(request.method, 'POST');
      expect(request.body, jsonEncode(body));

      final expectedHeaders = <String, String>{ 'content-type': 'application/json; charset=utf-8' };
      expectedHeaders.addAll(headers);
      expect(request.headers, expectedHeaders);
    });

    test('sends http POST request and returns decoded response', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      final actual = await requester.post(url, body, HttpRequestOptions(headers: headers));

      expect(actual, response);
    });
  });

  group('put', () {
    final url = 'my/url';
    final response = { 'id': 1, 'attr': 'val' };
    final headers = <String, String>{ 'user-agent': 'GoogleBot' };
    final body = <String, dynamic>{ 'username': 'jondoe', 'password': 'password' };

    test('sends http POST request with URL and headers', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      await requester.put(url, body, HttpRequestOptions(headers: headers));

      Request request = verify(client.send(captureThat(isA<BaseRequest>()))).captured.first;
      expect(request.url, Uri.parse(url));
      expect(request.method, 'PUT');
      expect(request.body, jsonEncode(body));

      final expectedHeaders = <String, String>{ 'content-type': 'application/json; charset=utf-8' };
      expectedHeaders.addAll(headers);
      expect(request.headers, expectedHeaders);
    });

    test('sends http POST request and returns decoded response', () async {
      final client = createClient(response);

      final requester = HttpRequester(client);

      final actual = await requester.put(url, body, HttpRequestOptions(headers: headers));

      expect(actual, response);
    });
  });
}

class MockHttpClient extends Mock implements Client {}
class MockStream extends Mock implements ByteStream {}

MockHttpClient createClient(Object response) {
  final client = MockHttpClient();
  final responseStr = jsonEncode(response);

  final stream = MockStream();
  when(stream.bytesToString()).thenAnswer((_) => Future.value(responseStr));

  final streamResponse = StreamedResponse(stream, 200);
  when(client.send(any)).thenAnswer((_) => Future.value(streamResponse));

  return client;
}
