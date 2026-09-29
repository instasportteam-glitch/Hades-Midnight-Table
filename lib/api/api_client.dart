import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'app_config.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  /// Получить ссылку, которую нужно открыть в WebView.
  @GET('/config')
  Future<AppConfig> getConfig();

  /// Удобный конструктор с настроенным Dio.
  static ApiClient create(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 7),
        receiveTimeout: const Duration(seconds: 7),
        headers: {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: true));
    return ApiClient(dio, baseUrl: baseUrl);
  }
}
