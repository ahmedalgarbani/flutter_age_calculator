import 'age_duration.dart';

/// Available formatting options for age display
enum AgeFormat {
  /// Full format: "25 years, 6 months, 15 days"
  full,
  
  /// Years only: "25 years"
  yearsOnly,
  
  /// Years and months: "25y 6m"
  yearsMonths,
  
  /// Detailed format with hours: "Years: 25, Months: 6, Days: 15, Hours: 8"
  detailed,
  
  /// Arabic format: "25 سنة و 6 شهر و 15 يوم"
  arabic,
  
  /// Compact format: "25y" or "6m" or "15d"
  compact,
  
  /// Precise format with all components: "25y 6m 15d 8h 30min 45s"
  precise,
  
  /// Minimal format: "25"
  minimal,
}

/// Utility class for formatting age durations in various formats and languages
class AgeFormatter {
  /// Formats an AgeDuration according to the specified format
  /// 
  /// [age] The AgeDuration to format
  /// [format] The desired output format
  /// [locale] Optional locale for localization (currently supports 'ar' for Arabic)
  static String format(AgeDuration age, AgeFormat format, {String? locale}) {
    switch (format) {
      case AgeFormat.full:
        return _formatFull(age, locale);
      case AgeFormat.yearsOnly:
        return _formatYearsOnly(age, locale);
      case AgeFormat.yearsMonths:
        return _formatYearsMonths(age, locale);
      case AgeFormat.detailed:
        return _formatDetailed(age, locale);
      case AgeFormat.arabic:
        return _formatArabic(age);
      case AgeFormat.compact:
        return _formatCompact(age);
      case AgeFormat.precise:
        return _formatPrecise(age, locale);
      case AgeFormat.minimal:
        return _formatMinimal(age);
    }
  }
  
  /// Formats age in full format: "25 years, 6 months, 15 days"
  static String _formatFull(AgeDuration age, String? locale) {
    List<String> parts = [];
    
    if (age.years > 0) {
      String yearText = _pluralize(age.years, 'year', 'years', locale);
      parts.add('${age.years} $yearText');
    }
    
    if (age.months > 0) {
      String monthText = _pluralize(age.months, 'month', 'months', locale);
      parts.add('${age.months} $monthText');
    }
    
    if (age.days > 0) {
      String dayText = _pluralize(age.days, 'day', 'days', locale);
      parts.add('${age.days} $dayText');
    }
    
    if (parts.isEmpty) {
      return locale == 'ar' ? 'أقل من يوم' : 'Less than a day';
    }
    
    String separator = locale == 'ar' ? ' و ' : ', ';
    return parts.join(separator);
  }
  
  /// Formats age showing years only: "25 years"
  static String _formatYearsOnly(AgeDuration age, String? locale) {
    if (age.years == 0) {
      return locale == 'ar' ? 'أقل من سنة' : 'Less than a year';
    }
    
    String yearText = _pluralize(age.years, 'year', 'years', locale);
    return '${age.years} $yearText';
  }
  
  /// Formats age in compact years/months format: "25y 6m"
  static String _formatYearsMonths(AgeDuration age, String? locale) {
    if (locale == 'ar') {
      return '${age.years}س ${age.months}ش';
    }
    return '${age.years}y ${age.months}m';
  }
  
  /// Formats age with detailed information including hours
  static String _formatDetailed(AgeDuration age, String? locale) {
    if (locale == 'ar') {
      return 'السنوات: ${age.years}، الشهور: ${age.months}، الأيام: ${age.days}، الساعات: ${age.hours}';
    }
    return 'Years: ${age.years}, Months: ${age.months}, Days: ${age.days}, Hours: ${age.hours}';
  }
  
