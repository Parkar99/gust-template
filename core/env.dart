class Env {
  static final _instance = Env._();

  late String env;

  final int port = 3000;
  final String dev = 'localhost';
  final String prod = 'example.com';

  final String viewsDir = 'views';

  final String staticUrl = 'static';
  final String staticDir = 'public';

  final String partialsDir = 'partials';

  Env._();

  factory Env.i() => _instance;
}
