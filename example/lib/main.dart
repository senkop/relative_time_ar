import 'package:flutter/material.dart';
import 'package:relative_time_ar/relative_time_ar.dart';

void main() => runApp(const MaterialApp(home: DemoPage()));

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dates = [
      now.subtract(const Duration(seconds: 20)),
      now.subtract(const Duration(minutes: 2)),
      now.subtract(const Duration(minutes: 7)),
      now.subtract(const Duration(hours: 13)),
      now.subtract(const Duration(days: 3)),
      now.add(const Duration(days: 2)),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('relative_time_ar')),
      body: ListView(
        children: [
          for (final d in dates)
            ListTile(
              title: RelativeTimeText(d),
              trailing: RelativeTimeText(d, locale: RelativeLocale.ar),
            ),
        ],
      ),
    );
  }
}
