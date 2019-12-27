import 'dart:math';

import 'package:bezier/bezier.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class DrawnShape extends StatefulWidget {
  final List<Bezier> shapes;

  const DrawnShape({Key key, this.shapes}) : super(key: key);

  @override
  _DrawnShapeState createState() => _DrawnShapeState();
}

class _DrawnShapeState extends State<DrawnShape>
    with SingleTickerProviderStateMixin {
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
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _drawnShapes = widget.shapes.map(disturbBezier).toList();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _createPainter(),
      willChange: _controller.isAnimating,
    );
  }

  CustomPainter _createPainter() {
    return BezierShapePainter(
        shapes: _drawnShapes, progress: _controller.value);
  }
}

class BezierShapePainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
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
