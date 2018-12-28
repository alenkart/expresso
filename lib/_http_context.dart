import 'dart:io';
import 'dart:convert';

class HttpContext {
  HttpRequest request;
  HttpResponse response;

  HttpContext(HttpRequest request) {
    this.request = request;
    this.response = request.response;
  }

  get uri => this.request.uri;

  get method => this.request.method;

  get body async {
    String content = await this.request.transform(utf8.decoder).join();
    return jsonDecode(content) as Map;
  }

  statusCode(int code) => this.response.statusCode = code;

  close() => this.response.close();

  text(String content) {
    this.response
      ..headers.set('Content-Type', 'text/plain')
      ..write(content);

    this.close();
  }

  html(String content) {
    this.response
      ..headers.set('Content-Type', 'text/html')
      ..write(content);

    this.close();
  }

  json(Map content) {
    final json = jsonEncode(content);

    this.response
      ..headers.set('Content-Type', 'application/json')
      ..write(json);

    this.close();
  }
}
