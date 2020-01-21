// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:kpsroka_clock/clock_board.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'calendar_card.dart';
import 'model_provider.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_onModelUpdate);
    _updateTime();
    _onModelUpdate();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_onModelUpdate);
      widget.model.addListener(_onModelUpdate);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_onModelUpdate);
    widget.model.dispose();
    super.dispose();
  }

  void _onModelUpdate() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeProvider(
      dateTime: _dateTime,
      child: DefaultTextStyle(
        style: TextStyle(fontFamily: 'AlegreyaSC'),
        child: Container(
          child: Center(
            child: Row(
              children: [
                const Expanded(flex: 3, child: ClockBoard()),
                const Expanded(flex: 1, child: CalendarCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
