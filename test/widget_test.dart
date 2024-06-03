import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:analog_clock/main.dart'; // Import your main.dart file
import '../lib/components/clock_view.dart'; // Adjust the import path as needed


void main() {
  testWidgets('Test if ClockView is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(), // Use HomePage instead of MyApp
    ));

    // Verify that ClockView widget is present.
    expect(find.byType(ClockView), findsOneWidget);
  });
}
