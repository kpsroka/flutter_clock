import 'dart:math';

import 'package:flutter/material.dart';

enum DateTimeGranularity {
  second,
  minute,
  hour,
  day,
  month,
  year,
}

class DateTimeProvider extends InheritedModel<DateTimeGranularity> {
  final DateTime dateTime;

  DateTimeProvider({@required this.dateTime, @required Widget child})
      : assert(dateTime != null),
        super(child: child);

  @override
  bool updateShouldNotify(DateTimeProvider oldWidget) {
    return !oldWidget.dateTime.isAtSameMomentAs(dateTime);
  }

  @override
  bool updateShouldNotifyDependent(
      DateTimeProvider oldWidget, Set<DateTimeGranularity> dependencies) {
    return _isDifferentAtGranularity(
      oldWidget.dateTime,
      dateTime,
      _mostGranular(dependencies),
    );
  }

  static DateTime of(BuildContext buildContext,
      {@required DateTimeGranularity granularity}) {
    assert(granularity != null);
    return buildContext
        .dependOnInheritedWidgetOfExactType<DateTimeProvider>(
            aspect: granularity)
        .dateTime;
  }

  static DateTimeGranularity _mostGranular(
      Set<DateTimeGranularity> granularities) {
    assert(granularities.isNotEmpty);
    assert(granularities.every((element) => element != null));
    final int minIndex = granularities
        .map((DateTimeGranularity granularity) => granularity.index)
        .fold<int>(0xC0FFEE /* really high */, min);
    return DateTimeGranularity.values[minIndex];
  }

  static bool _isDifferentAtGranularity(
      DateTime a, DateTime b, DateTimeGranularity granularity) {
    switch (granularity) {
      case DateTimeGranularity.second:
        if (a.second != b.second) return true;
        continue minute;
      minute:
      case DateTimeGranularity.minute:
        if (a.minute != b.minute) return true;
        continue hour;
      hour:
      case DateTimeGranularity.hour:
        if (a.hour != b.hour) return true;
        continue day;
      day:
      case DateTimeGranularity.day:
        if (a.day != b.day) return true;
        continue month;
      month:
      case DateTimeGranularity.month:
        if (a.month != b.month) return true;
        continue year;
      year:
      case DateTimeGranularity.year:
        if (a.year != b.year) return true;
    }
    return false;
  }
}
