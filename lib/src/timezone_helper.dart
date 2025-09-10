import 'exceptions/age_calculator_exceptions.dart';

/// Helper class for timezone conversions and calculations
class TimezoneHelper {
  /// Map of supported timezones with their UTC offsets in hours
  static const Map<String, int> _timezoneOffsets = {
    'UTC': 0,
    'GMT': 0,
    'EST': -5,    // Eastern Standard Time
    'EDT': -4,    // Eastern Daylight Time
    'CST': -6,    // Central Standard Time
    'CDT': -5,    // Central Daylight Time
    'MST': -7,    // Mountain Standard Time
    'MDT': -6,    // Mountain Daylight Time
    'PST': -8,    // Pacific Standard Time
    'PDT': -7,    // Pacific Daylight Time
    'JST': 9,     // Japan Standard Time
    'KST': 9,     // Korea Standard Time
    'CST_CHINA': 8, // China Standard Time
    'IST': 5,     // India Standard Time (5:30, handled specially)
    'CET': 1,     // Central European Time
    'EET': 2,     // Eastern European Time
    'AST': 3,     // Arabia Standard Time
    'GST': 4,     // Gulf Standard Time
    'PKT': 5,     // Pakistan Standard Time
    'AEST': 10,   // Australian Eastern Standard Time
    'NZST': 12,   // New Zealand Standard Time
  };
  
  /// Special timezone offsets in minutes for zones that don't align to hours
  static const Map<String, int> _specialOffsetMinutes = {
    'IST': 330,   // India Standard Time: UTC+5:30
    'NPT': 345,   // Nepal Time: UTC+5:45
    'MMT': 390,   // Myanmar Time: UTC+6:30
    'ACST': 570,  // Australian Central Standard Time: UTC+9:30
    'MART': 570,  // Marquesas Time: UTC-9:30 (would be -570)
  };
  
  /// Converts a DateTime to a specific timezone
  /// 
  /// [dateTime] The original DateTime
  /// [timezone] The target timezone identifier
  /// Returns the DateTime adjusted for the target timezone
  static DateTime convertToTimezone(DateTime dateTime, String timezone) {
    if (_timezoneOffsets.containsKey(timezone)) {
      int offsetHours = _timezoneOffsets[timezone]!;
      return dateTime.add(Duration(hours: offsetHours));
    } else if (_specialOffsetMinutes.containsKey(timezone)) {
      int offsetMinutes = _specialOffsetMinutes[timezone]!;
      return dateTime.add(Duration(minutes: offsetMinutes));
    } else {
      // Handle unknown timezone gracefully - return original time
      return dateTime;
    }
  }
  
  /// Gets the UTC offset for a timezone in hours
  /// Returns null if timezone is not supported
  static double? getTimezoneOffset(String timezone) {
    if (_timezoneOffsets.containsKey(timezone)) {
      return _timezoneOffsets[timezone]!.toDouble();
    } else if (_specialOffsetMinutes.containsKey(timezone)) {
      return _specialOffsetMinutes[timezone]! / 60.0;
    }
    return null;
  }
  
  /// Gets list of all supported timezone identifiers
  static List<String> getSupportedTimezones() {
    return [
      ..._timezoneOffsets.keys,
      ..._specialOffsetMinutes.keys,
    ];
  }
  
  /// Checks if a timezone is supported
  static bool isTimezoneSupported(String timezone) {
    return _timezoneOffsets.containsKey(timezone) ||
           _specialOffsetMinutes.containsKey(timezone);
  }
  
  /// Gets timezone information including name and offset
  static Map<String, dynamic> getTimezoneInfo(String timezone) {
    double? offset = getTimezoneOffset(timezone);
    if (offset == null) {
      throw InvalidTimezoneException('Unsupported timezone: $timezone');
    }
    
    return {
      'name': timezone,
      'offset': offset,
      'offsetString': _formatOffset(offset),
      'description': _getTimezoneDescription(timezone),
    };
  }
  
  /// Formats UTC offset as string (e.g., "+05:30", "-08:00")
  static String _formatOffset(double offset) {
    if (offset == 0) return '+00:00';
    
    String sign = offset > 0 ? '+' : '-';
    double absOffset = offset.abs();
    int hours = absOffset.floor();
    int minutes = ((absOffset - hours) * 60).round();
    
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  /// Gets human-readable description for timezone
  static String _getTimezoneDescription(String timezone) {
    const Map<String, String> descriptions = {
      'UTC': 'Coordinated Universal Time',
      'GMT': 'Greenwich Mean Time',
      'EST': 'Eastern Standard Time',
      'PST': 'Pacific Standard Time',
      'JST': 'Japan Standard Time',
      'CET': 'Central European Time',
      'AST': 'Arabia Standard Time',
      'IST': 'India Standard Time',
      'AEST': 'Australian Eastern Standard Time',
      'CST_CHINA': 'China Standard Time',
    };
    
    return descriptions[timezone] ?? timezone;
  }
  
  /// Converts between two timezones
  static DateTime convertBetweenTimezones(
    DateTime dateTime,
    String fromTimezone,
    String toTimezone,
  ) {
    if (!isTimezoneSupported(fromTimezone)) {
      throw InvalidTimezoneException('Unsupported source timezone: $fromTimezone');
    }
    if (!isTimezoneSupported(toTimezone)) {
      throw InvalidTimezoneException('Unsupported target timezone: $toTimezone');
    }
    
    // Convert to UTC first, then to target timezone
    double fromOffset = getTimezoneOffset(fromTimezone)!;
    double toOffset = getTimezoneOffset(toTimezone)!;
    
    // Remove source offset to get UTC, then add target offset
    Duration adjustment = Duration(
      minutes: ((toOffset - fromOffset) * 60).round(),
    );
    
    return dateTime.add(adjustment);
  }
  
  /// Gets current UTC offset for the system's local timezone
  static Duration get localTimezoneOffset {
    return DateTime.now().timeZoneOffset;
  }
  
  /// Checks if a given year observes daylight saving time
  /// This is a simplified check - real implementation would need more complex logic
  static bool isDaylightSavingTime(DateTime dateTime, String timezone) {
    // Simplified DST check for US timezones
    if (['EST', 'CST', 'MST', 'PST'].contains(timezone)) {
      // DST typically runs from second Sunday in March to first Sunday in November
      int year = dateTime.year;
      
      // Second Sunday in March
      DateTime marchSecondSunday = _getNthSunday(year, 3, 2);
      // First Sunday in November  
      DateTime novemberFirstSunday = _getNthSunday(year, 11, 1);
      
      return dateTime.isAfter(marchSecondSunday) && 
             dateTime.isBefore(novemberFirstSunday);
    }
    
    return false; // Default to no DST for other timezones
  }
  
  /// Helper method to get the Nth Sunday of a given month and year
  static DateTime _getNthSunday(int year, int month, int n) {
    DateTime firstDay = DateTime(year, month, 1);
    int firstSunday = 7 - firstDay.weekday % 7 + 1;
    return DateTime(year, month, firstSunday + (n - 1) * 7);
  }
}