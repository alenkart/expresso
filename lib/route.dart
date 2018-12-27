import './http_context.dart';

class Route {
  String path;
  String method;
  Function(HttpContext) callback;

  Route(this.method, this.path, this.callback);
}