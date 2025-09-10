import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

void main() {
  group('AgeDuration', () {
    late AgeDuration ageDuration;

    setUp(() {
      ageDuration = AgeDuration(
        years: 25,
        months: 6,
        days: 15,
        hours: 8,
        minutes: 30,
        seconds: 45,
        totalDays: 9332,
        totalHours: 223968,
        totalMinutes: 13438080,
        totalSeconds: 806284845,
      );
    });

    test('should create AgeDuration with all properties', () {
      expect(ageDuration.years, 25);
      expect(ageDuration.months, 6);
      expect(ageDuration.days, 15);
      expect(ageDuration.hours, 8);
      expect(ageDuration.minutes, 30);
      expect(ageDuration.seconds, 45);
      expect(ageDuration.totalDays, 9332);
    });

    test('should convert to JSON correctly', () {
      final json = ageDuration.toJson();

      expect(json['years'], 25);
      expect(json['months'], 6);
      expect(json['days'], 15);
      expect(json['totalDays'], 9332);
    });

    test('should create from JSON correctly', () {
      final json = {
        'years': 30,
        'months': 8,
        'days': 10,
        'hours': 12,
        'minutes': 45,
        'seconds': 30,
        'totalDays': 11000,
        'totalHours': 264000,
        'totalMinutes': 15840000,
        'totalSeconds': 950400000,
      };

      final duration = AgeDuration.fromJson(json);

      expect(duration.years, 30);
      expect(duration.months, 8);
      expect(duration.days, 10);
      expect(duration.totalDays, 11000);
    });

    test('should have proper toString representation', () {
      final toString = ageDuration.toString();

      expect(toString, contains('AgeDuration'));
      expect(toString, contains('years: 25'));
      expect(toString, contains('months: 6'));
    });
  });
}
