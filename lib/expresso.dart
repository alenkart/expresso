import 'dart:io';
import './route.dart';
import './http_context.dart';

class Expresso {
  //params
  int _port;
  String _host;
  HttpServer _server;
  Map<String, Route> _routes = Map();

  _handleRequest(HttpRequest request) async {
    final httpResponse = request.response;

    try {
      final ctx = HttpContext(request);
      Route route = this._routes[request.uri.path];

      if (route != null && request.method == route.method) {
        route.callback(ctx);
      } else {
        httpResponse.write('404 page not found');
      }
    } catch (e) {
      httpResponse.write(e);
    } 

    print('Request handled. ${request.uri.path}');
  }

  use(
      {String method = '',
      String path = '',
      Function(HttpContext ctx) callback}) {
    this._routes[path] = Route(method, path, callback);
  }

  get({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'GET', path: path, callback: callback);

  post({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'POST', path: path, callback: callback);

  listen({host = '127.0.0.1', int port = 4040, Function callback}) async {
    if (this._server != null) {
      return;
    }

    this._port = port;
    this._host = host;
    this._server = await HttpServer.bind(host, port);

    callback();

    await for (HttpRequest request in this._server) {
      this._handleRequest(request);
    }
  }
}
