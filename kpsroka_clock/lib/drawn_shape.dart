// Copyright 2020 Krzysztof Sroka. All rights reseved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'dart:ui';
import 'package:bezier/bezier.dart';
import 'package:kpsroka_clock/shapes.dart';
import 'package:flutter/material.dart' hide Gradient;
import 'package:vector_math/vector_math.dart' show Vector2;

class DrawnShape extends StatefulWidget {
  final BezierShape shape;
  final AnimationController animationController;

  const DrawnShape({Key key, this.shape, this.animationController}) : super(key: key);

  @override
  _DrawnShapeState createState() => _DrawnShapeState();
}

class _DrawnShapeState extends State<DrawnShape> with TickerProviderStateMixin {
  BezierShape _drawnShape;

  @override
  void initState() {
    super.initState();
    _drawnShape = _getDrawnShape();

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

  BezierShape _getDrawnShape() => widget.shape.disturbed(random: Random());

  @override
  void didUpdateWidget(DrawnShape oldWidget) {
    if (oldWidget.shape != widget.shape) {
      _drawnShape = _getDrawnShape();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomPaint(
            painter: _createPainter(constraints.biggest),
            willChange: widget.animationController.isAnimating,
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Container(),
            ),
          );
        },
      ),
    );
  }

  CustomPainter _createPainter(Size size) {
    return _BezierShapePainter(
      shape: _drawnShape.normalized(width: size.width, height: size.height),
      progress: widget.animationController.value,
    );
  }
}

class _BezierShapePainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4;

  final BezierShape shape;
  final double progress;

  final List<double> _lengths;
  final double _totalLength;

  _BezierShapePainter({@required this.shape, @required this.progress})
      : assert(shape != null),
        assert(progress != null && progress >= 0.0 && progress <= 1.0),
        _lengths = shape.curves.map((Bezier shape) => shape.length).toList(),
        _totalLength = shape.curves.map((Bezier shape) => shape.length).reduce((a, b) => a + b);

  @override
  void paint(Canvas canvas, Size size) {
    double lengthLimit = _totalLength * progress;
    double currentLength = 0.0;
    int nextShapeIndex = 0;
    while (currentLength < lengthLimit) {
      _drawShape(canvas, shape.curves[nextShapeIndex], lengthLimit - currentLength);
      currentLength += _lengths[nextShapeIndex];
      nextShapeIndex++;
    }
  }

  void _drawShape(Canvas canvas, Bezier shape, double remainingLength) {
    // leftSubcurveAt handles values > 1.0 well
    final Bezier cutShape = shape.leftSubcurveAt(remainingLength / shape.length);

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
      throw new UnsupportedError('Cannot draw bezier curves of order ${cutShape.order}');
    }

    shapePath.moveTo(shape.startPoint.x, shape.startPoint.y);

    canvas.drawPath(shapePath, _paint);
  }

  @override
  bool shouldRepaint(_BezierShapePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.shape != shape;
  }
}
