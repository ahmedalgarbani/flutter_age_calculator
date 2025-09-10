import 'age_duration.dart';
import 'calendar_system.dart';
import 'timezone_helper.dart';
import 'age_formatter.dart';
import 'exceptions/age_calculator_exceptions.dart';

/// Main calculator class for advanced age calculations
class AdvancedAgeCalculator {
  /// Calculates age between birth date and current/specified date
  ///
  /// [birthDate] The birth date to calculate from
  /// [currentDate] Optional current date (defaults to DateTime.now())
  /// [timezone] Optional timezone for calculations
  /// [calendarSystem] Calendar system to use (defaults to Gregorian)
  /// [includeTime] Whether to include time components (hours, minutes, seconds)
  ///
  /// Returns [AgeDuration] with all age components
  static AgeDuration calculateAge({
    required DateTime birthDate,
    DateTime? currentDate,
    String? timezone,
    CalendarSystem calendarSystem = CalendarSystem.gregorian,
    bool includeTime = false,
  }) {
    currentDate ??= DateTime.now();

    // Validate that birth date is not in the future
    if (birthDate.isAfter(currentDate)) {
      throw FutureBirthDateException(
        'Birth date cannot be in the future',
        'FUTURE_BIRTH_DATE',
      );
    }

    // Convert to Gregorian if needed
    DateTime convertedBirthDate =
        CalendarHelper.convertToGregorian(birthDate, calendarSystem);
    DateTime convertedCurrentDate =
        CalendarHelper.convertToGregorian(currentDate, calendarSystem);

    // Apply timezone conversion if specified
    if (timezone != null) {
      if (!TimezoneHelper.isTimezoneSupported(timezone)) {
        throw InvalidTimezoneException(
          'Unsupported timezone: $timezone',
          'UNSUPPORTED_TIMEZONE',
        );
      }
      convertedBirthDate =
          TimezoneHelper.convertToTimezone(convertedBirthDate, timezone);
      convertedCurrentDate =
          TimezoneHelper.convertToTimezone(convertedCurrentDate, timezone);
    }

    // Calculate age components
    int years = convertedCurrentDate.year - convertedBirthDate.year;
    int months = convertedCurrentDate.month - convertedBirthDate.month;
    int days = convertedCurrentDate.day - convertedBirthDate.day;

    // Adjust for negative values
    if (days < 0) {
      months--;
      days += _getDaysInMonth(
        convertedCurrentDate.year,
        convertedCurrentDate.month == 1 ? 12 : convertedCurrentDate.month - 1,
      );
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (includeTime) {
      hours = convertedCurrentDate.hour - convertedBirthDate.hour;
      minutes = convertedCurrentDate.minute - convertedBirthDate.minute;
      seconds = convertedCurrentDate.second - convertedBirthDate.second;

      if (seconds < 0) {
        minutes--;
        seconds += 60;
      }

      if (minutes < 0) {
        hours--;
        minutes += 60;
      }

      if (hours < 0) {
        days--;
        hours += 24;

        // Recalculate days/months if day becomes negative
        if (days < 0) {
          months--;
          days += _getDaysInMonth(
            convertedCurrentDate.year,
            convertedCurrentDate.month == 1
                ? 12
                : convertedCurrentDate.month - 1,
          );

          if (months < 0) {
            years--;
            months += 12;
          }
        }
      }
    }

    // Calculate totals
    Duration totalDuration =
        convertedCurrentDate.difference(convertedBirthDate);
    int totalDays = totalDuration.inDays;
    int totalHours = totalDuration.inHours;
    int totalMinutes = totalDuration.inMinutes;
    int totalSeconds = totalDuration.inSeconds;

    return AgeDuration(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      totalDays: totalDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
    );
  }

  /// Calculates the next birthday date
  ///
  /// [birthDate] The birth date
  /// [currentDate] Optional current date (defaults to DateTime.now())
  /// [calendarSystem] Calendar system to use
  ///
  /// Returns [DateTime] of the next birthday
  static DateTime calculateNextBirthday({
    required DateTime birthDate,
    DateTime? currentDate,
    CalendarSystem calendarSystem = CalendarSystem.gregorian,
  }) {
    currentDate ??= DateTime.now();

    DateTime convertedBirthDate =
        CalendarHelper.convertToGregorian(birthDate, calendarSystem);
    DateTime convertedCurrentDate =
        CalendarHelper.convertToGregorian(currentDate, calendarSystem);

    DateTime nextBirthday = DateTime(
      convertedCurrentDate.year,
      convertedBirthDate.month,
      convertedBirthDate.day,
      convertedBirthDate.hour,
      convertedBirthDate.minute,
      convertedBirthDate.second,
    );

    if (nextBirthday.isBefore(convertedCurrentDate) ||
        nextBirthday.isAtSameMomentAs(convertedCurrentDate)) {
      nextBirthday = DateTime(
        convertedCurrentDate.year + 1,
        convertedBirthDate.month,
        convertedBirthDate.day,
        convertedBirthDate.hour,
        convertedBirthDate.minute,
        convertedBirthDate.second,
      );
    }

    return nextBirthday;
  }

  /// Calculates days until next birthday
  ///
  /// [birthDate] The birth date
  /// [currentDate] Optional current date (defaults to DateTime.now())
  /// [calendarSystem] Calendar system to use
  ///
  /// Returns [int] number of days until next birthday
  static int calculateDaysUntilBirthday({
    required DateTime birthDate,
    DateTime? currentDate,
    CalendarSystem calendarSystem = CalendarSystem.gregorian,
  }) {
    DateTime nextBirthday = calculateNextBirthday(
      birthDate: birthDate,
      currentDate: currentDate,
      calendarSystem: calendarSystem,
    );

    currentDate ??= DateTime.now();
    DateTime convertedCurrentDate =
        CalendarHelper.convertToGregorian(currentDate, calendarSystem);

    return nextBirthday.difference(convertedCurrentDate).inDays;
  }

  /// Gets the zodiac sign based on birth date
  ///
  /// [birthDate] The birth date
  ///
  /// Returns [String] zodiac sign name
  static String getZodiacSign(DateTime birthDate) {
    int month = birthDate.month;
    int day = birthDate.day;

    switch (month) {
      case 1:
        return day <= 19 ? 'Capricorn' : 'Aquarius';
      case 2:
        return day <= 18 ? 'Aquarius' : 'Pisces';
      case 3:
        return day <= 20 ? 'Pisces' : 'Aries';
      case 4:
        return day <= 19 ? 'Aries' : 'Taurus';
      case 5:
        return day <= 20 ? 'Taurus' : 'Gemini';
      case 6:
        return day <= 20 ? 'Gemini' : 'Cancer';
      case 7:
        return day <= 22 ? 'Cancer' : 'Leo';
      case 8:
        return day <= 22 ? 'Leo' : 'Virgo';
      case 9:
        return day <= 22 ? 'Virgo' : 'Libra';
      case 10:
        return day <= 22 ? 'Libra' : 'Scorpio';
      case 11:
        return day <= 21 ? 'Scorpio' : 'Sagittarius';
      case 12:
        return day <= 21 ? 'Sagittarius' : 'Capricorn';
      default:
        return 'Unknown';
    }
  }

  /// Checks if a year is a leap year
  ///
  /// [year] The year to check
  ///
  /// Returns [bool] true if leap year, false otherwise
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  /// Gets the number of days in a specific month
  static int _getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw InvalidDateException('Invalid month: $month', 'INVALID_MONTH');
    }

    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  /// Gets comprehensive age statistics
  ///
  /// [birthDate] The birth date
  /// [currentDate] Optional current date (defaults to DateTime.now())
  /// [calendarSystem] Calendar system to use
  ///
  /// Returns [Map<String, dynamic>] with all age statistics
  static Map<String, dynamic> getAgeStatistics({
    required DateTime birthDate,
    DateTime? currentDate,
    CalendarSystem calendarSystem = CalendarSystem.gregorian,
  }) {
    AgeDuration age = calculateAge(
      birthDate: birthDate,
      currentDate: currentDate,
      calendarSystem: calendarSystem,
      includeTime: true,
    );

    DateTime nextBirthday = calculateNextBirthday(
      birthDate: birthDate,
      currentDate: currentDate,
      calendarSystem: calendarSystem,
    );

    int daysUntilBirthday = calculateDaysUntilBirthday(
      birthDate: birthDate,
      currentDate: currentDate,
      calendarSystem: calendarSystem,
    );

    String zodiacSign = getZodiacSign(birthDate);
    String weekdayBorn = _getWeekdayName(birthDate.weekday);
    bool isLeapYearBorn = isLeapYear(birthDate.year);

    return {
      'age': age.toJson(),
      'nextBirthday': nextBirthday.toIso8601String(),
      'daysUntilBirthday': daysUntilBirthday,
      'zodiacSign': zodiacSign,
      'weekdayBorn': weekdayBorn,
      'isLeapYearBorn': isLeapYearBorn,
      'calendarSystem': calendarSystem.toString(),
      'formattedAges': {
        'full': AgeFormatter.format(age, AgeFormat.full),
        'yearsOnly': AgeFormatter.format(age, AgeFormat.yearsOnly),
        'yearsMonths': AgeFormatter.format(age, AgeFormat.yearsMonths),
        'detailed': AgeFormatter.format(age, AgeFormat.detailed),
        'arabic': AgeFormatter.format(age, AgeFormat.arabic),
        'compact': AgeFormatter.format(age, AgeFormat.compact),
        'precise': AgeFormatter.format(age, AgeFormat.precise),
        'minimal': AgeFormatter.format(age, AgeFormat.minimal),
      }
    };
  }

