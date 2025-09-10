/// Represents a calculated age duration with all components
class AgeDuration {
  /// Years component of the age
  final int years;

  /// Months component of the age
  final int months;

  /// Days component of the age
  final int days;

  /// Hours component of the age
  final int hours;

  /// Minutes component of the age
  final int minutes;

  /// Seconds component of the age
  final int seconds;

  /// Total number of days lived
  final int totalDays;

  /// Total number of hours lived
  final int totalHours;

  /// Total number of minutes lived
  final int totalMinutes;

  /// Total number of seconds lived
  final int totalSeconds;

  /// Creates an AgeDuration with all time components
  const AgeDuration({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
  });

  /// String representation of the age duration
  @override
  String toString() {
    return 'AgeDuration(years: $years, months: $months, days: $days, hours: $hours, minutes: $minutes, seconds: $seconds)';
  }

  /// Converts the AgeDuration to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'years': years,
      'months': months,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'totalDays': totalDays,
      'totalHours': totalHours,
      'totalMinutes': totalMinutes,
      'totalSeconds': totalSeconds,
    };
  }

  /// Creates an AgeDuration from a JSON map
  factory AgeDuration.fromJson(Map<String, dynamic> json) {
    return AgeDuration(
      years: json['years'] ?? 0,
      months: json['months'] ?? 0,
      days: json['days'] ?? 0,
      hours: json['hours'] ?? 0,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
      totalHours: json['totalHours'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      totalSeconds: json['totalSeconds'] ?? 0,
    );
  }

  /// Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AgeDuration &&
        other.years == years &&
        other.months == months &&
        other.days == days &&
        other.hours == hours &&
        other.minutes == minutes &&
        other.seconds == seconds;
  }

  /// Hash code
  @override
  int get hashCode {
    return years.hashCode ^
        months.hashCode ^
        days.hashCode ^
        hours.hashCode ^
        minutes.hashCode ^
        seconds.hashCode;
  }
}
