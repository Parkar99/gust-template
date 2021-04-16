import 'dart:io';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;

import 'env.dart';

String read(String path, {bool partial = false, bool staticFiles = false}) {
  File f;

  if (staticFiles) {
    f = File(p.join(p.current, Env.i().staticDir) + path);
  } else {
    f = File(p.join(p.current, Env.i().viewsDir, '$path.${partial ? 'partial' : 'view'}.mustache'));
  }
  return f.readAsStringSync();
}

String render(String path, {Map<String, dynamic>? data}) {
  return Template(read(path), partialResolver: _resolvePartials).renderString(data);
}

Template? _resolvePartials(String name) {
  return Template(read('${Env.i().partialsDir}/$name', partial: true), name: name);
}
