class GXTime {
  int hour;
  int minute;

  GXTime({required this.hour, required this.minute});

  @override
  String toString() {
    return "${hour}:${minute}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GXTime &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode => Object.hash(hour, minute);
}
