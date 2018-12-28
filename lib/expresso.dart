import 'dart:io';
import './main.dart';

class Expresso {
  //params
  int _port;
  String _host;
  HttpServer _server;
  final Router router = Router();

  _handleRequest(HttpRequest request) async {
    final ctx = HttpContext(request);

    try {
      final route = this.router[request.uri.path];

      if (route != null && ctx.method == route.method) {
        route.callback(ctx);
      } else {
        ctx.text('404 page not found');
      }
    } catch (e) {
      ctx.text(e);
    }

    print('Request handled. ${request.uri.path}');
  }

  /*
    Http methods
  */
  use(
      {String method = '',
      String path = '',
      Function(HttpContext ctx) callback}) {
    this.router[path] = Route(method, path, callback);
  }

  get({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'GET', path: path, callback: callback);

  post({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'POST', path: path, callback: callback);

  put({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'PUT', path: path, callback: callback);

  delete({String path = '', Function(HttpContext ctx) callback}) =>
      this.use(method: 'DELETE', path: path, callback: callback);

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
