import './route.dart';

class Router {
  Map<String, Route> routes = Map();

  Route operator [](String path) {
    for (String regex in this.routes.keys) {
      RegExp regExp = new RegExp(regex);

      if (regExp.hasMatch(path)) {
        return this.routes[regex];
      }
    }

    return null;
  }

  void operator []=(String regex, Route route) {
    this.routes[regex] = route;
  }
}
