import 'package:meta/meta.dart';

import 'date.dart';
import 'validation.dart';

/// Internal representation of a month (year, month).
///
/// This class is intended for use by this library only.
@immutable
class Month {
  /// Creates a  Month.
  Month(
    this.year,
    this.month,
  ) : assert(isMonthValid(month));

  /// Creates a  Month from [DateTime].
  factory Month.fromDateTime(DateTime dateTime) {
    return Month(
      dateTime.year,
      dateTime.month,
    );
  }

  /// Creates a  Month set to whatever month is today.
  factory Month.now() {
    DateTime now = DateTime.now();
    return Month.fromDateTime(now);
  }

  /// baseYear of this Month.
  final int year;

  /// Month of year of this Month.
  ///
  /// Months are 1-based (1-January, 2-February...).
  final int month;

  int get _monthBase0 => month - 1;

  /// Returns true if this month is before [other] month.
  bool isBefore(Month other) {
    if (year < other.year) {
      return true;
    } else if (year == other.year) {
      return month < other.month;
    } else {
      return false;
    }
  }

  /// Returns true if this month is after [other] month.
  bool isAfter(Month other) {
    if (year > other.year) {
      return true;
    } else if (year == other.year) {
      return month > other.month;
    } else {
      return false;
    }
  }

  /// Returns number of months between this and [other] month.
  int monthsBetween(Month other) {
    int thisFrom0AD = _monthsFrom0AD;
    int otherFrom0AD = other._monthsFrom0AD;

    return otherFrom0AD - thisFrom0AD;
  }

  int get _monthsFrom0AD {
    int r = 0;
    r += year * DateTime.monthsPerYear;

    // if month is after 0 AD, months must be added, but if before they must be subtracted
    if (year >= 0) {
      r += month;
    } else {
      r -= month;
    }

    return r;
  }

  /// Returns a  [Month] with [numOfMonths] added to it.
  Month addMonths(int numOfMonths) {
    int yearChange = numOfMonths ~/ 12;
    int monthChange = (numOfMonths.abs() % 12) * numOfMonths.sign;

    int baseYear = year + yearChange;
    int baseMonth = _monthBase0 + monthChange;
    if (baseMonth > 11) baseYear++;
    if (baseMonth < 0) baseYear--;
    baseMonth = baseMonth % 12;

    return Month(
      baseYear,
      baseMonth + 1,
    );
  }

  /// Returns [Date] that is the first day of this month.
  Date toDateAsFirstDayOfMonth() {
    return Date(year, month, 1);
  }

  /// Returns [Date] that is the last day of this month.
  Date toDateAsLastDayOfMonth() {
    DateTime lastDayOfMonth =
        month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

    return Date.fromDateTime(lastDayOfMonth);
  }

  /// Returns a list of [Date]s one for every day of month.
  List<Date> daysOfMonth() {
    List<Date> dates = <Date>[];

    for (Date date = toDateAsFirstDayOfMonth();
        date.isOfMonth(this);
        date = date.addDays(1)) {
      dates.add(date);
    }

    return dates;
  }

  /// Returns this month as [DateTime].
  ///
  /// Values except year and month are set to default values.
  DateTime toDateTime() {
    return DateTime(year, month);
  }

  @override
  bool operator ==(Object other) {
    if (other is Month) {
      return year == other.year && month == other.month;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  @override
  String toString() {
    return "Month{$year.$month}";
  }
}