  /// Formats age in Arabic: "25 سنة و 6 شهر و 15 يوم"
  static String _formatArabic(AgeDuration age) {
    List<String> parts = [];
    
    if (age.years > 0) {
      String yearText = _getArabicUnit(age.years, 'سنة', 'سنة', 'سنوات');
      parts.add('${_convertToArabicNumerals(age.years)} $yearText');
    }
    
    if (age.months > 0) {
      String monthText = _getArabicUnit(age.months, 'شهر', 'شهر', 'أشهر');
      parts.add('${_convertToArabicNumerals(age.months)} $monthText');
    }
    
    if (age.days > 0) {
      String dayText = _getArabicUnit(age.days, 'يوم', 'يوم', 'أيام');
      parts.add('${_convertToArabicNumerals(age.days)} $dayText');
    }
    
    if (parts.isEmpty) {
      return 'أقل من يوم';
    }
    
    return parts.join(' و ');
  }
  
  /// Formats age in compact format: "25y" or "6m" or "15d"
  static String _formatCompact(AgeDuration age) {
    if (age.years > 0) return '${age.years}y';
    if (age.months > 0) return '${age.months}m';
    return '${age.days}d';
  }
  
  /// Formats age with precise time components: "25y 6m 15d 8h 30min 45s"
  static String _formatPrecise(AgeDuration age, String? locale) {
    List<String> parts = [];
    
    if (age.years > 0) parts.add('${age.years}y');
    if (age.months > 0) parts.add('${age.months}m');
    if (age.days > 0) parts.add('${age.days}d');
    if (age.hours > 0) parts.add('${age.hours}h');
    if (age.minutes > 0) parts.add('${age.minutes}min');
    if (age.seconds > 0) parts.add('${age.seconds}s');
    
    if (parts.isEmpty) return '0s';
    
    return parts.join(' ');
  }
  
  /// Formats age showing only the number: "25"
  static String _formatMinimal(AgeDuration age) {
    return age.years.toString();
  }
  
  /// Helper method to handle pluralization
  static String _pluralize(int count, String singular, String plural, String? locale) {
    if (locale == 'ar') {
      // Arabic pluralization is handled separately
      return singular;
    }
    return count == 1 ? singular : plural;
  }
  
  /// Gets appropriate Arabic unit based on count
  static String _getArabicUnit(int count, String singular, String dual, String plural) {
    if (count == 1) return singular;
    if (count == 2) return dual;
    if (count >= 3 && count <= 10) return plural;
    return singular; // For 11+ in Arabic
  }
  
  /// Converts Western numerals to Arabic numerals
  static String _convertToArabicNumerals(int number) {
    const Map<String, String> arabicNumerals = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    
    String result = number.toString();
    arabicNumerals.forEach((western, arabic) {
      result = result.replaceAll(western, arabic);
    });
    
    return result;
  }
  
  /// Formats age for social media posts
  static String formatForSocial(AgeDuration age, {String? platform}) {
    switch (platform?.toLowerCase()) {
      case 'twitter':
        return '🎂 ${age.years} years old! #Birthday #Age';
      case 'instagram':
        return '🎉 Celebrating ${age.years} years of life! ✨ #${age.years}YearsOld #Birthday';
      case 'facebook':
        return 'Today marks ${age.years} years, ${age.months} months, and ${age.days} days of my journey! 🎂';
      default:
        return format(age, AgeFormat.full);
    }
  }
  
  /// Formats age for professional contexts
  static String formatProfessional(AgeDuration age) {
    return '${age.years} years of age';
  }
  
  /// Formats age with upcoming birthday information
  static String formatWithBirthday(AgeDuration age, int daysUntilBirthday) {
    String baseAge = format(age, AgeFormat.full);
    
    if (daysUntilBirthday == 0) {
      return '$baseAge 🎂 (Birthday today!)';
    } else if (daysUntilBirthday == 1) {
      return '$baseAge (Birthday tomorrow!)';
    } else {
      return '$baseAge (Birthday in $daysUntilBirthday days)';
    }
  }
  
  /// Formats total time lived in a human-readable way
  static String formatTotalTimeLived(AgeDuration age) {
    return 'You have lived for ${age.totalDays} days, ${age.totalHours} hours, and ${age.totalMinutes} minutes!';
  }
}