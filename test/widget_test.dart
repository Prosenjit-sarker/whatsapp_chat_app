// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_clone/main.dart';

void main() {
  testWidgets('app builds and initializes without error', (WidgetTester tester) async {
    await tester.pumpWidget(const WhatsAppCloneApp());

    // Just verify the app doesn't crash during initialization
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
