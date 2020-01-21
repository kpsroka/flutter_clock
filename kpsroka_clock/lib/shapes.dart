// Copyright 2020 Krzysztof Sroka. All rights reseved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:bezier/bezier.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

extension Aabb2Size on Aabb2 {
  double get width => this.max.x - this.min.x;
  double get height => this.max.y - this.min.y;
}

extension DisturbBezier on Bezier {
  Bezier disturbed(Random random, double scale) => Bezier.fromPoints(
        points.map(
          (Vector2 point) {
            if (point == startPoint || point == endPoint) {
              return point;
            } else {
              final double deltaX = (random.nextDouble() - 0.5) * scale;
              final double deltaY = (random.nextDouble() - 0.5) * scale;

              return point + Vector2(deltaX, deltaY);
            }
          },
        ).toList(),
      );

  Bezier offsetByX(double offset) {
    assert(offset != null);
    Vector2 offsetVector = Vector2(offset, 0);
    return Bezier.fromPoints(points.map((Vector2 point) => point + offsetVector).toList());
  }
}

class BezierShape {
  final List<Bezier> curves;

  BezierShape(this.curves)
      : assert(curves != null && curves.every((Bezier curve) => curve != null));

  Aabb2 getBoundingRect() => curves
      .map((Bezier shape) => shape.boundingBox)
      .reduce((Aabb2 a, Aabb2 b) => Aabb2.copy(a)..hull(b));

  BezierShape normalized({@required double width, @required double height}) {
    assert(width > 0 && height > 0);

    final Aabb2 boundingRect = getBoundingRect();

    final Vector2 offsetVector = boundingRect.min;
    final double scale = (boundingRect.width / boundingRect.height >= (width / height)
        ? width / boundingRect.width
        : height / boundingRect.height);
    final Vector2 centeringVector = Vector2(
          width - boundingRect.width * scale,
          height - boundingRect.height * scale,
        ) /
        2;

    return BezierShape(curves
        .map((Bezier curve) => Bezier.fromPoints(curve.points
            .map((Vector2 point) => (point - offsetVector) * scale + centeringVector)
            .toList()))
        .toList());
  }

  BezierShape disturbed({@required Random random, double scale = 12}) {
    assert(random != null);
    assert(scale > 0);

    return BezierShape(curves.map((Bezier curve) => curve.disturbed(random, scale)).toList());
  }
}

BezierShape _shapeZero = BezierShape([
  Bezier.fromPoints([Vector2(78, 30), Vector2(122, 30), Vector2(110, 160), Vector2(66, 160)]),
  Bezier.fromPoints([Vector2(66, 160), Vector2(22, 160), Vector2(34, 30), Vector2(78, 30)]),
]);

BezierShape _shapeOne = BezierShape([
  Bezier.fromPoints([Vector2(40, 80), Vector2(58, 54), Vector2(76, 38)]),
  Bezier.fromPoints([Vector2(76, 38), Vector2(76, 109), Vector2(76, 170)]),
]);

BezierShape _shapeTwo = BezierShape([
  Bezier.fromPoints([Vector2(36, 70), Vector2(36, 72), Vector2(56, 32), Vector2(76, 32)]),
  Bezier.fromPoints([Vector2(76, 32), Vector2(92, 32), Vector2(108, 46), Vector2(108, 60)]),
  Bezier.fromPoints([Vector2(108, 60), Vector2(108, 100), Vector2(60, 120), Vector2(40, 160)]),
  Bezier.fromPoints([Vector2(40, 160), Vector2(76, 160), Vector2(112, 160)]),
]);

BezierShape _shapeThree = BezierShape([
  Bezier.fromPoints([Vector2(30, 40), Vector2(65, 40), Vector2(100, 40)]),
  Bezier.fromPoints([Vector2(100, 40), Vector2(81, 60), Vector2(62, 80)]),
  Bezier.fromPoints([Vector2(62, 80), Vector2(84, 80), Vector2(105, 90), Vector2(105, 112)]),
  Bezier.fromPoints([Vector2(105, 112), Vector2(105, 164), Vector2(50, 180), Vector2(30, 132)]),
]);

BezierShape _shapeFour = BezierShape([
  Bezier.fromPoints([Vector2(80, 170), Vector2(79, 96), Vector2(78, 22)]),
  Bezier.fromPoints([Vector2(78, 22), Vector2(49, 79), Vector2(20, 116)]),
  Bezier.fromPoints([Vector2(20, 116), Vector2(76, 112), Vector2(116, 108)]),
]);

BezierShape _shapeFive = BezierShape([
  Bezier.fromPoints(
    [Vector2(120, 30), Vector2(80, 35), Vector2(40, 40)],
  ),
  Bezier.fromPoints(
    [Vector2(40, 40), Vector2(35, 75), Vector2(30, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(30, 110), Vector2(70, 90), Vector2(110, 85), Vector2(110, 130)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 130), Vector2(110, 175), Vector2(65, 180), Vector2(25, 160)],
  ),
]);

BezierShape _shapeSix = BezierShape([
  Bezier.fromPoints(
    [Vector2(80, 38), Vector2(20, 38), Vector2(-10, 160), Vector2(50, 160)],
  ),
  Bezier.fromPoints(
    [Vector2(50, 160), Vector2(80, 160), Vector2(90, 140), Vector2(90, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(90, 110), Vector2(90, 80), Vector2(30, 90), Vector2(20, 120)],
  ),
]);

BezierShape _shapeSeven = BezierShape([
  Bezier.fromPoints(
    [Vector2(36, 48), Vector2(35, 43), Vector2(34, 38)],
  ),
  Bezier.fromPoints(
    [Vector2(34, 38), Vector2(72, 34), Vector2(110, 30)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 30), Vector2(87, 90), Vector2(64, 150)],
  ),
  Bezier.fromPoints(
    [Vector2(60, 100), Vector2(80, 100), Vector2(100, 100)],
  ),
]);

BezierShape _shapeEight = BezierShape([
  Bezier.fromPoints(
    [Vector2(70, 30), Vector2(35, 30), Vector2(26, 70), Vector2(67, 89)],
  ),
  Bezier.fromPoints(
    [Vector2(67, 89), Vector2(108, 89), Vector2(111, 30), Vector2(70, 30)],
  ),
  Bezier.fromPoints(
    [Vector2(67, 89), Vector2(24, 89), Vector2(10, 170), Vector2(64, 170)],
  ),
  Bezier.fromPoints(
    [Vector2(64, 170), Vector2(118, 170), Vector2(102, 89), Vector2(68, 89)],
  ),
]);

BezierShape _shapeNine = BezierShape([
  Bezier.fromPoints(
    [Vector2(110, 60), Vector2(110, 90), Vector2(42, 90), Vector2(42, 60)],
  ),
  Bezier.fromPoints(
    [Vector2(42, 60), Vector2(42, 20), Vector2(110, 20), Vector2(110, 60)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 60), Vector2(110, 85), Vector2(110, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 110), Vector2(110, 160), Vector2(57, 160)],
  ),
  Bezier.fromPoints(
    [Vector2(57, 160), Vector2(40, 160), Vector2(40, 135)],
  ),
]);

List<BezierShape> shapes = [
  _shapeZero,
  _shapeOne,
  _shapeTwo,
  _shapeThree,
  _shapeFour,
  _shapeFive,
  _shapeSix,
  _shapeSeven,
  _shapeEight,
  _shapeNine,
];
