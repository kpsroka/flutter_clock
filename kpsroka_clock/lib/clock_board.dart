import 'dart:math';

import 'package:kpsroka_clock/drawn_shape_area.dart';
import 'package:flutter/material.dart';

class ClockBoard extends StatefulWidget {
  const ClockBoard();

  @override
  _ClockBoardState createState() => _ClockBoardState();
}

class _ClockBoardState extends State<ClockBoard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 8, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        shadows: [
          BoxShadow(offset: Offset(3, 3), blurRadius: 1, spreadRadius: 1),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.25,
              alignment: Alignment(-0.25, 0.15),
              child: DrawnShapeArea(),
            ),
          ),
        ],
      ),
    );
  }
}
