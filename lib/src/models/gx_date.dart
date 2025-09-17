class GXDate {
  int year;
  int month;
  int day;

  GXDate({required this.year, required this.month, required this.day});

  @override
  String toString() {
    return "${year}/${month}/${day}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GXDate &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);
}
