import 'package:shelf/shelf.dart';

import '../core/r.dart';
import '../core/view_reader.dart';

class HomeController {
  Future<Response> index(Request request) async {
    return R.html(await render('home', data: {'message': 'Hello Gust'}));
  }
}
