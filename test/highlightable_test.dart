import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highlightable/highlightable.dart';

void main() {
  const actualText = "Hello, World!";
  const highlightableWord = 'hello', emptyHighlightableWord = <String>[];

  late HighlightText highlightText, highlightText2, highlightText3;
  late MaterialApp mainWidget, mainWidget2, mainWidget3;

  setUpAll(() {
    // Setup first HighlightText widget. Which will test default highlighted text.
    highlightText = HighlightText(
      actualText,
      highlightableWord: highlightableWord,
    );

    // Setup second HighlightText widget. Which will test widget with empty [highlightableWord].
    highlightText2 = HighlightText(
      actualText,
      highlightableWord: emptyHighlightableWord,
    );

    // Setup third HighlightText widget. Which will test word detecting.
    highlightText3 = HighlightText(
      actualText,
      highlightableWord: highlightableWord,
      detectWords: true,
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
  });
}
