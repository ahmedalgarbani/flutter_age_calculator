/// Supported calendar systems for age calculation
enum CalendarSystem {
  /// Standard Gregorian calendar
  gregorian,

  /// Islamic Hijri calendar
  hijri,

  /// Persian/Jalali calendar
  persian,

  /// Buddhist calendar
  buddhist,

  /// Hebrew calendar
  hebrew,
}

/// Helper class for calendar system conversions
class CalendarHelper {
  /// Converts a date from any supported calendar system to Gregorian
  static DateTime convertToGregorian(DateTime date, CalendarSystem from) {
    switch (from) {
      case CalendarSystem.gregorian:
        return date;
      case CalendarSystem.hijri:
        return _hijriToGregorian(date);
      case CalendarSystem.persian:
        return _persianToGregorian(date);
      case CalendarSystem.buddhist:
        return _buddhistToGregorian(date);
      case CalendarSystem.hebrew:
        return _hebrewToGregorian(date);
    }
  }

  /// Converts Hijri date to Gregorian
  /// This is a simplified approximation - for production use, implement precise conversion
  static DateTime _hijriToGregorian(DateTime hijriDate) {
    int year = hijriDate.year;
    int month = hijriDate.month;
    int day = hijriDate.day;

    // Simplified conversion using average year lengths
    // Hijri year ≈ 354.37 days, Gregorian year ≈ 365.25 days
    // This is an approximation - use proper astronomical calculations for precision
    double gregorianYear = ((year - 1) * 354.37) / 365.25 + 622;
    int targetYear = gregorianYear.round();

    // Adjust for month and day
    double dayOfYear =
        ((month - 1) * 29.53) + day; // Average Hijri month ≈ 29.53 days
    int adjustedDay = (dayOfYear * 365.25 / 354.37).round();

    DateTime baseDate = DateTime(targetYear, 1, 1);
    return baseDate.add(Duration(days: adjustedDay - 1));
  }

  /// Converts Persian date to Gregorian
  /// Simplified conversion - Persian new year starts around March 21
  static DateTime _persianToGregorian(DateTime persianDate) {
    int persianYear = persianDate.year;
    int persianMonth = persianDate.month;
    int persianDay = persianDate.day;

    // Persian year starts around March 21 of Gregorian calendar
    int gregorianYear = persianYear + 621;

    // Approximate conversion - first 6 months have 31 days, next 5 have 30 days, last has 29/30
    int dayOfYear = 0;
    if (persianMonth <= 6) {
      dayOfYear = (persianMonth - 1) * 31 + persianDay;
    } else if (persianMonth <= 11) {
      dayOfYear = 6 * 31 + (persianMonth - 7) * 30 + persianDay;
    } else {
      dayOfYear = 6 * 31 + 5 * 30 + persianDay;
    }

    // Persian new year is approximately March 21
    DateTime newYear = DateTime(gregorianYear, 3, 21);
    return newYear.add(Duration(days: dayOfYear - 1));
  }

  /// Converts Buddhist date to Gregorian
  /// Buddhist era is 543 years ahead of Common Era
  static DateTime _buddhistToGregorian(DateTime buddhistDate) {
    return DateTime(
      buddhistDate.year - 543,
      buddhistDate.month,
      buddhistDate.day,
      buddhistDate.hour,
      buddhistDate.minute,
      buddhistDate.second,
    );
  }

  /// Converts Hebrew date to Gregorian
  /// Hebrew calendar is approximately 3760 years ahead
  static DateTime _hebrewToGregorian(DateTime hebrewDate) {
    // This is a very simplified conversion
    // Real Hebrew calendar conversion requires complex calculations
    return DateTime(
      hebrewDate.year - 3760,
      hebrewDate.month,
      hebrewDate.day,
      hebrewDate.hour,
      hebrewDate.minute,
      hebrewDate.second,
    );
  }

  /// Gets the display name for a calendar system
  static String getCalendarName(CalendarSystem calendar) {
    switch (calendar) {
      case CalendarSystem.gregorian:
        return 'Gregorian';
      case CalendarSystem.hijri:
        return 'Hijri';
      case CalendarSystem.persian:
        return 'Persian';
      case CalendarSystem.buddhist:
        return 'Buddhist';
      case CalendarSystem.hebrew:
        return 'Hebrew';
    }
  }

  /// Gets all available calendar systems
  static List<CalendarSystem> getAllCalendars() {
    return CalendarSystem.values;
  }
}
