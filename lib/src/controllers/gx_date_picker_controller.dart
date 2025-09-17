import 'package:gx_datetime_picker/gx_datetime_picker.dart';
import 'package:gx_datetime_picker/src/utils/gx_date_utils.dart';
import 'package:flutter/material.dart';

class GXDatePickerController extends ChangeNotifier {
  final GXDate minDate;
  final GXDate maxDate;
  final LocaleType locale;

  late GXDate _selectedDate;
  GXDate get selectedDate => _selectedDate;

  GXDatePickerController({
    required this.minDate,
    required this.maxDate,
    required this.locale,
    GXDate? initialDate,
  }) {
    _selectedDate = initialDate ?? minDate;
  }

  /// Centralized setter
  void _setDate(int year, int month, int day) {
    // Clamp day to month max
    final maxDay = DateUtils.getDaysInMonth(year, month);
    if (day > maxDay) day = maxDay;

    // Build new date
    var newDate = GXDate(year: year, month: month, day: day);

    // Clamp to min/max range
    final minDT = DateTime(minDate.year, minDate.month, minDate.day);
    final maxDT = DateTime(maxDate.year, maxDate.month, maxDate.day);
    final native = DateTime(year, month, day);

    if (native.isBefore(minDT)) {
      newDate = minDate;
    } else if (native.isAfter(maxDT)) {
      newDate = maxDate;
    }

    _selectedDate = newDate;
    notifyListeners();
  }

  void onSelectedYearChanged(String newValue) {
    final year = int.parse(newValue);
    _setDate(year, _selectedDate.month, _selectedDate.day);
  }

  void onSelectedMonthNumberChanged(String newValue) {
    final month = int.parse(newValue);
    _setDate(_selectedDate.year, month, _selectedDate.day);
  }

  void onSelectedMonthNameChanged(String newValue) {
    final monthNumber =
        GXDateUtils.getMonthNames(locale).indexOf(newValue) + 1;
    _setDate(_selectedDate.year, monthNumber, _selectedDate.day);
  }

  void onSelectedShortMonthNameChanged(String newValue) {
    final monthNumber =
        GXDateUtils.getShortMonthNames(locale).indexOf(newValue) + 1;
    _setDate(_selectedDate.year, monthNumber, _selectedDate.day);
  }

  void onSelectedDayChanged(String newValue) {
    final day = int.parse(newValue);
    _setDate(_selectedDate.year, _selectedDate.month, day);
  }


  List<String> get years => List.generate(
        maxDate.year - minDate.year + 1,
        (i) => (minDate.year + i).toString(),
      );

  List<String> get monthsNumbers {
    int minValue = (selectedDate.year == minDate.year) ? minDate.month : 1;
    int maxValue = (selectedDate.year == maxDate.year) ? maxDate.month : 12;

    return List.generate(
        maxValue - minValue + 1, (i) => (i + minValue).toString());
  }

  List<String> get monthsNames {
    int minValue = (selectedDate.year == minDate.year) ? minDate.month : 1;
    int maxValue = (selectedDate.year == maxDate.year) ? maxDate.month : 12;

    final allMonthsNames = GXDateUtils.getMonthNames(locale);
    return allMonthsNames.sublist(minValue - 1, maxValue);
  }

  List<String> get shortMonthsNames {
    int minValue = (selectedDate.year == minDate.year) ? minDate.month : 1;
    int maxValue = (selectedDate.year == maxDate.year) ? maxDate.month : 12;

    final allShortMonthsNames = GXDateUtils.getShortMonthNames(locale);
    return allShortMonthsNames.sublist(minValue - 1, maxValue);
  }

  List<String> get days {
    int minValue = 1;
    int maxValue =
        DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);

    if (selectedDate.year == minDate.year &&
        selectedDate.month == minDate.month) {
      minValue = minDate.day;
    }
    if (selectedDate.year == maxDate.year &&
        selectedDate.month == maxDate.month) {
      maxValue = maxDate.day;
    }

    final allDays =
        GXDateUtils.getMonthDays(selectedDate.year, selectedDate.month);
    return allDays.sublist(minValue - 1, maxValue);
  }
}
