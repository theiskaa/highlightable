import 'package:flutter/material.dart';
import 'package:highlightable/highlightable.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Highlightable Examples")),
      body: Center(
        child: HighlightText(
          'Hello World',
          highlightableWord: 'hello',
          defaultStyle: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
          highlightStyle: TextStyle(
            fontSize: 18,
            color: Colors.blue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
