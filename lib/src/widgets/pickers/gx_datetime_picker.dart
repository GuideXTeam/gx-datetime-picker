import 'package:gx_datetime_picker/gx_datetime_picker.dart';
import 'package:gx_datetime_picker/src/controllers/gx_datetime_picker_controller.dart';
import 'package:flutter/material.dart';

class GXDateTimePicker extends StatefulWidget {
  const GXDateTimePicker({
    super.key,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.locale = LocaleType.en,
    this.dateFormat = GXDateFormat.dMy,
    this.timeFormat = GXTimeFormat.Hm,
    this.theme,
    this.onChanged,
    this.backgroundColor,
    this.fadeEffect,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectorColor,
    this.visibleItemCount,
    this.itemHeight,
    this.itemWidth,
  });

  /// The minimum selectable date and time for the date-time picker (default 1/1/1900 00:00).
  final GXDateTime? minDateTime;

  /// The maximum selectable date and time for the date-time picker (default 31/12/2100 23:59).
  final GXDateTime? maxDateTime;

  /// The initial date and time displayed when the picker is first shown (default current date and time).
  final GXDateTime? initialDateTime;

  /// The locale to use for displaying the date format (default [LocaleType.en].
  final LocaleType locale;

  /// The format of the date to be displayed in the picker (default [GXDateFormat.dMy]).
  final GXDateFormat dateFormat;

  /// The format of the time to be displayed in the picker (default [GXTimeFormat.Hm]).
  final GXTimeFormat timeFormat;

  /// The theme for customizing the appearance of the date-time picker (year, month, day, hour, minute themes).
  final GXDateTimePickerTheme? theme;

  /// A callback function that is triggered when the selected date or time changes.
  final ValueChanged<GXDateTime>? onChanged;

  /// The background color of the date-time picker.
  /// This value is overridden by the value passed in the theme's backgroundColor property.
  final Color? backgroundColor;

  /// The color of the selector (highlight) used in the date-time picker.
  final Color? selectorColor;

  /// A flag to indicate whether to apply a fade effect on the edges of the picker (default true).
  final bool? fadeEffect;

  /// The text style for the selected date and time.
  /// This value is overridden by the value passed in the theme's selectedTextStyle property.
  final TextStyle? selectedTextStyle;

  /// The text style for the unselected date and time.
  /// This value is overridden by the value passed in the theme's unselectedTextStyle property.
  final TextStyle? unselectedTextStyle;

  /// The number of visible items in the date-time picker at once.
  final int? visibleItemCount;

  /// The height of each item in the date-time picker.
  /// This value is overridden by the value passed in the theme's height property.
  final double? itemHeight;

  /// The width of each item in the date-time picker.
  /// This value is overridden by the value passed in the theme's width property.
  final double? itemWidth;

  @override
  State<GXDateTimePicker> createState() => _GXDateTimePickerState();
}

class _GXDateTimePickerState extends State<GXDateTimePicker> {
  late final GXDateTimePickerController _controller;
  late GXDateTime initialDateTime;

  @override
  void initState() {
    super.initState();

    initialDateTime = widget.initialDateTime ??
        GXDateTime(
            date: GXDate(
                year: DateTime.now().year,
                month: DateTime.now().month,
                day: DateTime.now().day),
            time: GXTime(
                hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));

    _controller = GXDateTimePickerController(
      minDateTime: widget.minDateTime ??
          GXDateTime(
              date: GXDate(year: 1900, month: 1, day: 1),
              time: GXTime(hour: 00, minute: 00)),
      maxDateTime: widget.maxDateTime ??
          GXDateTime(
              date: GXDate(year: 2100, month: 12, day: 31),
              time: GXTime(hour: 23, minute: 59)),
      initialDateTime: initialDateTime,
    );

    _controller.addListener(() {
      widget.onChanged?.call(_controller.selectedDateTime);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("For Datetiem picker");
    print("Max Time: ${_controller.maxTime}, Min Time : ${_controller.minTime}");
    print("The Date for this: ${_controller.selectedDateTime}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GXDatePicker(
          theme: widget.theme?.datePickerTheme,
          backgroundColor: widget.backgroundColor,
          dateFormat: widget.dateFormat,
          locale: widget.locale,
          maxDate: _controller.maxDateTime.date,
          minDate: _controller.minDateTime.date,
          initialDate: initialDateTime.date,
          selectorColor: widget.selectorColor,
          fadeEffect: widget.fadeEffect,
          selectedTextStyle: widget.selectedTextStyle,
          unselectedTextStyle: widget.unselectedTextStyle,
          visibleItemCount: widget.visibleItemCount,
          itemHeight: widget.itemHeight,
          itemWidth: widget.itemWidth,
          onChanged: (GXDate date) => _controller.setDate(date),
        ),
        GXTimePicker(
          theme: widget.theme?.timePickerTheme,
          backgroundColor: widget.backgroundColor,
          timeFormat: widget.timeFormat,
          maxTime: _controller.maxTime,
          minTime: _controller.minTime,
          initialTime: initialDateTime.time,
          selectorColor: widget.selectorColor,
          fadeEffect: widget.fadeEffect,
          selectedTextStyle: widget.selectedTextStyle,
          unselectedTextStyle: widget.unselectedTextStyle,
          visibleItemCount: widget.visibleItemCount,
          itemHeight: widget.itemHeight,
          itemWidth: widget.itemWidth,
          onChanged: (GXTime time) => _controller.setTime(time),
        ),
      ],
    );
  }
}
