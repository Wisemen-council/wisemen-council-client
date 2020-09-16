abstract class Requester<O> {
  Future<dynamic> get(String url, [O options]);

  Future<dynamic> post(String url, Map<String, dynamic> body, [O options]);

  Future<dynamic> put(String url, Map<String, dynamic> body, [O options]);

  Future<dynamic> delete(String url, [O options]);
}



