import 'package:gx_datetime_picker/src/theme/gx_date_picker_theme.dart';
import 'package:gx_datetime_picker/src/theme/gx_time_picker_theme.dart';

/// Theme for the datetime picker, allowing customization of both date and time pickers.
class GXDateTimePickerTheme {
  /// The theme for the date picker.
  /// It customizes the appearance of the date picker elements.
  final GXDatePickerTheme? datePickerTheme;

  /// The theme for the time picker.
  /// It customizes the appearance of the time picker elements.
  final GXTimePickerTheme? timePickerTheme;

  const GXDateTimePickerTheme(
      {this.datePickerTheme, this.timePickerTheme});
}
