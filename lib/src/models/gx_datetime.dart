import 'package:gx_datetime_picker/src/models/gx_date.dart';
import 'package:gx_datetime_picker/src/models/gx_time.dart';

class GXDateTime {
  GXDate date;
  GXTime time;

  GXDateTime({required this.date, required this.time});

  @override
  String toString(){
    return "${date} ${time}";
  }
}
