import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../api/api_client.dart';
import '../config.dart';
import '../widgets/fire_loader.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final ApiClient _api = ApiClient.create(AppConstants.apiBaseUrl);

  InAppWebViewController? _web;
  String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _resolveUrl();
  }

  /// Через Retrofit получаем ссылку; при ошибке — fallbackUrl.
  Future<void> _resolveUrl() async {
    String url = AppConstants.fallbackUrl;
    try {
      final config = await _api.getConfig();
      if (config.url != null && config.url!.isNotEmpty) url = config.url!;
    } catch (e) {
      debugPrint('API error, using fallback: $e');
    }
    if (mounted) setState(() => _url = url);
  }

  void _hideLoader() {
    if (_loading && mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_web != null && await _web!.canGoBack()) {
          await _web!.goBack();
        } else if (context.mounted) {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              if (_url != null)
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(_url!)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                    allowsBackForwardNavigationGestures: true,
                    transparentBackground: true,
                  ),
                  onWebViewCreated: (c) => _web = c,
                  onProgressChanged: (_, p) {
                    if (p >= 100) _hideLoader();
                  },
                  onLoadStop: (_, _) => _hideLoader(),
                  onReceivedError: (_, req, err) {
                    if (req.isForMainFrame ?? true) _hideLoader();
                  },
                ),
              IgnorePointer(
                ignoring: !_loading,
                child: AnimatedOpacity(
                  opacity: _loading ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: const ColoredBox(
                    color: Colors.black,
                    child: Center(child: FireLoader(size: 110)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
