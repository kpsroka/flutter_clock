import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide Gradient;

class Sponge extends StatefulWidget {
  final AnimationController animationController;

  const Sponge({Key key, this.animationController}) : super(key: key);

  @override
  _SpongeState createState() => _SpongeState();
}

class _SpongeState extends State<Sponge> {
  @override
  void initState() {
    super.initState();
    widget.animationController.addListener(_setStateCallback);
  }

  @override
  void dispose() {
    widget.animationController.removeListener(_setStateCallback);
    super.dispose();
  }

  void _setStateCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) => RepaintBoundary(
          child: CustomPaint(
            painter: _SpongePainter(progress: widget.animationController.value),
            willChange: widget.animationController.isAnimating,
            child: SizedBox(
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpongePainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 32
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt;

  final double progress;

  _SpongePainter({this.progress}) : assert(progress != null && progress >= 0.0 && progress <= 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final int totalStrokes = (size.width ~/ _paint.strokeWidth) + 1;

    for (int currentStroke = 1; currentStroke <= totalStrokes; currentStroke++) {
      double progressRatio = (progress * (totalStrokes + 1) - currentStroke + 1);
      if (progressRatio <= 0.0) {
        return;
      }

      double sweepRatio = min(1.0, progressRatio);

      Rect strokeRect = Rect.fromLTRB(
        size.width - (currentStroke * _paint.strokeWidth),
        size.height / 2 - 500,
        2 * (500 + size.width) - (currentStroke * _paint.strokeWidth),
        size.height / 2 + 500,
      );

      double strokeSweepAngle = asin((size.height) / (500 + _paint.strokeWidth)) * 1.5;
      double strokeStartAngle = pi - strokeSweepAngle / 2;

      Shader strokeShader = _getGradient(
          progressRatio, strokeStartAngle, pi + strokeSweepAngle * sweepRatio, strokeRect.center);

      _paint.shader = strokeShader;

      canvas.drawArc(
        strokeRect,
        strokeStartAngle,
        strokeSweepAngle * sweepRatio,
        /* useCenter */ false,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SpongePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  Shader _getGradient(double progressRatio, double startAngle, double endAngle, Offset center) {
    if (progressRatio >= 2.0) {
      return null;
    }

    Color startColor = Colors.white;
    Color endColor = Color.lerp(Colors.black, Colors.white, max(0.0, progressRatio - 1.0));
    final List<Color> gradient = [startColor, startColor, endColor];

    return Gradient.sweep(
      center,
      gradient,
      [0, max(0.5, progressRatio - 1.0), 1.0],
      TileMode.clamp,
      startAngle,
      lerpDouble(startAngle, endAngle, max(0.1, progressRatio / 2)),
    );
  }
}
