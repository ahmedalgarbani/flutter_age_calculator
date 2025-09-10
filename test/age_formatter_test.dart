import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

void main() {
  group('AgeFormatter', () {
    late AgeDuration sampleAge;

    setUp(() {
      sampleAge = AgeDuration(
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

    test('should format full age correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.full);
      expect(formatted, '25 years, 6 months, 15 days');
    });

    test('should format years only correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.yearsOnly);
      expect(formatted, '25 years');
    });

    test('should format years and months correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.yearsMonths);
      expect(formatted, '25y 6m');
    });

    test('should format detailed age correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.detailed);
      expect(formatted, contains('Years: 25'));
      expect(formatted, contains('Months: 6'));
      expect(formatted, contains('Days: 15'));
      expect(formatted, contains('Hours: 8'));
    });

    test('should format Arabic age correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.arabic);
      expect(formatted, '25 سنة و 6 شهر و 15 يوم');
    });

    test('should format compact age correctly', () {
      final formatted = AgeFormatter.format(sampleAge, AgeFormat.compact);
      expect(formatted, '25y');
    });

    test('should handle single values without plural', () {
      final singleAge = AgeDuration(
        years: 1,
        months: 1,
        days: 1,
        hours: 1,
        minutes: 1,
        seconds: 1,
        totalDays: 366,
        totalHours: 8784,
        totalMinutes: 527040,
        totalSeconds: 31622461,
      );

      final formatted = AgeFormatter.format(singleAge, AgeFormat.full);
      expect(formatted, '1 year, 1 month, 1 day');
    });

    test('should handle zero values correctly', () {
      final zeroMonthsAge = AgeDuration(
        years: 5,
        months: 0,
        days: 10,
        hours: 0,
        minutes: 0,
        seconds: 0,
        totalDays: 1836,
        totalHours: 44064,
        totalMinutes: 2643840,
        totalSeconds: 158630400,
      );

      final formatted = AgeFormatter.format(zeroMonthsAge, AgeFormat.full);
      expect(formatted, '5 years, 10 days');
    });
  });
}
