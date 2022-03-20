import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highlightable/highlightable.dart';

void main() {
  late MaterialApp testApp, testApp2;
  late HighlightText highlightText, highlightText2;

  setUpAll(() {
    highlightText = HighlightText(
      'Hello Tests',
      highlight: Highlight(),
      detectWords: true,
    );

    highlightText2 = HighlightText(
      'Numbers: 20, 30, 40 will be highlighted',
      highlight: Highlight(pattern: r'\d', words: ["highlighted"]),
      detectWords: true,
      style: TextStyle(fontSize: 5),
    );

    testApp = MaterialApp(home: Scaffold(body: highlightText));
    testApp2 = MaterialApp(home: Scaffold(body: highlightText2));
  });

  group('[HighlightText]', () {
    testWidgets(
      'should expect Text widget when there is no highlighted data',
      (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        expect(find.byType(Text), findsOneWidget);
      },
    );

    testWidgets(
      'should expect generated text spans appropriate to highlight matchers',
      (WidgetTester tester) async {
        await tester.pumpWidget(testApp2);

        expect(find.byType(RichText), findsOneWidget);
      },
    );
  });
}
