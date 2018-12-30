# Expresso ☕
A dart server-side framework

## Example

```dart
import 'dart:io';
import '../lib/expresso.dart';

void main() {
  final port = 4040;
  final app = Expresso(port: port);

  app.route(
    Route(
      path: r'^\/$',
      middlewares: [
        (ctx) => print('middelware ${DateTime.now()}'),
        (ctx) => print('middelware ${DateTime.now()}'),
      ],
      handler: (ctx) => throw Exception('Example'),
      error: (ctx, error) {
        ctx.response.statusCode = 500;
        ctx.response.headers.add(HttpHeaders.contentTypeHeader, 'text/html');
        return '<h1>Error handler</h1>';
      },
    ),
  );

  app.get(
    path: r'\/(index)$',
    handler: (ctx) {
      ctx.response.headers.add(HttpHeaders.contentTypeHeader, 'text/html');
      ctx.file('./index.html');
    },
  );

  app.get(
    path: r'\/(json)$',
    handler: (ctx) => ctx.json({'key': 'value'}),
  );

  app.post(
    path: r'\/(post)$',
    handler: (ctx) async {
      ctx.response.statusCode = 500;
      ctx.json(await ctx.body);
    },
  );

  app.listen(
    callback: () => print('Server listening on port $port'),
  );
}
```
