import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

void main() {
  group('AdvancedAgeCalculator', () {
    late DateTime birthDate;
    late DateTime currentDate;

    setUp(() {
      birthDate = DateTime(1990, 5, 15, 10, 30, 0);
      currentDate = DateTime(2023, 8, 20, 15, 45, 30);
    });

    group('calculateAge', () {
      test('should calculate correct age for basic case', () {
        final age = AdvancedAgeCalculator.calculateAge(
          birthDate: birthDate,
          currentDate: currentDate,
        );

        expect(age.years, 33);
        expect(age.months, 3);
        expect(age.days, 5);
      });

      test('should calculate age with time when includeTime is true', () {
        final age = AdvancedAgeCalculator.calculateAge(
          birthDate: birthDate,
          currentDate: currentDate,
          includeTime: true,
        );

        expect(age.years, 33);
        expect(age.months, 3);
        expect(age.days, 5);
        expect(age.hours, 5);
        expect(age.minutes, 15);
        expect(age.seconds, 30);
      });

      test('should handle leap year correctly', () {
        final leapYearBirth = DateTime(2000, 2, 29);
        final nextYear = DateTime(2001, 3, 1);

        final age = AdvancedAgeCalculator.calculateAge(
          birthDate: leapYearBirth,
          currentDate: nextYear,
        );

        expect(age.years, 1);
        expect(age.months, 0);
        expect(age.days, 1);
      });

      test('should throw exception for future birth date', () {
        final futureBirth = DateTime.now().add(Duration(days: 1));

        expect(
          () => AdvancedAgeCalculator.calculateAge(birthDate: futureBirth),
          throwsA(isA<FutureBirthDateException>()),
        );
      });

      test('should calculate total days correctly', () {
        final age = AdvancedAgeCalculator.calculateAge(
          birthDate: DateTime(2020, 1, 1),
          currentDate: DateTime(2020, 1, 11),
        );

        expect(age.totalDays, 10);
      });
    });

    group('calculateNextBirthday', () {
      test('should return next birthday in same year if not passed', () {
        final birth = DateTime(1990, 12, 25);
        final current = DateTime(2023, 6, 15);

        final nextBirthday = AdvancedAgeCalculator.calculateNextBirthday(
          birthDate: birth,
          currentDate: current,
        );

        expect(nextBirthday.year, 2023);
        expect(nextBirthday.month, 12);
        expect(nextBirthday.day, 25);
      });

      test('should return next birthday in following year if already passed',
          () {
        final birth = DateTime(1990, 3, 10);
        final current = DateTime(2023, 6, 15);

        final nextBirthday = AdvancedAgeCalculator.calculateNextBirthday(
          birthDate: birth,
          currentDate: current,
        );

        expect(nextBirthday.year, 2024);
        expect(nextBirthday.month, 3);
        expect(nextBirthday.day, 10);
      });
    });

    group('calculateDaysUntilBirthday', () {
      test('should calculate days until birthday correctly', () {
        final birth = DateTime(1990, 8, 25);
        final current = DateTime(2023, 8, 20);

        final days = AdvancedAgeCalculator.calculateDaysUntilBirthday(
          birthDate: birth,
          currentDate: current,
        );

        expect(days, 5);
      });
    });

    group('getZodiacSign', () {
      test('should return correct zodiac signs', () {
        expect(AdvancedAgeCalculator.getZodiacSign(DateTime(1990, 3, 25)),
            'Aries');
        expect(AdvancedAgeCalculator.getZodiacSign(DateTime(1990, 7, 15)),
            'Cancer');
        expect(AdvancedAgeCalculator.getZodiacSign(DateTime(1990, 12, 25)),
            'Capricorn');
      });
    });

    group('isLeapYear', () {
      test('should identify leap years correctly', () {
        expect(AdvancedAgeCalculator.isLeapYear(2000), true);
        expect(AdvancedAgeCalculator.isLeapYear(2004), true);
        expect(AdvancedAgeCalculator.isLeapYear(1900), false);
        expect(AdvancedAgeCalculator.isLeapYear(2023), false);
      });
    });

    group('getAgeStatistics', () {
      test('should return comprehensive age statistics', () {
        final stats = AdvancedAgeCalculator.getAgeStatistics(
          birthDate: DateTime(1990, 5, 15),
          currentDate: DateTime(2023, 8, 20),
        );

        expect(stats['age'], isA<Map<String, dynamic>>());
        expect(stats['nextBirthday'], isA<String>());
        expect(stats['daysUntilBirthday'], isA<int>());
        expect(stats['zodiacSign'], isA<String>());
        expect(stats['formattedAges'], isA<Map<String, dynamic>>());
      });
    });
  });
}
