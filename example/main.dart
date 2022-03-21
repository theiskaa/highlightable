import 'package:flutter/material.dart';
import 'package:highlightable/highlightable.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Highlightable Examples")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Basic usage.
              HighlightText(
                'Only numbers: [1, 25, 50, ...] will be highlighted',
                // would highlight only numbers.
                highlight: const Highlight(pattern: r'\d'),
              ),

              const SizedBox(height: 50),

              // Custom Usage
              HighlightText(
                "Hello, Flutter!",
                // Would highlight only "Flutter"
                // full word 'cause [detectWords] is enabled.
                highlight: const Highlight(
                  words: ["Flutter"],
                ),
                caseSensitive: true, // Turn on case-sensitive.
                detectWords: true,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                highlightStyle: const TextStyle(
                  fontSize: 25,
                  letterSpacing: 2.5,
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

