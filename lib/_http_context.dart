import 'dart:io';
import 'dart:convert';

class HttpContext {
  HttpRequest request;
  HttpResponse response;

  HttpContext(this.request) : this.response = request.response;

  get uri => this.request.uri;

  get path => this.request.uri.path;

  get method => this.request.method;

  get query => this.request.uri.queryParameters;

  get statusCode => this.response.statusCode;

  get body async {
    String content = await this.request.transform(utf8.decoder).join();
    return jsonDecode(content) as Map;
  }

  close() => this.response.close();

  write(content) => this.response.write(content);

  text(String content) {
    this.response
      ..headers.set(HttpHeaders.contentTypeHeader, 'text/plain')
      ..write(content);

    this.close();
  }

  html(String content) {
    this.response
      ..headers.set(HttpHeaders.contentTypeHeader, 'text/html')
      ..write(content);

    this.close();
  }

  json(Map content) {
    final json = jsonEncode(content);

    this.response
      ..headers.set(HttpHeaders.contentTypeHeader, 'application/json')
      ..write(json);

    this.close();
  }

  file(path) async {
    final File file = File(path);
    if (await file.exists()) {
      await file.openRead().pipe(this.response);
      this.close();
    } else {
      throw new Exception("File doesn't exits");
    }
  }
}
