library highlightable;

import 'package:flutter/material.dart';

/// ### A text widget that makes easy to highlight any letter/word you want.
///
/// **Very basic usage:**
///
/// ```dart
/// HighlightText(
///   'Hello World',
///   highlightableWord: 'hello',
/// ),
/// ```
/// **Custom usage:**
///
/// ```dart
/// HighlightText(
///   'Hello Flutter',
///   highlightableWord: 'hello',
///   defaultStyle: TextStyle(
///     fontSize: 17,
///     color: Colors.black,
///     fontWeight: FontWeight.bold,
///   ),
///   highlightStyle: TextStyle(
///     fontSize: 17,
///     letterSpacing: 2.5,
///     color: Colors.black,
///     backgroundColor: Colors.blue,
///     fontWeight: FontWeight.bold,
///   ),
/// ),
/// ```
class HighlightText extends StatefulWidget {
  /// A string which is default text. Like [Text] widget's first required value.
  ///
  /// For Example: When you use [Text] widget then you must to provide a string there,
  /// However [actualText] and that [Text]'s value are same approach.
  final String actualText;

  /// An property which could be just string or already created (splitted by each letters) array.
  /// It would be used to generate [TextSpan]s for main [RichText].
  ///
  /// To manage highlighted word/letter's style you can use [highlightStyle] property
  final dynamic highlightableWord;

  /// The style for words/letters which gonna be highlighted.
  ///
  /// As default highlighted text's color is blue and fontWeight is bold.
  /// But you can customize it by just setting [highlightStyle] property
  final TextStyle highlightStyle;

  /// The style for words/letters which won't be highlighted.
  ///
  /// Basicaly it is the style of [actualText].
  /// And it automatically will be integrated with non-matcher values.
  final TextStyle defaultStyle;

  /// **Changes widget's highlight rendering function.**
  ///
  /// If it's `true` then widget will highlight only given concrete words.
  ///
  /// So that means, then [highlightableWord] should be like: `"hello", "world"` or `"hello world"`.
  /// And other letters which [highlightableWord] contains won't be highlighted.
  final bool onlyWords;

  HighlightText(
    this.actualText, {
    Key? key,
    required this.highlightableWord,
    this.defaultStyle = const TextStyle(color: Colors.black),
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
    this.onlyWords = false,
  }) : super(key: key);

  @override
  HighlightTextState createState() => HighlightTextState();
}

class HighlightTextState extends State<HighlightText> {
  // A array of [TextSpan]s. Which is used as main [RichText]s children.
  // We append TextSpans from `generateSubStrings` method.
  List<InlineSpan> subStrings = [];

  // List which contains all searchable values by each letter.
  // If the given [highlightableWord] is String then it will automatically split string one by one,
  // So it'll generate an letter's array which [highlightableWord] contains.
  List<String> highlightableLetters = [], matchers = [];

  @override
  void initState() {
    filterHighlightableWord();
    generateSubStrings();
    super.initState();
  }

  // Converts highlightableWord and fills [highlightableLetters] & [matchers].
  void filterHighlightableWord() {
    if (widget.highlightableWord is String) {
      // Creates correct pattern appreciate [onlyWords].
      var splitPattern = widget.onlyWords ? " " : "";

      highlightableLetters = '${widget.highlightableWord}'.split(splitPattern);

      // Matchers should be splited as lovercase to test matching easily.
      matchers =
          '${widget.highlightableWord}'.toLowerCase().split(splitPattern);
      return;
    }

    // Directly append [widget.highlightableWord] to highlightableLetters.
    // Because it have to be Array. Above we've checked if it's string.
    // So if program had reached here it must to be String.
    highlightableLetters = widget.highlightableWord;

    // Matcher letters should be splited as lovercase to test matching easily.
    matchers = widget.highlightableWord
        .map<String>((l) => '$l'.toLowerCase())
        .toList();
  }

  // Just checks if given String/Letter is upper cased or not.
  bool isUpperCase(l) => l.toUpperCase() == l;

  // Generates [TextSpan]'s for main [RichText] - appreciate [onlyWords].
  void generateSubStrings() {
    if (highlightableLetters.isEmpty) return;

    if (widget.onlyWords) {
      // We have actual list, because we have to highligh the original text (So [widget.actualText]).
      var actual = '${widget.actualText}'.split(" ");

      for (var i = 0; i < actual.length; i++) {
        // Matcher could contain less item than actual. So that's why also we have [matched] val.
        // If current index + 1 is equals or less than [matchers.length]; that means,
        // If we try to return matcher's current indexed item we won't get null, So we should return it.
        // Unless return just empty string. Because down below we check if current actual contains or not [matched].
        // When it's empty string then current actual shouldn't contain [matched] anymore.
        // However, It'll add current actual with [widget.defaultStyle].
        var matched = i + 1 <= matchers.length ? matchers[i] : '';

        // If current actual doesn't contain [matched] val.
        // We should add current actual with default style.
        if (!actual[i].toLowerCase().contains(matched)) {
          subStrings.add(TextSpan(text: actual[i], style: widget.defaultStyle));
        } else {
          for (var j = 0; j < actual[i].length; j++) {
            String l = actual[i][j];

            // Just determine it matchs or not and append appreciate [TextStyle];
            TextStyle rightStyle =
                (matched.split('').contains(l.toLowerCase()) && l != ' ')
                    ? widget.highlightStyle
                    : widget.defaultStyle;

            subStrings.add(TextSpan(text: l, style: rightStyle));
          }

          // After each word we have to add a string which contains only one empty space.
          subStrings.add(TextSpan(text: ' ', style: widget.defaultStyle));
        }
      }
    } else {
      for (var i = 0; i < widget.actualText.length; i++) {
        String l = widget.actualText[i];

        // Just determine it matchs or not and append appreciate [TextStyle];
        TextStyle rightStyle = (matchers.contains(l.toLowerCase()) && l != ' ')
            ? widget.highlightStyle
            : widget.defaultStyle;

        subStrings.add(TextSpan(text: l, style: rightStyle));
      }
    }

    // We shouldn't pass methods/functions into setState.
    // So that's why our setState was left blank.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // If [highlightableLetters] is empty that means we haven't any matcher.
    // So just return pure [Text] widget
    if (highlightableLetters.isEmpty) {
      return Text(widget.actualText, style: widget.defaultStyle);
    }

    return RichText(text: TextSpan(text: '', children: subStrings));
  }
}
