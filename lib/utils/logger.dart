import 'package:logger/logger.dart' as log_package;

class Logger {
  static late log_package.Logger _logger;

  static void init() {
    _logger = log_package.Logger(
      printer: log_package.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message) {
    _logger.e(message);
  }

  static void v(String message) {
    _logger.v(message);
  }
}
