import 'dart:io';
import 'dart:convert';

class HttpContext {
  Uri uri;
  HttpRequest _request;
  HttpResponse _response;

  HttpContext(HttpRequest request) {
    this._request = request;
    this._response = request.response;
    this.uri = this._request.uri;
  }

  get body async {
    String content = await this._request.transform(utf8.decoder).join();
    return jsonDecode(content) as Map;
  }

  statusCode(int code) {
    this._response.statusCode = code;
  }

  text(String content) {
    this._response
      ..headers.set('Content-Type', 'text/plain')
      ..write(content)
      ..close();
  }

  html(String content) {
    this._response
      ..headers.set('Content-Type', 'text/html')
      ..write(content)
      ..close();
  }

  json(Map content) {
    this._response
      ..headers.set('Content-Type', 'application/json')
      ..write(content)
      ..close();
  }
}