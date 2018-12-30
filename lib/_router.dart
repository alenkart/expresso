import 'dart:io';
import './expresso.dart';

class Router {
  List<Route> routes = [];
  Map<String, Route> errors = Map();

  void add(Route route) => this.routes.add(route);

  Route getRoute(String path) {
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
      final route = this.getRoute(ctx.path);

      if (route != null &&
          (route.method == null || route.method == ctx.method)) {
        route.execute(ctx);
      } else {
        if (this.errors['404'] != null) {
          this.errors['404'].execute(ctx);
        } else {
          ctx.close();
        }
      }
    } catch (e) {
      print(e);
      if (this.errors['500'] != null) {
        this.errors['500'].execute(ctx);
      } else {
         ctx.close();
      }
    }
  }
}
