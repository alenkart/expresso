import './lib/expresso.dart';

void main() {
  var port = 4040;
  var app = Expresso();

  app.get(
    path: '/text',
    callback: (ctx) async {
      ctx.text('text');
    },
  );

  app.get(
    path: '/html',
    callback: (ctx) async {
      ctx.html('<h1>html</h1>');
    },
  );

  app.get(
    path: '/json',
    callback: (ctx) async {
      ctx
        ..statusCode(200)
        ..json({'key': 'value'});
    },
  );

  app.post(
    path: '/post',
    callback: (ctx) async {
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
