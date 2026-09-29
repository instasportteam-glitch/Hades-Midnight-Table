import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Анимированный лоадер в виде огня.
class FireLoader extends StatefulWidget {
  const FireLoader({super.key, this.size = 120});

  final double size;

  @override
  State<FireLoader> createState() => _FireLoaderState();
}

class _FireLoaderState extends State<FireLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) =>
            CustomPaint(painter: _FirePainter(_controller.value)),
      ),
    );
  }
}

class _FirePainter extends CustomPainter {
  _FirePainter(this.t);

  /// Фаза анимации 0..1
  final double t;

  static const _sparkCount = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final bottom = h * 0.95;
    final a = t * 2 * math.pi;

    // Мягкое свечение под огнём
    canvas.drawCircle(
      Offset(cx, bottom - w * 0.3),
      w * 0.55 * (0.92 + 0.08 * math.sin(a * 2)),
      Paint()
        ..color = const Color(0x55FF5500)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // Слои пламени: внешний -> внутренний
    _flame(canvas, cx, bottom, w * 0.78, h * 0.85, a, 0.0,
        const [Color(0xFFFFB300), Color(0xFFFF5722), Color(0xFFB71C1C)]);
    _flame(canvas, cx, bottom, w * 0.56, h * 0.64, a, 1.3,
        const [Color(0xFFFFF176), Color(0xFFFFA000), Color(0xFFFF6D00)]);
    _flame(canvas, cx, bottom, w * 0.32, h * 0.40, a, 2.6,
        const [Color(0xFFFFFFFF), Color(0xFFFFF59D), Color(0xFFFFCA28)]);

    // Искры
    for (var i = 0; i < _sparkCount; i++) {
      final seed = i * 12.9898;
      final p = (t * 1.3 + i / _sparkCount) % 1.0;
      final drift = math.sin(p * 7 + seed) * w * 0.22;
      final x = cx + (((seed * 7) % 1.0) - 0.5) * w * 0.4 + drift * p;
      final y = bottom - w * 0.3 - p * h * 0.85;
      final r = (1.0 - p) * (1.5 + (i % 3));
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = Color.lerp(
                  const Color(0xFFFFEB3B), const Color(0xFFFF3D00), p)!
              .withValues(alpha: (1 - p).clamp(0.0, 1.0)),
      );
    }
  }

  void _flame(Canvas canvas, double cx, double bottom, double fw, double fh,
      double a, double phase, List<Color> colors) {
    final flick = math.sin(a * 2 + phase) * 0.06 + math.sin(a * 3 + phase) * 0.03;
    final height = fh * (1 + flick);
    final sway = math.sin(a + phase) * fw * 0.18;
    final r = fw / 2;
    final top = bottom - height;
    final baseY = bottom - r;

    final path = Path()
      ..moveTo(cx + sway, top)
      ..cubicTo(
        cx + sway * 0.4 + r * 0.25, top + height * 0.25,
        cx + r * 1.05, top + height * 0.45,
        cx + r, baseY,
      )
      ..arcToPoint(Offset(cx - r, baseY),
          radius: Radius.circular(r), clockwise: true)
      ..cubicTo(
        cx - r * 1.05, top + height * 0.45,
        cx + sway * 0.4 - r * 0.25, top + height * 0.25,
        cx + sway, top,
      )
      ..close();

    final rect = Rect.fromLTWH(cx - r, top, fw, height);
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 0.7),
        radius: 0.9,
        colors: colors,
        stops: const [0.0, 0.55, 1.0],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FirePainter old) => old.t != t;
}
