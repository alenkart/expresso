import './expresso.dart';

class Route {
  String path;
  RegExp regex;
  String method;
  List<Function(HttpContext)> middlewares;
  Function(HttpContext) handler;
  Function(HttpContext, dynamic exception) error;

  Route({
    this.path,
    String method,
    this.middlewares,
    this.handler,
    this.error,
  }) {
    this.regex = RegExp(this.path);
    if (method != null) {
      this.method = method.toUpperCase();
    }
  }

  _autoCloseRespnse(ctx, content) {
    if (content != null) {
      ctx.response
        ..write(content)
        ..close();
    }
  }

  execute(HttpContext ctx) {
    try {
      if (this.middlewares != null) {
        for (final middleware in this.middlewares) {
          middleware(ctx);
        }
      }

      if (this.handler != null) {
        final result = this.handler(ctx);
        this._autoCloseRespnse(ctx, result);
      }
    } catch (error) {
      if (this.error != null) {
        final content = this.error(ctx, error);
        this._autoCloseRespnse(ctx, content);
      } else {
        throw error;
      }
    }
  }
}
