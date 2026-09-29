// GENERATED CODE - DO NOT MODIFY BY HAND
// Сгенерировано по аннотациям Retrofit. Перегенерировать:
//   dart run build_runner build -d

part of 'api_client.dart';

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AppConfig> getConfig() async {
    final options = Options(method: 'GET')
        .compose(_dio.options, '/config')
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl);
    final result = await _dio.fetch<Map<String, dynamic>>(options);
    return AppConfig.fromJson(result.data!);
  }
}
