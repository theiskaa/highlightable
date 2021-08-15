library highlightable;

import 'package:flutter/material.dart';

/// ### Widget which makes easy to highlight any letter/word  you want.
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
///   "Hello, Flutter!",
///   detectWords: true,
///   highlightableWord: "flu, He",
///   defaultStyle: TextStyle(
///     fontSize: 25,
///     color: Colors.black,
///     fontWeight: FontWeight.bold,
///   ),
///   highlightStyle: TextStyle(
///     fontSize: 25,
///     letterSpacing: 2.5,
///     color: Colors.white,
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

  /// **Changes widget's highlightable letters rendering function.**
  ///
  /// If it's `true` then widget will highlight only given concrete words.
  ///
  /// So that means, then [highlightableWord] should be like: `"hello", "world"` or `"hello world"`.
  /// And other letters which [highlightableWord] contains won't be highlighted.
  final bool detectWords;

  HighlightText(
    this.actualText, {
    Key? key,
    required this.highlightableWord,
    this.defaultStyle = const TextStyle(color: Colors.black),
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
    this.detectWords = false,
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

  // Just checks if given string/letter is upper cased or not.
  bool isUpperCase(l) => l.toUpperCase() == l;

  // Generates new TextSpan and adds it to subStrings list.
  void addStr(String str, [TextStyle? style]) {
    var span = TextSpan(text: str, style: style ?? widget.defaultStyle);
    subStrings.add(span);
  }

  // Converts [highlightableWord] and fills [highlightableLetters] & [matchers].
  void filterHighlightableWord() {
    if (widget.highlightableWord is String) {
      // Creates correct pattern appreciate [detectWords].
      var splitPattern = widget.detectWords ? " " : "";

      highlightableLetters = '${widget.highlightableWord}'.split(splitPattern);

      // Matchers should be splited as lovercase to test matching easily.
      matchers = '${widget.highlightableWord}'
          .toLowerCase()
          .replaceAll(',', '')
          .split(splitPattern);

      return;
    }

    // Directly append [widget.highlightableWord] to highlightableLetters.
    // Because it have to be Array. Above we've checked if it's string.
    // So if program had reached here it must to be String.
    highlightableLetters = widget.highlightableWord;

    // Matcher letters should be splited as lovercase to test matching easily.
    matchers = widget.highlightableWord
        .map<String>((l) => '$l'.toLowerCase().replaceAll(',', ''))
        .toList();
  }

  // Generates [TextSpan]'s for main [RichText] - appreciate [detectWords].
  void generateSubStrings() {
    if (highlightableLetters.isEmpty) return;

    // When need to highligh all letters what matchers includes
    if (!widget.detectWords) {
      addRightSpan(widget.actualText, matchers);
      setState(() {});
      return;
    }

    // We create "actual" list, because we have to highligh the original text (So [widget.actualText]).
    var actual = '${widget.actualText}'.split(" ");

    for (var i = 0; i < actual.length; i++) {
      addRightSpan(actual[i].toString(), findMatcherLetters(actual[i]));
      addStr(' ');
    }

    // We shouldn't pass methods/functions into setState.
    // So that's why our setState was had left blank.
    setState(() {});
  }

  // Basicaly, we use [addRightSpan] function to highlight concrete word.
  // Loops through given actual and looks if current index value of actual are, or not in matchers list.
  void addRightSpan(dynamic actual, dynamic mtch) {
    for (var i = 0; i < actual.length; i++) {
      String l = actual[i];

      // Just determine it matchs or not and append appreciate [TextStyle];
      TextStyle style = widget.defaultStyle;

      style = (mtch.contains(l.toLowerCase()) && l != ' ')
          ? widget.highlightStyle
          : widget.defaultStyle;

      addStr(l, style);
    }
  }

  // Function which finds and returns found matcher.
  List<String> findMatcherLetters(dynamic actual) {
    var matcher = matchers.where(
      (m) => actual.toString().toLowerCase().contains(m.toLowerCase()),
    );

    if ('$matcher' == '()') return []; // Means couldn't found matcher
    return '$matcher'.replaceAll('(', '').replaceAll(')', '').split('');
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
