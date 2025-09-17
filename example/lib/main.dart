import 'package:gx_datetime_picker/gx_datetime_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          GXDatePicker(
            dateFormat: GXDateFormat.dMMyShort,
            minDate: GXDate(year: 2024, month: 2, day: 15),
            maxDate: GXDate(year: 2026, month: 10, day: 10),
            onChanged: (GXDate date) {
              print(
                  "----Date changed : ${date.day}/${date.month}/${date.year}\n");
            },
          ),
          GXTimePicker(
            timeFormat: GXTimeFormat.hm,
            minTime: GXTime(hour: 0, minute: 0),
            maxTime: GXTime(hour: 17, minute: 00),
            initialTime: GXTime(hour: 8, minute: 10),
            onChanged: (GXTime time) {
              print("----Time changed : ${time.hour}:${time.minute}\n");
            },
          ),
          GXDateTimePicker(
            dateFormat: GXDateFormat.dMMyShort,
            timeFormat: GXTimeFormat.hm,
            maxDateTime: GXDateTime(
                date: GXDate(year: 2025, month: 12, day: 10),
                time: GXTime(hour: 15, minute: 59)),
            onChanged: (GXDateTime dateTime) {
              print(
                  "----Date time changed : ${dateTime.date.year}/${dateTime.date.month}/${dateTime.date.day} ${dateTime.time.hour}:${dateTime.time.minute}\n");
            },
          ),
        ],
      ),
    );
  }
}
