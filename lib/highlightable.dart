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
/// ╭──────╮        Highlight
/// │ Data │       ╭─────────────────────────────────╮
/// ╰──────╯       │ ╭─────────╮   ╭───────────────╮ │
///    │       ╭───│ │ Pattern │ & │ Words/Letters │ │
///    │       │   │ ╰─────────╯   ╰───────────────╯ │
///    │       │   ╰─────────────────────────────────╯
///    ╰───────╯
///        │
///    ╭── ▼ ──╮         ╭─────────────────────────────────╮
///    │ Parser ───▶ ... │ Highlighted Data as Text Widget │
///    ╰───────╯         ╰─────────────────────────────────╯
///
class HighlightText extends StatelessWidget {
  /// The default string data.
  /// Like [Text] widget's first required value.
  ///
  /// For Example: When you use [Text] widget then you must to provide a string there.
  /// So, [HighlightText]'s [data] and normal [Text]'s [data] is absolutely same.
  ///
  /// Note: highlighting algorithm would search values inside that [data].
  final String data;

  /// The highlight searching model. Has two options:
  /// │─▶ [Pattern] - A regex pattern that would work for each char of [data].
  /// ╰─▶ [Words] - A list of highlightable words/letters.
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
  final TextStyle? style;

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

  HighlightText(
    this.data, {
    Key? key,
    required this.highlight,
    this.style,
    this.highlightStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
    this.caseSensitive = false,
    this.detectWords = false,
  }) : super(key: key);

  // The highlight sequence spans.
  // Which's actual [rich-text-widget]'s childrens value.
  final List<InlineSpan> _spans = [];

  // Main method that used to generate text splans.
  // Compares [data] to [highlight] to catch highlightable and non-highlightable
  // words/letters, which would be the "NEXT" text-span's text data.
  void _parse({
    required TextStyle ds,
    required TextStyle hs,
  }) {
    if (_spans.isNotEmpty) _spans.clear();

    if (highlight.words == null && highlight.pattern == null) {
      return;
    }

    // Matching sequence representer.
    String hp = '';

    // Creates a span with [highlight-part] and [highlight-mode].
    void cutHP(_Mode mode) {
      _createSpan(hp, mode, ds: ds, hs: hs);
      hp = '';
    }

    for (var i = 0; i < data.length; i++) {
      if (hp.isEmpty) {
        hp += data[i];
        continue;
      }

      // Cut [highlight-part] as [highlight-mode-off].
      if (_isMatches(data[i]) && !_isMatches(hp)) {
        cutHP(_Mode.off);
        // Cut [highlight-part] as [highlight-mode-on].
      } else if (!_isMatches(data[i]) && _isMatches(hp)) {
        final isNotDetectable = detectWords && hp.length == 1;
        cutHP(isNotDetectable ? _Mode.off : _Mode.on);
      }

      hp += data[i];

      // Finish cutting highlight-part.
      if (hp.isNotEmpty && i == data.length - 1) {
        // Determine mode by matching of [element] and [highlight-part]+[element].
        final matches = _isMatches(data[i]) && _isMatches(hp + data[i]);
        cutHP(matches ? _Mode.on : _Mode.off);
      }
    }
  }

  // [InlineSpan] generator.
  // Generates a text span appropriate by given data and mode.
  //
  // Mode determines the style of generated text-span.
  // If mode is on, text-span's style would be [highlightStyle].
  // If not, style would be (default)[style].
  void _createSpan(
    String data,
    _Mode mode, {
    required TextStyle ds,
    required TextStyle hs,
  }) {
    final textSpan = TextSpan(
      text: data,
      style: (mode == _Mode.on) ? hs : ds,
    );

    _spans.add(textSpan);
  }

  // Matching checker for [parse] method.
  // Would be used to check matching of one letter or split word.
  bool _isMatches(String data) {
    // Ignore case sensitive.
    if (!caseSensitive) data = data.toLowerCase();

    // Check matching by pattern.
    if (highlight.pattern != null &&
        RegExp(highlight.pattern!).hasMatch(data)) {
      return true;
    }

    // Check matching by words/words.
    if (highlight.words != null && highlight.words!.isNotEmpty) {
      for (var i = 0; i < highlight.words!.length; i++) {
        var word = highlight.words![i];

        // Ignore case sensitive.
        if (!caseSensitive) word = word.toLowerCase();
        if (word.contains(data) || data.contains(word)) return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Define style of normal text.
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveStyle = style ?? defaultTextStyle.style;
    if (style == null || style!.inherit) {
      effectiveStyle = defaultTextStyle.style.merge(style);
    }

    // Generate highlight-sequence text-spans.
    _parse(ds: effectiveStyle, hs: highlightStyle);

    // Build the default text, if there is no spans.
    if (_spans.isEmpty) return Text(data, style: effectiveStyle);

    // Build the highlighted text with rich-text.
    return RichText(text: TextSpan(text: '', children: _spans));
  }
}

///
