import 'dart:async';

import 'package:flutter/widgets.dart';

import 'relative_time.dart';

/// A [Text] that shows [date] as relative time and refreshes itself.
///
/// ```dart
/// RelativeTimeText(message.sentAt, locale: RelativeLocale.ar)
/// ```
class RelativeTimeText extends StatefulWidget {
  /// Creates the text.
  const RelativeTimeText(
    this.date, {
    super.key,
    this.locale = RelativeLocale.en,
    this.arabicDigits = false,
    this.refreshEvery = const Duration(seconds: 30),
    this.style,
    this.textAlign,
    this.clock,
  });

  /// The date to describe.
  final DateTime date;

  /// Language.
  final RelativeLocale locale;

  /// Whether to use Arabic-Indic digits.
  final bool arabicDigits;

  /// How often to refresh.
  final Duration refreshEvery;

  /// Text style.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Returns the current time. Defaults to [DateTime.now]; useful in tests.
  final DateTime Function()? clock;

  @override
  State<RelativeTimeText> createState() => _RelativeTimeTextState();
}

class _RelativeTimeTextState extends State<RelativeTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant RelativeTimeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshEvery != widget.refreshEvery) _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.refreshEvery, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      RelativeTime.format(
        widget.date,
        now: (widget.clock ?? DateTime.now)(),
        locale: widget.locale,
        arabicDigits: widget.arabicDigits,
      ),
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection:
          widget.locale == RelativeLocale.ar ? TextDirection.rtl : null,
    );
  }
}
