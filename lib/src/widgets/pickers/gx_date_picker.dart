import 'package:gx_datetime_picker/src/controllers/gx_date_picker_controller.dart';
import 'package:gx_datetime_picker/src/data/format.dart';
import 'package:gx_datetime_picker/src/data/locale.dart';
import 'package:gx_datetime_picker/src/data/picker_type.dart';
import 'package:gx_datetime_picker/src/models/gx_date.dart';
import 'package:gx_datetime_picker/src/theme/gx_date_picker_theme.dart';
import 'package:gx_datetime_picker/src/utils/gx_date_utils.dart';
import 'package:gx_datetime_picker/src/utils/validation_utils.dart';
import 'package:gx_datetime_picker/src/widgets/custom/custom_item_picker_widget.dart';
import 'package:flutter/material.dart';

class GXDatePicker extends StatefulWidget {
  GXDatePicker({
    super.key,
    this.minDate,
    this.maxDate,
    this.initialDate,
    this.locale = LocaleType.en,
    this.dateFormat = GXDateFormat.dMy,
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
  })  : assert(
          ValidationUtils.isValidDateRange(minDate: minDate, maxDate: maxDate),
          'minDate must be before maxDate',
        ),
        assert(
          ValidationUtils.isValidInitialDate(
              date: initialDate, minDate: minDate, maxDate: maxDate),
          'initialDate must be within minDate and maxDate range',
        );

  /// The minimum selectable date for the date picker (default 1/1/1900).
  final GXDate? minDate;

  /// The maximum selectable date for the date picker (default 31/12/2100).
  final GXDate? maxDate;

  /// The initial date displayed when the picker is first shown (default current date).
  final GXDate? initialDate;

  /// The locale to use for displaying the date format (default [LocaleType.en]).
  final LocaleType locale;

  /// The format of the date to be displayed in the picker (default [AwesomeDateFormat.dMy]).
  final GXDateFormat dateFormat;

  /// The theme for customizing the appearance of the date picker (year, month, day themes).
  final GXDatePickerTheme? theme;

  /// A callback function that is triggered when the selected date changes.
  final ValueChanged<GXDate>? onChanged;

  /// The background color of the date picker.
  /// This value is overridden by the value passed in the theme's backgroundColor property.
  final Color? backgroundColor;

  /// The color of the selector (highlight) used in the date picker.
  final Color? selectorColor;

  /// A flag to indicate whether to apply a fade effect on the edges of the picker (default true).
  final bool? fadeEffect;

  /// The text style for the selected date.
  /// This value is overridden by the value passed in the theme's selectedTextStyle property.
  final TextStyle? selectedTextStyle;

  /// The text style for the unselected dates
  /// This value is overridden by the value passed in the theme's unselectedTextStyle property.
  final TextStyle? unselectedTextStyle;

  /// The number of visible items in the date picker at once.
  final int? visibleItemCount;

  /// The height of each item in the date picker.
  /// This value is overridden by the value passed in the theme's height property.
  final double? itemHeight;

  /// The width of each item in the date picker.
  /// This value is overridden by the value passed in the theme's width property.
  final double? itemWidth;

  @override
  State<GXDatePicker> createState() => _GXDatePickerState();
}

class _GXDatePickerState extends State<GXDatePicker> {
  late final GXDatePickerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = GXDatePickerController(
      minDate: widget.minDate ?? GXDate(year: 1900, month: 1, day: 1),
      maxDate: widget.maxDate ?? GXDate(year: 2100, month: 12, day: 31),
      locale: widget.locale,
      initialDate: widget.initialDate,
    );

    _controller.addListener(() {
      widget.onChanged?.call(_controller.selectedDate);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (widget.dateFormat.value[index] == PickerType.day) {
          return CustomItemPicker(
            key: ValueKey(_controller.selectedDate.year ==
                        _controller.minDate.year &&
                    _controller.selectedDate.month == _controller.minDate.month
                ? "day_picker 1"
                : _controller.selectedDate.year == _controller.maxDate.year &&
                        _controller.selectedDate.month ==
                            _controller.maxDate.month
                    ? "day_picker 2"
                    : "day_picker 3"),
            items: _controller.days,
            initialIndex: _controller.days
                .indexOf(_controller.selectedDate.day.toString()),
            theme: widget.theme?.dayTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedItemChanged: (newValue) {
              _controller.onSelectedDayChanged(newValue);
              setState(() {});
              widget.onChanged?.call(_controller.selectedDate);
            },
          );
        } else if (widget.dateFormat.value[index] == PickerType.year) {
          return CustomItemPicker(
            items: _controller.years,
            initialIndex: _controller.years
                .indexOf(_controller.selectedDate.year.toString()),
            theme: widget.theme?.yearTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedItemChanged: (newValue) {
              _controller.onSelectedYearChanged(newValue);
              setState(() {});
              widget.onChanged?.call(_controller.selectedDate);
            },
          );
        } else if (widget.dateFormat.value[index] == PickerType.month_text) {
          return CustomItemPicker(
            key: ValueKey(
                _controller.selectedDate.year == _controller.minDate.year
                    ? "text_month_picker 1"
                    : _controller.selectedDate.year == _controller.maxDate.year
                        ? "text_month_picker 2"
                        : "text_month_picker 3"),
            items: _controller.monthsNames,
            initialIndex: _controller.monthsNames.indexOf(
                GXDateUtils.getMonthNames(
                    widget.locale)[_controller.selectedDate.month - 1]),
            theme: widget.theme?.monthTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedItemChanged: (newValue) {
              _controller.onSelectedMonthNameChanged(newValue);
              setState(() {});
              widget.onChanged?.call(_controller.selectedDate);
            },
          );
        } else if (widget.dateFormat.value[index] == PickerType.month_number) {
          return CustomItemPicker(
            key: ValueKey(
                _controller.selectedDate.year == _controller.minDate.year
                    ? "number_month_picker 1"
                    : _controller.selectedDate.year == _controller.maxDate.year
                        ? "number_month_picker 2"
                        : "number_month_picker 3"),
            items: _controller.monthsNumbers,
            initialIndex: _controller.monthsNumbers
                .indexOf(_controller.selectedDate.month.toString()),
            theme: widget.theme?.monthTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedItemChanged: (newValue) {
              _controller.onSelectedMonthNumberChanged(newValue);
              setState(() {});

              widget.onChanged?.call(_controller.selectedDate);
            },
          );
        } else if (widget.dateFormat.value[index] == PickerType.month_text_short) {
          return CustomItemPicker(
            key: ValueKey(
                _controller.selectedDate.year == _controller.minDate.year
                    ? "short_text_month_picker 1"
                    : _controller.selectedDate.year == _controller.maxDate.year
                        ? "short_text_month_picker 2"
                        : "short_text_month_picker 3"),
            items: _controller.shortMonthsNames,
            initialIndex: _controller.shortMonthsNames.indexOf(
                GXDateUtils.getShortMonthNames(
                    widget.locale)[_controller.selectedDate.month - 1]),
            theme: widget.theme?.monthTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedItemChanged: (newValue) {
              _controller.onSelectedShortMonthNameChanged(newValue);
              setState(() {});
              widget.onChanged?.call(_controller.selectedDate);
            },
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
