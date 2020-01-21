// Copyright 2020 Krzysztof Sroka. All rights reseved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:kpsroka_clock/calendar_card.dart';
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.35,
              child: DrawnShapeArea(),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 12),
              child: CalendarCard(),
            ),
          ),
        ],
      ),
    );
  }
}
