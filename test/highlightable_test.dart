import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highlightable/highlightable.dart';

void main() {
  const actualText = "Hello World!";
  const highlightableWord = 'hello', emptyHighlightableWord = <String>[];

  late HighlightText highlightText, highlightText2;
  late MaterialApp mainWidget, mainWidget2;

  setUpAll(() {
    // Setup first HighlightText widget. Which will test default highlighted text.
    highlightText = HighlightText(
      actualText,
      highlightableWord: highlightableWord,
    );

    // Setup second HighlightText widget. Which will test widget with empty highlightableWord.
    highlightText2 = HighlightText(
      actualText,
      highlightableWord: emptyHighlightableWord,
    );

    mainWidget = MaterialApp(
      title: 'Test of HighlightText',
      home: Scaffold(body: highlightText),
    );

    mainWidget2 = MaterialApp(
      title: 'Second test of HighlightText',
      home: Scaffold(body: highlightText2),
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
          expect(
            state.subStrings[i].style!,
            state.highlightableLetters.contains(actualText[i])
                ? highlightText.highlightStyle
                : highlightText.defaultStyle,
          );
        }
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
  });
}
