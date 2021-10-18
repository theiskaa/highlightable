import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highlightable/highlightable.dart';

void main() {
  const actualText = "Hello, World!";
  const highlightableWord = 'hello', emptyHighlightableWord = <String>[];

  late MaterialApp mainWidget, mainWidget2, mainWidget3, mainWidget4;
  late HighlightText highlightText,
      highlightText2,
      highlightText3,
      highlightText4;

  setUpAll(() {
    // Setup first HighlightText widget. Which will test default highlighted text.
    highlightText = HighlightText(
      actualText,
      highlightable: highlightableWord,
    );

    // Setup second HighlightText widget. Which will test widget with empty [highlightableWord].
    highlightText2 = HighlightText(
      actualText,
      highlightable: emptyHighlightableWord,
    );

    // Setup third HighlightText widget. Which will test word detecting.
    highlightText3 = HighlightText(
      actualText,
      highlightable: [highlightableWord],
      detectWords: true,
    );

    // Setup fourth HighlightText widget. Which will test case sensitive.
    highlightText4 = HighlightText(
      actualText,
      // Will generate from 'hello' to 'Hello'
      highlightable: highlightableWord,
      caseSensitive: true,
    );

    mainWidget = MaterialApp(
      title: 'Test of HighlightText',
      home: Scaffold(body: highlightText),
    );

    mainWidget2 = MaterialApp(
      title: 'Second test of HighlightText',
      home: Scaffold(body: highlightText2),
    );

    mainWidget3 = MaterialApp(
      title: 'Third test of HighlightText',
      home: Scaffold(body: highlightText3),
    );

    mainWidget4 = MaterialApp(
      title: 'Fourth test of HighlightText',
      home: Scaffold(body: highlightText4),
    );
  });

  group('[HighlightText]', () {
    testWidgets(
      'test if highlighting works correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(mainWidget);

        HighlightTextState state = tester.state(find.byType(HighlightText));

        expect(find.byType(RichText), findsOneWidget);
        expect(state.subStrings.length, actualText.length);

        // Look at each letter's style if highlighted correctly
        for (var i = 0; i < actualText.length; i++) {
          String l = actualText[i];

          expect(
            state.subStrings[i].style!,
            state.matchers.contains(l.toLowerCase()) && l != ' '
                ? highlightText.highlightStyle
                : highlightText.defaultStyle,
          );
        }

        // A part which tests state's [isUpperCase] function.
        expect(state.isUpperCase('L'), true);
        expect(state.isUpperCase('i'), false);
      },
    );

    testWidgets(
      'test when highlightableWord is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(mainWidget2);

        HighlightTextState state = tester.state(find.byType(HighlightText));

        expect(find.byType(Text), findsOneWidget);
        expect(state.subStrings.length != actualText.length, true);
      },
    );

    testWidgets(
      'test if word detecting and highlighting works correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(mainWidget3);

        HighlightTextState state = tester.state(find.byType(HighlightText));

        // Look at each letter's style if highlighted correctly
        expect(find.byType(RichText), findsOneWidget);
        expect(state.subStrings.length, actualText.length + 1);
      },
    );

    testWidgets(
      'test if highlighting works correctly when case case sensitive was enabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(mainWidget4);

        HighlightTextState state = tester.state(find.byType(HighlightText));

        // Look at each letter's style if highlighted correctly
        expect(find.byType(RichText), findsOneWidget);
        expect(state.subStrings.length, actualText.length);
      },
    );
  });
}
