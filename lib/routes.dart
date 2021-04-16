import 'package:gust_template/controllers/home.controller.dart';
import 'package:shelf_router/shelf_router.dart';

final _app = Router();

Router getRouter() {
  _initRouter();
  return _app;
}

void _initRouter() {
  _app.get('/', HomeController().index);
}
