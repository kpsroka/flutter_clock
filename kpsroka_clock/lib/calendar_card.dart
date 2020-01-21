import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model_provider.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              color: Colors.blueGrey,
              child: const _Year(),
            ),
          ),
          Expanded(
            flex: 11,
            child: Container(
              alignment: Alignment.center,
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 35, child: _TearOff()),
                    const Expanded(child: _Month()),
                    const Expanded(flex: 4, child: Center(child: _Day())),
                    const Expanded(child: _DayOfWeek()),
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

class _Month extends StatelessWidget {
  const _Month();

  @override
  Widget build(BuildContext context) {
    return _AdaptiveTextSize(
      textSizeFactor: 0.75,
      child: Text(
        DateFormat.LLLL().format(
          DateTimeProvider.of(
            context,
            granularity: DateTimeGranularity.month,
          ),
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class _AdaptiveTextSize extends StatelessWidget {
  final Text child;
  final double textSizeFactor;

  const _AdaptiveTextSize({Key key, this.child, this.textSizeFactor = 0.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DefaultTextStyle(
          style: TextStyle(
            fontSize: constraints.maxHeight * textSizeFactor,
            fontFamily: 'AlegreyaSC',
          ),
          child: child,
        );
      },
    );
  }
}

class _Day extends StatelessWidget {
  const _Day();

  @override
  Widget build(BuildContext context) {
    return _AdaptiveTextSize(
      textSizeFactor: 0.7,
      child: Text(
        DateTimeProvider.of(
          context,
          granularity: DateTimeGranularity.day,
        ).day.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class _DayOfWeek extends StatelessWidget {
  const _DayOfWeek();

  @override
  Widget build(BuildContext context) {
    return _AdaptiveTextSize(
      child: Text(
        DateFormat.EEEE().format(
          DateTimeProvider.of(
            context,
            granularity: DateTimeGranularity.day,
          ),
        ),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}

class _Year extends StatelessWidget {
  const _Year();

  @override
  Widget build(BuildContext context) {
    return _AdaptiveTextSize(
      child: Text(
        DateTimeProvider.of(
          context,
          granularity: DateTimeGranularity.year,
        ).year.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(offset: Offset(2, 2), blurRadius: 2.0)],
        ),
      ),
    );
  }
}

class _TearOff extends StatelessWidget {
  final List<int> _frontTearOffPoints;
  final List<int> _backTearOffPoints;

  _TearOff()
      : _frontTearOffPoints = List.generate(30, (_) => Random().nextInt(15)),
        _backTearOffPoints = List.generate(30, (int index) => Random().nextInt(10));

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TearOffPainter(_backTearOffPoints),
      foregroundPainter: _TearOffPainter(_frontTearOffPoints),
    );
  }
}

class _TearOffPainter extends CustomPainter {
  final List<int> tearOffPoints;

  _TearOffPainter(this.tearOffPoints)
      : assert(tearOffPoints != null && tearOffPoints.every((int value) => value != null));

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width > 0);

    Path path = Path();
    path.lineTo(0, 10);
    tearOffPoints.asMap().forEach((int index, int point) {
      path.lineTo(
        size.width / (tearOffPoints.length + 1) * index,
        10 + point.toDouble(),
      );
    });
    path.lineTo(size.width, 10);
    path.lineTo(size.width, 0);

    canvas.drawPath(
        path,
        new Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.grey[100]);

    canvas.drawShadow(path, Colors.black45, 1, false);
  }

  @override
  bool shouldRepaint(_TearOffPainter oldDelegate) {
    if (oldDelegate.tearOffPoints == tearOffPoints) {
      return false;
    }

    if (oldDelegate.tearOffPoints.length != tearOffPoints.length) {
      return true;
    }

    for (int index = 0; index < tearOffPoints.length; index++) {
      if (tearOffPoints[index] != oldDelegate.tearOffPoints[index]) {
        return true;
      }
    }

    return false;
  }
}
