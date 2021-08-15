<p align="center">
  <br>
 <img width="500" src="https://user-images.githubusercontent.com/59066341/129483451-4196e1bb-f094-4b3c-aefc-41d77aff8117.png" alt="Package Logo">
 <br>
  <br>
 <a href="https://pub.dev/packages/field_suggestion">
   <img src="https://img.shields.io/badge/Special%20Made%20for-FieldSuggestion-blue" alt="License: MIT"/>
 </a>
 <a href="https://github.com/theiskaa/highlightable-text/blob/main/LICENSE">
   <img src="https://img.shields.io/badge/License-MIT-red.svg" alt="License: MIT"/>
 </a>
 <a href="https://github.com/theiskaa/highlightable-text/blob/main/CONTRIBUTING.md">
   <img src="https://img.shields.io/badge/Contributions-Welcome-brightgreen" alt="CONTRIBUTING"/>
 </a>

</p>

# Overview & Usage

First, `actualText` property and `highlightableWord` property are required.
You can customize `actualText` by providing `defaultStyle`. Also you can customize highlighted text style by `highlightStyle` property.
`highlightableWord` poperty could be string array or just string with spaces. 

You can enable word detection to focus on concrete matcher word. See "Custom usage" part for example.

### Very basic usage

```dart
HighlightText(
  'Hello World',
  highlightableWord: 'hello',
),
```

<img width="200" alt="s1" src="https://user-images.githubusercontent.com/59066341/129080679-bfb97d11-93c5-4258-b271-0e0918e3bc22.png">

### Custom usage

```dart     
HighlightText(
  "Hello, Flutter!",
  highlightableWord: "flu, He",
  detectWords: true,
  defaultStyle: TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
  highlightStyle: TextStyle(
    fontSize: 25,
    letterSpacing: 2.5,
    color: Colors.white,
    backgroundColor: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
),
```

<img width="220" alt="stwo" src="https://user-images.githubusercontent.com/59066341/129483513-c379f0d6-d5ba-43e1-a2d7-0722aeb5dafa.png">