  /// Gets the weekday name from weekday number
  static String _getWeekdayName(int weekday) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    if (weekday < 1 || weekday > 7) {
      return 'Unknown';
    }
    return weekdays[weekday - 1];
  }

  /// Calculates age difference between two people
  ///
  /// [birthDate1] First person's birth date
  /// [birthDate2] Second person's birth date
  ///
  /// Returns [AgeDuration] representing the age difference
  static AgeDuration calculateAgeDifference({
    required DateTime birthDate1,
    required DateTime birthDate2,
  }) {
    DateTime olderDate =
        birthDate1.isBefore(birthDate2) ? birthDate1 : birthDate2;
    DateTime youngerDate =
        birthDate1.isBefore(birthDate2) ? birthDate2 : birthDate1;

    return calculateAge(birthDate: olderDate, currentDate: youngerDate);
  }

  /// Estimates life expectancy milestone dates
  ///
  /// [birthDate] The birth date
  /// [lifeExpectancy] Expected life span in years (default: 80)
  ///
  /// Returns [Map<String, DateTime>] with milestone dates
  static Map<String, DateTime> calculateLifeMilestones({
    required DateTime birthDate,
    int lifeExpectancy = 80,
  }) {
    return {
      'quarter_life':
          birthDate.add(Duration(days: (lifeExpectancy * 365.25 / 4).round())),
      'half_life':
          birthDate.add(Duration(days: (lifeExpectancy * 365.25 / 2).round())),
      'three_quarter_life': birthDate
          .add(Duration(days: (lifeExpectancy * 365.25 * 0.75).round())),
      'estimated_end':
          birthDate.add(Duration(days: (lifeExpectancy * 365.25).round())),
    };
  }

  /// Calculates what percentage of expected life has been lived
  ///
  /// [birthDate] The birth date
  /// [currentDate] Optional current date (defaults to DateTime.now())
  /// [lifeExpectancy] Expected life span in years (default: 80)
  ///
  /// Returns [double] percentage (0.0 to 1.0)
  static double calculateLifeProgress({
    required DateTime birthDate,
    DateTime? currentDate,
    int lifeExpectancy = 80,
  }) {
    currentDate ??= DateTime.now();
    AgeDuration age =
        calculateAge(birthDate: birthDate, currentDate: currentDate);

    double progress = age.years / lifeExpectancy;
    return progress > 1.0 ? 1.0 : progress;
  }
}
