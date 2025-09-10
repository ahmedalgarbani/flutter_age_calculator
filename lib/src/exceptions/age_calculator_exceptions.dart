/// Custom exceptions for the Advanced Age Calculator package
library exceptions;

/// Base exception class for all age calculator errors
abstract class AgeCalculatorException implements Exception {
  /// Error message
  final String message;

  /// Optional error code
  final String? code;

  const AgeCalculatorException(this.message, [this.code]);

  @override
  String toString() =>
      'AgeCalculatorException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when an invalid date is provided
class InvalidDateException extends AgeCalculatorException {
  const InvalidDateException(String message, [String? code])
      : super(message, code);

  @override
  String toString() =>
      'InvalidDateException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when an unsupported calendar system is used
class UnsupportedCalendarException extends AgeCalculatorException {
  const UnsupportedCalendarException(String message, [String? code])
      : super(message, code);

  @override
  String toString() =>
      'UnsupportedCalendarException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when an invalid timezone is provided
class InvalidTimezoneException extends AgeCalculatorException {
  const InvalidTimezoneException(String message, [String? code])
      : super(message, code);

  @override
  String toString() =>
      'InvalidTimezoneException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when future birth dates are provided
class FutureBirthDateException extends AgeCalculatorException {
  const FutureBirthDateException(String message, [String? code])
      : super(message, code);

  @override
  String toString() =>
      'FutureBirthDateException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when date calculation results in invalid values
class CalculationException extends AgeCalculatorException {
  const CalculationException(String message, [String? code])
      : super(message, code);

  @override
  String toString() =>
      'CalculationException: $message${code != null ? ' (Code: $code)' : ''}';
}
