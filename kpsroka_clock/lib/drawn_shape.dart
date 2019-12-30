import 'dart:math';

import 'dart:ui';
import 'package:bezier/bezier.dart';
import 'package:flutter/material.dart' hide Gradient;
import 'package:vector_math/vector_math.dart' show Vector2;

class DrawnShape extends StatefulWidget {
  final List<Bezier> shapes;

  const DrawnShape({Key key, this.shapes}) : super(key: key);

  @override
  _DrawnShapeState createState() => _DrawnShapeState();
}

class _DrawnShapeState extends State<DrawnShape> with TickerProviderStateMixin {
  static Bezier disturbBezier(Bezier shape) {
    Random random = Random();

    return Bezier.fromPoints(shape.points.map((Vector2 point) {
      if (point == shape.startPoint || point == shape.endPoint) {
        return point;
      } else {
        final double deltaX = (random.nextDouble() - 0.5) * 12;
        final double deltaY = (random.nextDouble() - 0.5) * 12;

        return point + Vector2(deltaX, deltaY);
      }
    }).toList());
  }

  List<Bezier> _drawnShapes;
  AnimationController _shapePaintController;
  AnimationController _clearPaintController;

  @override
  void initState() {
    super.initState();

    _drawnShapes = widget.shapes.map(disturbBezier).toList();

    _shapePaintController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _clearPaintController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    _shapePaintController.addListener(() {
      setState(() {});
    });
    _clearPaintController.addListener(() {
      setState(() {});
    });
    _shapePaintController.forward();
  }

  @override
  void dispose() {
    _shapePaintController.dispose();
    _clearPaintController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DrawnShape oldWidget) {
    if (oldWidget.shapes != widget.shapes) {
      _shapePaintController.stop();
      _clearPaintController.stop();
      _clearPaintController.forward().then((void _) {
        _shapePaintController.reset();
        _clearPaintController.reset();
        _drawnShapes.clear();
        _drawnShapes.addAll(widget.shapes.map(disturbBezier));
        _shapePaintController.forward();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _createPainter(),
        foregroundPainter: _createClearPainter(),
        willChange: _shapePaintController.isAnimating ||
            _clearPaintController.isAnimating,
        child: SizedBox(
          width: 140,
          height: 200,
          child: Container(color: Colors.white70),
        ),
      ),
    );
  }

  CustomPainter _createPainter() {
    return BezierShapePainter(
        shapes: _drawnShapes, progress: _shapePaintController.value);
  }

  CustomPainter _createClearPainter() {
    return ClearPainter(progress: _clearPaintController.value);
  }
}

class BezierShapePainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4;

  final List<Bezier> shapes;
  final double progress;

  final List<double> _lengths;
  final double _totalLength;

  BezierShapePainter({@required this.shapes, @required this.progress})
      : assert(shapes != null && shapes.isNotEmpty),
        assert(progress != null && progress >= 0.0 && progress <= 1.0),
        _lengths = shapes.map((Bezier shape) => shape.length).toList(),
        _totalLength =
            shapes.map((Bezier shape) => shape.length).reduce((a, b) => a + b);

  @override
  void paint(Canvas canvas, Size size) {
    double lengthLimit = _totalLength * progress;
    double currentLength = 0.0;
    int nextShapeIndex = 0;
    while (currentLength < lengthLimit) {
      _drawShape(canvas, shapes[nextShapeIndex], lengthLimit - currentLength);
      currentLength += _lengths[nextShapeIndex];
      nextShapeIndex++;
    }
  }

  void _drawShape(Canvas canvas, Bezier shape, double remainingLength) {
    // leftSubcurveAt handles values > 1.0 well
    final Bezier cutShape =
        shape.leftSubcurveAt(remainingLength / shape.length);

    Path shapePath = Path();
    shapePath.moveTo(cutShape.startPoint.x, cutShape.startPoint.y);

    if (cutShape.order == 2) {
      List<Vector2> shapePoints = cutShape.points;
      shapePath.quadraticBezierTo(
        shapePoints[1].x,
        shapePoints[1].y,
        shapePoints.last.x,
        shapePoints.last.y,
      );
    } else if (cutShape.order == 3) {
      List<Vector2> shapePoints = cutShape.points;
      shapePath.cubicTo(
        shapePoints[1].x,
        shapePoints[1].y,
        shapePoints[2].x,
        shapePoints[2].y,
        shapePoints.last.x,
        shapePoints.last.y,
      );
    } else {
      throw new UnsupportedError(
          'Cannot draw bezier curves of order ${cutShape.order}');
    }

    shapePath.moveTo(shape.startPoint.x, shape.startPoint.y);

    canvas.drawPath(shapePath, _paint);
  }

  @override
  bool shouldRepaint(BezierShapePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.shapes != shapes;
  }
}

class ClearPainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 32
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt;

  final double progress;

  ClearPainter({this.progress})
      : assert(progress != null && progress >= 0.0 && progress <= 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int currentStroke = 1; currentStroke <= 5; currentStroke++) {
      double progressRatio = (progress * 6 - currentStroke + 1);
      if (progressRatio <= 0.0) {
        return;
      }

      double sweepRatio = min(1.0, progressRatio);

      Rect strokeRect = Rect.fromLTRB(
          size.width - (currentStroke * _paint.strokeWidth),
          size.height - (550 + size.width),
          2 * (550 + size.width),
          size.height + (550 + size.width));
      double strokeStartAngle = pi;
      double strokeSweepAngle =
          asin((size.height) / (550 + (currentStroke * _paint.strokeWidth)));

      Shader strokeShader = _getGradient(
          progressRatio, pi + strokeSweepAngle * sweepRatio, strokeRect.center);
      _paint..shader = strokeShader;

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
  bool shouldRepaint(ClearPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  Shader _getGradient(double progressRatio, double endAngle, Offset center) {
    if (progressRatio >= 2.0) {
      return null;
    }

    Color startColor = Colors.white;
    Color endColor =
        Color.lerp(Colors.black, Colors.white, max(0.0, progressRatio - 1.0));

    return Gradient.sweep(
      center,
      [startColor, startColor, endColor],
      [0, max(0.5, progressRatio - 1.0), 1.0],
      TileMode.clamp,
      /* startAngle */ pi,
      endAngle,
    );
  }
}
