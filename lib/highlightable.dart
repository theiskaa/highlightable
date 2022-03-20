library highlight;

import 'package:flutter/material.dart';
import 'package:highlightable/highlight_model.dart';

export 'package:highlightable/highlight_model.dart';

// Highlight mode of widget, used as private value.
// It isn't available for public API.
enum _Mode { on, off }

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

  /// The highlight searching model. Has two options:
  ///  ╰─▶ [Pattern] - A regex pattern that would work for each char of [data].
  ///  ╰─▶ [Words] - A list of highlightable words/letters.
  ///
  /// Example
  /// ```dart
  /// HighlightText(
  ///   highlight: Highlight(
  ///     pattern: r'\d', // Highlight each number in [data].
  ///     words: ['number', ...], // Highlight defined words in [data].
  ///   ),
  ///   ...
  /// )
  /// ```
  final Highlight highlight;

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

  /// Enables only-word detection.
  /// It wouldn't highlight [matcher], if it's just a char.
  /// ╰─> {length == 1}.
  ///
  /// If unset, defaults to the ─▶ [false].
  final bool detectWords;

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
    this.detectWords = false,
  }) : super(key: key);

  @override
  _HighlightTextState createState() => _HighlightTextState();
}

class _HighlightTextState extends State<HighlightText> {
  List<InlineSpan> _spans = [];

  // Main method that used to generate text splans.
  // Compares [data] to [highlight] to catch highlightable and non-highlightable
  // words/letters, which would be the "NEXT" text-span's text data.
  void parse() {
    // Clear splans before generating.
    _spans.clear();

    String hp = '';

    // Creates a span with [highlight-part] and [highlight-mode].
    final cutHP = (_Mode mode) {
      createSpan(hp, mode);
      hp = '';
    };

    for (var i = 0; i < widget.data.length; i++) {
      final el = widget.data[i];

      // Directly add element to
      // highlight-part when it's empty.
      if (hp.isEmpty) {
        hp += el;
        continue;
      }

      // Cut [highlight-part] as [highlight-mode-off].
      if (isMatches(el) && !isMatches(hp)) {
        cutHP(_Mode.off);
        // Cut [highlight-part] as [highlight-mode-on].
      } else if (!isMatches(el) && isMatches(hp)) {
        final isNotDetectable = widget.detectWords && hp.length == 1;
        cutHP(isNotDetectable ? _Mode.off : _Mode.on);
      }

      hp += el;

      // Finish cutting highlight-part.
      if (hp.isNotEmpty && i == widget.data.length - 1) {
        // Determine mode by matching of [element] and [highlight-part]+[element].
        final mode = isMatches(el) && isMatches(hp + el) ? _Mode.on : _Mode.off;
        cutHP(mode);
      }
    }
  }

  // [InlineSpan] generator.
  // Generates a text span appropriate by given data and mode.
  //
  // Mode determines the style of generated text-span.
  // If mode is on, text-span's style would be [highlightStyle].
  // If not, style would be (default)[style].
  void createSpan(String data, _Mode mode) {
    final textSpan = TextSpan(
      text: data,
      style: (mode == _Mode.on) ? widget.highlightStyle : widget.style,
    );

    _spans.add(textSpan);
  }

  // Matching checker for [parse] method.
  // Would be used to check matching of one letter or split word.
  bool isMatches(String data) {
    final h = widget.highlight;

    // Ignore case sensitive.
    if (!widget.caseSensitive) data = data.toLowerCase();

    // Check matching by pattern.
    if (h.pattern != null && RegExp(h.pattern!).hasMatch(data)) {
      return true;
    }

    // Check matching by words/words.
    if (h.words != null && h.words!.isNotEmpty) {
      for (var i = 0; i < h.words!.length; i++) {
        var word = h.words![i];

        // Ignore case sensitive.
        if (!widget.caseSensitive) word = word.toLowerCase();

        if (word.contains(data) || data.contains(word)) return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Execute [parse] in each build
    // i.e -> [hot-reload].
    parse();

    // Build the default text, if there is no spans.
    if (_spans.isEmpty) return Text(widget.data, style: widget.style);

    // Build the highlighted text with rich-text.
    return RichText(text: TextSpan(text: '', children: _spans));
  }
}
