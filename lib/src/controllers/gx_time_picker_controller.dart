import 'package:gx_datetime_picker/gx_datetime_picker.dart';
import 'package:gx_datetime_picker/src/utils/gx_time_utils.dart';
import 'package:flutter/material.dart';

class GXTimePickerController extends ChangeNotifier {
  late GXTime _minTime;
  late GXTime _maxTime;

  late GXTime _selectedTime;
  late String _selectedAmPm;

  GXTime get selectedTime => _selectedTime;
  String get selectedAmPm => _selectedAmPm;
  GXTime get minTime => _minTime;
  GXTime get maxTime => _maxTime;

  GXTimePickerController({
    required GXTime minTime,
    required GXTime maxTime,
    GXTime? initialTime,
  }) {
    _minTime = _copyTime(minTime);
    _maxTime = _copyTime(maxTime);

    final candidate = (initialTime != null &&
            GXTimeUtils.isBefore(initialTime, maxTime) &&
            GXTimeUtils.isAfter(initialTime, minTime))
        ? initialTime
        : _minTime;

    _selectedTime = _copyTime(candidate);
    _selectedAmPm = GXTimeUtils.getAmPm(_selectedTime.hour);
  }

  void updateConstraints({required GXTime minTime, required GXTime maxTime}) {
    final nextMin = _copyTime(minTime);
    final nextMax = _copyTime(maxTime);

    if (_minTime == nextMin && _maxTime == nextMax) return;

    _minTime = nextMin;
    _maxTime = nextMax;

    _selectedTime = _clampWithinRange(_selectedTime);
    _selectedAmPm = GXTimeUtils.getAmPm(_selectedTime.hour);

    notifyListeners();
  }

  GXTime _copyTime(GXTime time) =>
      GXTime(hour: time.hour, minute: time.minute);

  GXTime _clampWithinRange(GXTime time) {
    final minDT = DateTime(2025, 1, 1, _minTime.hour, _minTime.minute);
    final maxDT = DateTime(2025, 1, 1, _maxTime.hour, _maxTime.minute);
    final native = DateTime(2025, 1, 1, time.hour, time.minute);

    if (native.isBefore(minDT)) {
      return _copyTime(_minTime);
    }
    if (native.isAfter(maxDT)) {
      return _copyTime(_maxTime);
    }

    return _copyTime(time);
  }

  /// Centralized setter — clamps and notifies
  void _setTime(int hour, int minute) {
    // Build new time
    var newTime = GXTime(hour: hour, minute: minute);

    newTime = _clampWithinRange(newTime);

    _selectedTime = newTime;
    _selectedAmPm = GXTimeUtils.getAmPm(newTime.hour);

    notifyListeners();
  }

  /// Update hour in 24-hour mode
  void onSelectedHourChanged(String newValue) {
    _setTime(int.parse(newValue), _selectedTime.minute);
  }

  /// Update hour in 12-hour (AM/PM) mode
  void onSelectedAmPmHourChanged(String newValue) {
    final hour12 = int.parse(newValue) == 0 ? 12 : int.parse(newValue);
    final hour24 =
        GXTimeUtils.convertTo24HourFormat(hour12, _selectedAmPm);
    _setTime(hour24, _selectedTime.minute);
  }

  /// Update minutes
  void onSelectedMinuteChanged(String newValue) {
    _setTime(_selectedTime.hour, int.parse(newValue));
  }

  /// Update AM/PM
  void onSelectedAmPmChanged(String newValue) {
    _selectedAmPm = newValue;
    final toggledHour = GXTimeUtils.toggleAmPm(_selectedTime.hour);
    _setTime(toggledHour, _selectedTime.minute);
  }

  // ===== Computed Lists =====

  /// Hours in 24-hour format
  List<String> get hours => List.generate(
        maxTime.hour - minTime.hour + 1,
        (i) => (minTime.hour + i).toString().padLeft(2, '0'),
      );

  /// Hours in AM/PM mode
  List<String> get amPmHours {
    final isPm = _selectedAmPm == GXTimeUtils.amPm[1];
    final startHour = isPm ? 12 : 0;
    final endHour = isPm ? 23 : 11;

    final hours = <String>[];
    for (var hour = startHour; hour <= endHour; hour++) {
      if (!_isHourSelectable(hour)) continue;
      final displayHour =
          GXTimeUtils.convertTo12HourFormat(hour).toString();
      if (!hours.contains(displayHour)) {
        hours.add(displayHour);
      }
    }

    if (hours.isEmpty) {
      final fallback =
          GXTimeUtils.convertTo12HourFormat(_selectedTime.hour).toString();
      hours.add(fallback);
    }

    return hours;
  }

  bool _isHourSelectable(int hour) {
    if (hour < _minTime.hour || hour > _maxTime.hour) {
      return false;
    }

    final minMinute = hour == _minTime.hour ? _minTime.minute : 0;
    final maxMinute = hour == _maxTime.hour ? _maxTime.minute : 59;

    return minMinute <= maxMinute;
  }

  /// Minutes list
  List<String> get minutes {
    int minValue = 0;
    int maxValue = 59;

    if (_selectedTime.hour == maxTime.hour) {
      maxValue = maxTime.minute;
    }
    if (_selectedTime.hour == minTime.hour) {
      minValue = minTime.minute;
    }

    return List.generate(
      maxValue - minValue + 1,
      (i) => (i + minValue).toString().padLeft(2, '0'),
    );
  }

  /// AM/PM options
  List<String> get amPm {
    if (GXTimeUtils.getAmPm(maxTime.hour) == "AM") return ["AM"];
    if (GXTimeUtils.getAmPm(minTime.hour) == "PM") return ["PM"];
    return GXTimeUtils.amPm;
  }
}
