/// [Highlight] is the custom highlighting object
/// Used as [HighlightText]'s highlighting data.
/// 
/// [pattern] or [words], one of them must be provided.
/// [pattern] would be used as [RegExp] model's pattern to check if data has match.
/// [words]'s each element would be compared to data.
class Highlight {
    final String? pattern;
    final List<String>? words;

    const Highlight({this.pattern, this.words});
}
