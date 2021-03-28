import 'dart:io';

import 'package:path/path.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

import '../core/env.dart';
import '../core/r.dart';

class StaticController {
  Future<Response> index(Request request) async {
    final fileName = request.url.toString().replaceFirst(Env.i().staticUrl, '');
    final path = join(current, 'bin', Env.i().staticDir) + fileName;

    if (!File(path).existsSync()) return R.text(null, statusCode: 404);

    return createFileHandler(path, url: request.url.toString())(request);
  }
}
