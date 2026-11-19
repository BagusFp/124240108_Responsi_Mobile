import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/pages/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Login page displays title and inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify Title Hydra Games
    expect(find.text('Hydra Games'), findsOneWidget);

    // Verify TextField presence (email & password)
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Login page shows error on empty inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Email dan Password tidak boleh kosong!'), findsOneWidget);
  });
}
