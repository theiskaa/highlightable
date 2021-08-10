library highlightable;

import 'package:flutter/material.dart';

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

  HighlightText(
    this.actualText, {
    Key? key,
    required this.highlightableWord,
    this.defaultStyle = const TextStyle(color: Colors.white),
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    ),
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
  List<String> highlightableLetters = [];

  @override
  void initState() {
    if (widget.highlightableWord is String) {
      highlightableLetters = widget.highlightableWord.toString().split("");
    } else {
      highlightableLetters = widget.highlightableWord;
    }
    generateSubStrings();
    super.initState();
  }

  void generateSubStrings() {
    if (highlightableLetters.isEmpty) return;
    
    for (var i = 0; i < widget.actualText.length; i++) {
      var l = widget.actualText[i];

      // Just determine it matchs or not and append appreciate [TextStyle];
      TextStyle rightStyle = highlightableLetters.contains(l)
          ? widget.highlightStyle
          : widget.defaultStyle;

      subStrings.add(TextSpan(text: l, style: rightStyle));

      // We shouldn't pass methods/functions into setState.
      // So that's why our setState was left blank.
      setState(() {});
    }
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
