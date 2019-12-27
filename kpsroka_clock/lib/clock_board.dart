import 'package:bezier/bezier.dart';
import 'package:digital_clock/drawn_shape.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector2;

List<Bezier> shapeOne = [
  Bezier.fromPoints([Vector2(40, 100), Vector2(58, 74), Vector2(76, 58)]),
  Bezier.fromPoints([Vector2(76, 58), Vector2(76, 114), Vector2(76, 180)]),
];

List<Bezier> shapeTwo = [
  Bezier.fromPoints(
      [Vector2(36, 70), Vector2(36, 72), Vector2(56, 32), Vector2(76, 32)]),
  Bezier.fromPoints(
      [Vector2(76, 32), Vector2(92, 32), Vector2(108, 46), Vector2(108, 60)]),
  Bezier.fromPoints([
    Vector2(108, 60),
    Vector2(108, 100),
    Vector2(60, 120),
    Vector2(40, 160)
  ]),
  Bezier.fromPoints([Vector2(40, 160), Vector2(76, 160), Vector2(112, 160)]),
];

class ClockBoard extends StatelessWidget {
  const ClockBoard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.grey, width: 8, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        shadows: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 1, spreadRadius: 1),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              ':',
              style: TextStyle(color: Colors.black, fontSize: 120),
            ),
          ),
          Positioned(
            left: 0,
            child: DrawnShape(shapes: shapeOne),
          ),
          Positioned(
            left: 200,
            child: DrawnShape(shapes: shapeTwo),
          )
        ],
      ),
    );
  }
}
