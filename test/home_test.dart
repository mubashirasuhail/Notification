import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification/home.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders app-bar location', (tester) async {
      await tester.pumpWidget(const _TestApp(child: HomePage()));
      expect(find.textContaining('ABCD, New Delhi'), findsOneWidget);
    });

    testWidgets('search field hint is shown', (tester) async {
      await tester.pumpWidget(const _TestApp(child: HomePage()));
      expect(find.text('Search for products/stores'), findsOneWidget);
    });

    testWidgets('category grid has 8 items', (tester) async {
      await tester.pumpWidget(const _TestApp(child: HomePage()));
      expect(find.byType(Image), findsNWidgets(9)); // 8 categories + 1 price-tag icon
    });
  });
}

class _TestApp extends StatelessWidget {
  final Widget child;
  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: child));
  }
}