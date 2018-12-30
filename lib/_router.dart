import 'dart:io';
import './expresso.dart';

class Router {
  List<Route> routes = [];

  void add(Route route) => this.routes.add(route);

  Route get(String path) {
    for (Route route in this.routes) {
      if (route.regex.hasMatch(path)) {
        return route;
      }
    }

    return null;
  }

  handle(HttpRequest request) async {
    final ctx = HttpContext(request);

    try {
      final route = this.get(ctx.request.path);

      if (route != null &&
          (route.method == null || route.method == ctx.request.method)) {
        if (route.middlewares != null) {
          route.middlewares.forEach((middleware) => middleware(ctx));
        }

        route.handler(ctx);
      } else {
        ctx.response.text('404 page not found');
      }
    } catch (e) {
      print(e);
      ctx.response.text('500 Internal server error');
    }
  }
}
