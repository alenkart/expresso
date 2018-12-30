import 'dart:io';
import 'dart:convert';

class HttpContextResponse {
  HttpResponse response;
  HttpContextResponse(HttpRequest request) : this.response = request.response;

  addHeader(String key, String value) => this.response.headers.add(key, value);

  set statusCode(int code) => this.response.statusCode = code;

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

  file(path) async {
    final File file = File(path);
    if (await file.exists()) {
      await file.openRead().pipe(this.response);
      this.close();
    } else {
      throw new Exception('File doesn\'t exits');
    }
  }
}
