library highlightable;

import 'package:flutter/material.dart';

/// ### Widget which makes easy to highlight any letter/word  you want.
///
/// **Very basic usage:**
///
/// ```dart
/// HighlightText(
///   'Hello World',
///   highlightable: 'hello',
/// ),
/// ```
/// **Custom usage:**
///
/// ```dart
/// HighlightText(
///   "Hello, Flutter!",
///   highlightable: "Flu, He",
///   detectWords: true,
///   caseSensitive: true,
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
  final dynamic highlightable;

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
  /// So that means, then [highlightable] should be like: `"hello", "world"` or `"hello world"`.
  /// And other letters which [highlightable] contains won't be highlighted.
  final bool detectWords;

  /// **Enables case sensitive**
  ///
  /// If it's `true`, then widget enables case sensitive on highlighting functionality.
  /// As default it's `false` so, disabled.
  final bool caseSensitive;

  HighlightText(
    this.actualText, {
    Key? key,
    required this.highlightable,
    this.defaultStyle = const TextStyle(color: Colors.black),
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
    this.detectWords = false,
    this.caseSensitive = false,
  }) : super(key: key);

  @override
  HighlightTextState createState() => HighlightTextState();
}

class HighlightTextState extends State<HighlightText> {
  // A array of [TextSpan]s. Which is used as main [RichText]s children.
  // We append TextSpans from `generateSubStrings` method.
  List<InlineSpan> subStrings = [];

  // List which contains all searchable values by each letter.
  // If the given [highlightable] is String then it will automatically split string one by one,
  // So it'll generate an letter's array which [highlightable] contains.
  List<String> highlightableLetters = [], matchers = [];

  @override
  void initState() {
    filterHighlightable();
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

  // Converts [highlightable] and fills [highlightableLetters] & [matchers].
  void filterHighlightable() {
    if (widget.highlightable is String) {
      // Creates correct pattern appreciate [detectWords].
      var splitPattern = widget.detectWords ? " " : "";

      highlightableLetters = '${widget.highlightable}'.split(splitPattern);

      // Choose split-able matchers appropriate by case sensitive status.
      if (widget.caseSensitive) {
        matchers = widget.highlightable.replaceAll(',', '').split(splitPattern);
        return;
      }

      matchers = widget.highlightable
          .toLowerCase()
          .replaceAll(',', '')
          .split(splitPattern);

      return;
    }

    // Directly append [widget.highlightable] to highlightableLetters.
    // Because it have to be Array. Above we've checked if it's string.
    // So if program had reached here it must to be String.
    highlightableLetters = widget.highlightable;

    // Matcher letters should be splited as lovercase to test matching easily.
    matchers = widget.highlightable.map<String>((String letter) {
      if (widget.caseSensitive) return letter.replaceAll(',', '');
      return letter.toLowerCase().replaceAll(',', '');
    }).toList();
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

    // We create "actual" list, because we have to highlight the original text (So [widget.actualText]).
    var actual = widget.actualText.split(' ');

    for (var i = 0; i < actual.length; i++) {
      addRightSpan(actual[i], findMatcherLetters(actual[i]));
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
      final String l = actual[i];

      // Just determine it matchs or not and append appreciate [TextStyle];
      TextStyle style = widget.defaultStyle;

      bool condition = false;
      if (widget.caseSensitive) {
        condition = mtch.contains(l);
      } else {
        condition = mtch.contains(l.toLowerCase());
      }

      if (condition && l != ' ') style = widget.highlightStyle;

      addStr(l, style);
    }
  }

  // Function which finds and returns found matcher.
  List<String> findMatcherLetters(String actual) {
    var matcher = matchers.where(
      (m) {
        if (widget.caseSensitive) return actual.contains(m);
        return actual.toLowerCase().contains(m.toLowerCase());
      },
    );

    if ('$matcher' == '()') return []; // Means couldn't found matcher.
    return '$matcher'.replaceAll('(', '').replaceAll(')', '').split('');
  }

  @override
  Widget build(BuildContext context) {
    // If [highlightableLetters] is empty that means we haven't any matcher.
    // So just return pure [Text] widget
    if (highlightableLetters.isEmpty) {
      return Text(widget.actualText, style: widget.defaultStyle);
    }

    return RichText(
      text: TextSpan(text: '', children: subStrings),
    );
  }
}
