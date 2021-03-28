import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'controllers/static.controller.dart';
import 'core/env.dart';
import 'core/view_reader.dart';
import 'routes.dart';

const _argErrorMessage = 'Expected DEV or PROD as argument';

Future<void> main(List<String> args) async {
  if (args.isEmpty) throw Exception(_argErrorMessage);
  Env.i().env = args.first;
  final env = Env.i().env;

  await initPartials();
  final app = getRouter();

  final router = const Pipeline().addMiddleware(logRequests()).addMiddleware(createMiddleware(
    requestHandler: (request) {
      if (request.url.toString().startsWith(Env.i().staticUrl)) {
        return StaticController().index(request);
      }
    },
  )).addHandler(app);

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
