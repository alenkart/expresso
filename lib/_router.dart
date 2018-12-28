import './expresso.dart';

class Router {
  List<Route> routes = [];

  Route get(String path) {
    for (Route route in this.routes) {

      if (route.regex.hasMatch(path)) {
        return route;
      }
    }

    return null;
  }

  void add(Route route) => this.routes.add(route);
}
