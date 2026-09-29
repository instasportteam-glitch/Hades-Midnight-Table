/// Ответ эндпоинта GET /config, например: {"url": "https://site.com"}
class AppConfig {
  const AppConfig({this.url});

  final String? url;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      AppConfig(url: json['url'] as String?);

  Map<String, dynamic> toJson() => {'url': url};
}
