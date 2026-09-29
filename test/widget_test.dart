import 'package:flutter_test/flutter_test.dart';
import 'package:imdhades/widgets/fire_loader.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('FireLoader renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Center(child: FireLoader())),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(FireLoader), findsOneWidget);
  });
}
