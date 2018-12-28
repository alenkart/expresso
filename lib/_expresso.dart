import 'dart:io';
import './expresso.dart';

class Expresso {
  //params
  int _port;
  String _host;
  HttpServer _server;
  final Router _router = Router();

  _handleRequest(HttpRequest request) async {
    final ctx = HttpContext(request);

    try {
      final route = this._router.get(ctx.uri.path);

      if (route != null &&
          (route.method == null || route.method == ctx.method)) {
        if (route.middlewares != null) {
          route.middlewares.forEach((middleware) => middleware(ctx));
        }

        route.handler(ctx);
      } else {
        ctx.text('404 page not found');
      }
    } catch (e) {
      print(e);
      ctx.text('500 Internal server error');
    }
  }

  /*
    Http methods
  */

  route(Route route) => this._router.add(route);

  get({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'GET',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  post({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'POST',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  put({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'PUT',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  delete({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'DELETE',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  patch({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'PATCH',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  head({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'HEAD',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

  options({
    String path,
    List<Function(HttpContext ctx)> middlewares,
    Function(HttpContext ctx) handler,
  }) {
    this.route(
      Route(
        method: 'OPTIONS',
        path: path,
        middlewares: middlewares,
        handler: handler,
      ),
    );
  }

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
