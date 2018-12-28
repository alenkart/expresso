import './lib/main.dart';

void main() {
  final port = 4040;
  final app = Expresso();

  app.route(
    Route(
      path: '/route\$',
      middlewares: [(ctx) => print('middelware: ${ctx.uri.queryParameters}')],
      handler: (ctx) => ctx.text(ctx.uri.path),
    ),
  );

  app.get(
    path: '/text\$',
    handler: (ctx) => ctx.text('${ctx.uri.path} ${ctx.uri.queryParameters}'),
  );

  app.get(
    path: '/text/[0-9]*\$',
    handler: (ctx) => ctx.text(ctx.uri.path),
  );

  app.get(
    path: '/html\$',
    handler: (ctx) => ctx.html('<h1>html</h1>'),
  );

  app.get(
    path: '/json\$',
    handler: (ctx) => ctx.json({'key': 'value'}),
  );

  app.post(
    path: '/post',
    handler: (ctx) async {
      ctx
        ..statusCode(500)
        ..json(await ctx.body);
    },
  );

  app.listen(
    port: 4040,
    callback: () => print('Server listeting on port $port'),
  );
}
