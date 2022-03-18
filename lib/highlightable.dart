library highlight;

import 'package:flutter/material.dart';

/// [HighlightText] is a [Text] widget alternative, that makes it easy to highlight
/// concrete words, defined from [pattern] or from [pure string].
///
///  For Example:
/// ╭───────────╮
/// │ Data      │──▶ Hello, World
/// │ Highlight │──▶ World
/// ╰───────────╯
///  ... TODO: Resume drawing diagram
///          
class HighlightText extends StatefulWidget {
  /// The default string data.
  /// Like [Text] widget's first required value.
  ///
  /// For Example: When you use [Text] widget then you must to provide a string there.
  /// So, [HighlightText]'s [data] and normal [Text]'s [data] is absolutely same.
  ///
  /// Note: highlighting algorithm would search values inside that [data].
  final String data;

  /// The highlight-matching pattern or highlightable text.
  /// 
  /// An example of highlightable text:
  /// ```dart
  /// HighlightText(
  ///   highlight: 'hello world',
  ///   ...
  /// )
  /// ```
  final dynamic highlight;

  /// The text style for the text which wouldn't be highlighted.
  ///
  /// It's the style of [data] string,
  /// Would be appended to [non-highlight-matcher] values, from [data].
  final TextStyle style;

  /// The text style for the words/letters which would be highlighted.
  ///
  /// It's the style of [highlight] string,
  /// Would be appended to [highlight-matcher] values, from [data].
  final TextStyle highlightStyle;

  /// Enables case sensitive of parsing algorithm.
  ///
  /// If unset, defaults to the ─▶ [false].
  final bool caseSensitive;

  const HighlightText(
    this.data, {
    Key? key,
    required this.highlight,
    this.style = const TextStyle(),
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
    this.caseSensitive = false,
  }) : super(key: key);

  @override
  _HighlightTextState createState() => _HighlightTextState();
}

class _HighlightTextState extends State<HighlightText> {
  List<InlineSpan> _spans = [];

  @override
  Widget build(BuildContext context) {
    // Build the default text, if there is no spans.
    if (_spans.isEmpty) return Text(widget.data, style: widget.style);

    // Build the highlighted text with rich-text.
    return RichText(text: TextSpan(text: '', children: _spans));
  }
}
