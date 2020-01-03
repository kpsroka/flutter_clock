import 'dart:math';

import 'package:digital_clock/drawn_shape.dart';
import 'package:digital_clock/shapes.dart';
import 'package:flutter/material.dart';

class ClockBoard extends StatefulWidget {
  const ClockBoard();

  @override
  _ClockBoardState createState() => _ClockBoardState();
}

class _ClockBoardState extends State<ClockBoard>
    with SingleTickerProviderStateMixin {
  int _shapeIndex = 0;

  @override
  void initState() {
    super.initState();
    _switchShape();
  }

  void _switchShape() async {
    await Future.delayed(Duration(seconds: 10));
    if (super.mounted) {
      final nextShapeIndex = Random().nextInt(10000);
      _switchShape();
      setState(() {
        _shapeIndex = nextShapeIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BezierShape mergedShape = shapes[_shapeIndex ~/ 1000].normalized(width: 140, height: 200)
        .joinedWith(shapes[(_shapeIndex ~/ 100) % 10].normalized(width: 140, height: 200), offset: 32)
        .joinedWith(shapes[(_shapeIndex ~/ 10) % 10].normalized(width: 140, height: 200), offset: 32)
        .joinedWith(shapes[_shapeIndex % 10].normalized(width: 140, height: 200), offset: 32);

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
          Positioned.fill(
            child: Center(
              child: Container(
                color: Colors.lightGreen.withAlpha(0xf0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DrawnShape(shape: mergedShape),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
