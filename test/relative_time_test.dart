import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:relative_time_ar/relative_time_ar.dart';

final now = DateTime(2026, 11, 19, 12);
String en(Duration ago) => RelativeTime.format(now.subtract(ago), now: now);
String ar(Duration ago, {bool digits = false}) => RelativeTime.format(
      now.subtract(ago),
      now: now,
      locale: RelativeLocale.ar,
      arabicDigits: digits,
    );

void main() {
  test('English', () {
    expect(en(const Duration(seconds: 10)), 'just now');
    expect(en(const Duration(minutes: 1)), '1 minute ago');
    expect(en(const Duration(minutes: 5)), '5 minutes ago');
    expect(en(const Duration(hours: 3)), '3 hours ago');
    expect(en(const Duration(days: 1)), '1 day ago');
    expect(en(const Duration(days: 14)), '2 weeks ago');
    expect(en(const Duration(days: 400)), '1 year ago');
    expect(en(const Duration(days: -2)), 'in 2 days');
  });

  test('Arabic singular, dual, plural and 11+', () {
    expect(ar(const Duration(seconds: 5)), 'الآن');
    expect(ar(const Duration(minutes: 1)), 'منذ دقيقة');
    expect(ar(const Duration(minutes: 2)), 'منذ دقيقتين');
    expect(ar(const Duration(minutes: 5)), 'منذ 5 دقائق');
    expect(ar(const Duration(minutes: 15)), 'منذ 15 دقيقة');
    expect(ar(const Duration(days: 2)), 'منذ يومين');
    expect(ar(const Duration(days: 3)), 'منذ 3 أيام');
    expect(ar(const Duration(hours: 11)), 'منذ 11 ساعة');
    expect(ar(const Duration(days: -1)), 'بعد يوم');
  });

  test('Arabic digits', () {
    expect(ar(const Duration(minutes: 5), digits: true), 'منذ ٥ دقائق');
    expect(RelativeTime.toArabicDigits('2026'), '٢٠٢٦');
  });

  testWidgets('RelativeTimeText renders and refreshes', (tester) async {
    var clock = now;
    await tester.pumpWidget(MaterialApp(
      home: RelativeTimeText(
        now.subtract(const Duration(minutes: 5)),
        clock: () => clock,
        refreshEvery: const Duration(seconds: 1),
      ),
    ));
    expect(find.text('5 minutes ago'), findsOneWidget);
    clock = now.add(const Duration(minutes: 5));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('10 minutes ago'), findsOneWidget);
  });
}
