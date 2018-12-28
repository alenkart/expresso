import './http_context.dart';

class Route {
  String path;
  RegExp regex;
  String method;
  List<Function(HttpContext)> middlewares;
  Function(HttpContext) handler;

  Route({this.path, String method, this.middlewares, this.handler}) {
    this.regex = RegExp(this.path);
    if (method != null) {
      this.method = method.toUpperCase();
    } 
  }
}
