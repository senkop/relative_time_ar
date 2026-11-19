/// Languages supported by [RelativeTime].
enum RelativeLocale {
  /// English.
  en,

  /// Arabic, with correct singular, dual and plural forms.
  ar,
}

/// Formats how long ago (or how far ahead) a date is.
///
/// ```dart
/// RelativeTime.format(date);                       // 5 minutes ago
/// RelativeTime.format(date, locale: RelativeLocale.ar); // منذ 5 دقائق
/// ```
abstract final class RelativeTime {
  static const _units = [
    (_Unit.year, 365 * 24 * 3600),
    (_Unit.month, 30 * 24 * 3600),
    (_Unit.week, 7 * 24 * 3600),
    (_Unit.day, 24 * 3600),
    (_Unit.hour, 3600),
    (_Unit.minute, 60),
  ];

  /// Formats [date] relative to [now] (defaults to the current time).
  ///
  /// Differences under 45 seconds read "just now". Set [arabicDigits] to
  /// write numbers with Arabic-Indic digits (٠–٩).
  static String format(
    DateTime date, {
    DateTime? now,
    RelativeLocale locale = RelativeLocale.en,
    bool arabicDigits = false,
  }) {
    final diff = (now ?? DateTime.now()).difference(date);
    final future = diff.isNegative;
    final seconds = diff.inSeconds.abs();
    final ar = locale == RelativeLocale.ar;

    if (seconds < 45) return ar ? 'الآن' : 'just now';

    var unit = _Unit.minute;
    var count = 1;
    for (final (u, size) in _units) {
      if (seconds >= size) {
        unit = u;
        count = (seconds / size).round();
        break;
      }
    }
    // Round to the nearest unit, but never show 0.
    if (count < 1) count = 1;

    final phrase = ar
        ? _arabic(unit, count, arabicDigits)
        : _english(unit, count, arabicDigits);
    if (ar) return future ? 'بعد $phrase' : 'منذ $phrase';
    return future ? 'in $phrase' : '$phrase ago';
  }

  static String _english(_Unit unit, int n, bool arabicDigits) {
    final name = unit.name;
    final number = arabicDigits ? toArabicDigits('$n') : '$n';
    return n == 1 ? '$number $name' : '$number ${name}s';
  }

  static String _arabic(_Unit unit, int n, bool arabicDigits) {
    final forms = _arabicForms[unit]!;
    final number = arabicDigits ? toArabicDigits('$n') : '$n';
    if (n == 1) return forms.$1;
    if (n == 2) return forms.$2;
    if (n >= 3 && n <= 10) return '$number ${forms.$3}';
    return '$number ${forms.$4}';
  }

  // (one, two, 3–10, 11+)
  static const _arabicForms = {
    _Unit.minute: ('دقيقة', 'دقيقتين', 'دقائق', 'دقيقة'),
    _Unit.hour: ('ساعة', 'ساعتين', 'ساعات', 'ساعة'),
    _Unit.day: ('يوم', 'يومين', 'أيام', 'يومًا'),
    _Unit.week: ('أسبوع', 'أسبوعين', 'أسابيع', 'أسبوعًا'),
    _Unit.month: ('شهر', 'شهرين', 'أشهر', 'شهرًا'),
    _Unit.year: ('سنة', 'سنتين', 'سنوات', 'سنة'),
  };

  /// Replaces 0–9 in [text] with Arabic-Indic digits ٠–٩.
  static String toArabicDigits(String text) {
    const digits = '٠١٢٣٤٥٦٧٨٩';
    return text.replaceAllMapped(
      RegExp('[0-9]'),
      (m) => digits[m[0]!.codeUnitAt(0) - 48],
    );
  }
}

enum _Unit { minute, hour, day, week, month, year }
