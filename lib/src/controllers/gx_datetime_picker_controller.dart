import 'package:gx_datetime_picker/gx_datetime_picker.dart';
import 'package:flutter/material.dart';

class GXDateTimePickerController extends ChangeNotifier {
  final GXDateTime minDateTime;
  final GXDateTime maxDateTime;

  late GXDateTime _selectedDateTime;
  GXDateTime get selectedDateTime => _selectedDateTime;

  GXDateTimePickerController({
    required this.minDateTime,
    required this.maxDateTime,
    GXDateTime? initialDateTime,
  }) {
    _selectedDateTime = initialDateTime ?? minDateTime;
    _clampDateTime();
  }

  // Central update method
  void _setDateTime(GXDate date, GXTime time) {
    _selectedDateTime = GXDateTime(date: date, time: time);
    _clampDateTime();
    notifyListeners();
  }

  // Clamp to min/max rules
  void _clampDateTime() {
    final minDT = DateTime(
      minDateTime.date.year,
      minDateTime.date.month,
      minDateTime.date.day,
      minDateTime.time.hour,
      minDateTime.time.minute,
    );
    final maxDT = DateTime(
      maxDateTime.date.year,
      maxDateTime.date.month,
      maxDateTime.date.day,
      maxDateTime.time.hour,
      maxDateTime.time.minute,
    );
    final native = DateTime(
      _selectedDateTime.date.year,
      _selectedDateTime.date.month,
      _selectedDateTime.date.day,
      _selectedDateTime.time.hour,
      _selectedDateTime.time.minute,
    );

    if (native.isBefore(minDT)) {
      _selectedDateTime = minDateTime;
    } else if (native.isAfter(maxDT)) {
      _selectedDateTime = maxDateTime;
    }
  }

  // Public setters
  void setDate(GXDate date) {
    _setDateTime(date, _selectedDateTime.time);
  }

  void setTime(GXTime time) {
    _setDateTime(_selectedDateTime.date, time);
  }

  // Dynamic min/max time based on current date
  GXTime get minTime {
    return _selectedDateTime.date == minDateTime.date
        ? minDateTime.time
        : GXTime(hour: 0, minute: 0);
  }

  GXTime get maxTime {
    return _selectedDateTime.date == maxDateTime.date
        ? maxDateTime.time
        : GXTime(hour: 23, minute: 59);
  }
}
