import 'dart:io';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;

import 'env.dart';

late final List<String> _partials;
final _parsedPartials = <String, String>{};

Future<String> read(String path, {bool partial = false, bool staticFiles = false}) async {
  File f;

  if (staticFiles) {
    f = File(p.join(p.current, 'bin', Env.i().staticDir) + path);
  } else {
    f = File(p.join(p.current, 'bin', Env.i().viewsDir, '$path.${partial ? 'partial' : 'view'}.html'));
  }
  return f.readAsString();
}

Future<String> render(String path, {Map<String, dynamic>? data}) async {
  return Template(await read(path), partialResolver: _resolvePartials).renderString(data);
}

Future<void> initPartials() async {
  _partials = await _getPartials();
  for (final partial in _partials) {
    _parsedPartials[partial] = await read('${Env.i().partialsDir}/$partial', partial: true);
  }
}

Template? _resolvePartials(String name) {
  if (_partials.contains(name)) return Template(_parsedPartials[name] ?? name, name: name);
}

Future<List<String>> _getPartials() async {
  final dir = Directory(p.join(p.current, 'bin', Env.i().viewsDir, Env.i().partialsDir));
  if (!dir.existsSync()) return [];

  final partials = <String>[];
  await for (final file in dir.list()) {
    partials.add(p.basename(file.path.replaceFirst('.partial.html', '')));
  }
  return partials;
}
