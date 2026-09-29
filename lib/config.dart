/// Настройки приложения — поменяй под себя.
class AppConstants {
  AppConstants._();

  /// Базовый адрес API для Retrofit.
  static const String apiBaseUrl = 'https://api.example.com';

  /// Ссылка, которая откроется, если API недоступен или не вернул url.
  static const String fallbackUrl = 'https://gamelist.hmtable.blog/';
}
