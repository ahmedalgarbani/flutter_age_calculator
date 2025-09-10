/// Advanced Age Calculator Library
///
/// A comprehensive age calculation package for Flutter applications that provides:
/// - Multi-calendar system support (Gregorian, Hijri, Persian, Buddhist, Hebrew)
/// - Timezone-aware calculations
/// - Multiple output formats including Arabic localization
/// - Birthday and zodiac sign calculations
/// - Comprehensive age statistics
///
/// Example usage:
/// ```dart
/// import 'package:flutter_age_calculator/flutter_age_calculator.dart';
///
/// void main() {
///   final birthDate = DateTime(1990, 5, 15);
///   final age = AdvancedAgeCalculator.calculateAge(birthDate: birthDate);
///   print(age.years); // Current age in years
/// }
/// ```
library;

// Core exports
export 'src/age_calculator.dart';
export 'src/age_duration.dart';
export 'src/calendar_system.dart';
export 'src/timezone_helper.dart';
export 'src/age_formatter.dart';

// Exception exports
export 'src/exceptions/age_calculator_exceptions.dart';
