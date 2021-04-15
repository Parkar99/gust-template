import 'dart:async';

import 'package:gust_template/controllers/static.controller.dart';
import 'package:gust_template/core/env.dart';
import 'package:gust_template/core/r.dart';
import 'package:gust_template/core/view_reader.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'routes.dart';

const _argErrorMessage = 'Expected DEV or PROD as argument';

Future<void> main(List<String> args) async {
  if (args.isEmpty) throw ArgumentError(_argErrorMessage);
  Env.i().env = args.first;
  final env = Env.i().env;

  await initPartials();
  final app = getRouter();

  var pipeline = const Pipeline();
  if (env == 'DEV') {
    pipeline = pipeline.addMiddleware(logRequests());
  }
  final router = pipeline
      .addMiddleware(createMiddleware(requestHandler: staticMiddleware))
      .addMiddleware(createMiddleware(requestHandler: removeSlash))
      .addHandler(app);

  final domain = getDomain(env);
  io.serve(router, domain, Env.i().port);
  print('Server running on $domain:${Env.i().port}');
}

String getDomain(String env) {
  switch (env) {
    case 'DEV':
      return Env.i().dev;
    case 'PROD':
      return Env.i().prod;
    default:
      throw Exception(_argErrorMessage);
  }
}

FutureOr<Response?> staticMiddleware(Request request) {
  if (request.url.toString().startsWith(Env.i().staticUrl)) {
    return StaticController().index(request);
  }
}

FutureOr<Response?> removeSlash(Request request) {
  final url = request.url.toString();
  if (url.endsWith('/')) {
    return R.redirect('/${url.substring(0, url.length - 1)}');
  }
}
