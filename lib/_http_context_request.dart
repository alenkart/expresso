import 'dart:io';
import 'dart:convert';

class HttpContextRequest {
  HttpRequest request;
  HttpContextRequest(HttpRequest request) : this.request = request;

  get uri => this.request.uri;

  get path => this.request.uri.path;

  get method => this.request.method;

  get query => this.uri.queryParameters;

  get body async {
    String content = await this.request.transform(utf8.decoder).join();
    return jsonDecode(content) as Map;
  }
}
