import 'dart:async';

import 'package:gust_template/controllers/static.controller.dart';
import 'package:gust_template/core/env.dart';
import 'package:gust_template/core/r.dart';
import 'package:gust_template/routes.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<void> main(List<String> args) async {
  Env.i().env = args.isNotEmpty ? args.first : 'PROD';
  final env = Env.i().env;

  final app = getRouter();

  var pipeline = const Pipeline();
  if (env == 'DEV') {
    pipeline = pipeline.addMiddleware(logRequests());
    await HotReloader.create(debounceInterval: Duration.zero);
  }

  final router = pipeline
      .addMiddleware(createMiddleware(requestHandler: staticMiddleware))
      .addMiddleware(createMiddleware(requestHandler: addSlashMiddleware))
      .addHandler(app);

  final domain = getDomain(env);
  await io.serve(router, domain, Env.i().port);
  print('Server running on $domain:${Env.i().port}');
}

String getDomain(String env) {
  switch (env) {
    case 'DEV':
      return Env.i().dev;
    case 'PROD':
      return Env.i().prod;
    default:
      throw Exception('Invalid environment. Expected DEV or PROD (default is PROD)');
  }
}

FutureOr<Response?> staticMiddleware(Request request) {
  if (request.url.toString().startsWith(Env.i().staticUrl)) {
    return StaticController().index(request);
  }
}

FutureOr<Response?> addSlashMiddleware(Request request) {
  final url = request.url.toString();
  if (url.isNotEmpty && !url.endsWith('/')) {
    return R.redirect('/${url.substring(0, url.length)}/');
  }
}
