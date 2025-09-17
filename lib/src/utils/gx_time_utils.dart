import 'package:gx_datetime_picker/gx_datetime_picker.dart';

class GXTimeUtils {
  static const List<String> amPm = ["AM", "PM"];

  static String getAmPm(int hour) {
    if (hour == 0 || (hour >= 1 && hour <= 11)) {
      return "AM";
    }
    return "PM";
  }

  static int convertTo24HourFormat(int hour, String amPm) {
    if (amPm == "AM") {
      if (hour == 12) {
        return 0;  // 12 AM = midnight (0)
      } else {
        return hour;  // 1-11 AM = 1-11
      }
    } else { // PM
      if (hour == 12) {
        return 12;  // 12 PM = noon (12)
      } else {
        return hour + 12;  // 1-11 PM = 13-23
      }
    }
  }

  static int convertTo12HourFormat(int hour) {
    if (hour == 0) return 12;
    if (hour == 12) return 12;
    return hour % 12;
  }

  static int toggleAmPm(int hour) {
    return (hour + 12) % 24;
  }

  static bool isAfter(GXTime time1, GXTime time2) {
    if (time1.hour > time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute > time2.minute;
    }
    return false;
  }

  static bool isBefore(GXTime time1, GXTime time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute < time2.minute;
    }
    return false;
  }
}
