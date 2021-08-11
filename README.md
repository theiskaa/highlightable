<p align="center">
 <img width="500" src="https://user-images.githubusercontent.com/59066341/129020944-6be3379a-fc3e-4c2c-aeea-ce476fd93aae.png" alt="Package Logo">
 <br>
  <br>
 <a href="https://github.com/theiskaa/field_suggestion">
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
`highlightableWord` poperty should be "Text splited array". E.g - `"hi".split("")` it will return an array like: `["h", "i"]`.
Otherwise, it could be a string, the widget automatically will convert it to array.

### Very basic usage

```dart
HighlightText(
  'Hello World',
  highlightableWord: 'hello',
),
```

<img width="200" alt="s1" src="https://user-images.githubusercontent.com/59066341/129022549-25bd74a7-e6de-48fe-af4e-bda99106be27.png">

### Custom usage

```dart     
HighlightText(
   'Hello Flutter',
   highlightableWord: 'hello',
   defaultStyle: TextStyle(
      fontSize: 25,
      color: Colors.black,
   ),
   highlightStyle: TextStyle(
      fontSize: 25,
      letterSpacing: 2.5,
      color: Colors.white,
      backgroundColor: Colors.blue,
   ),
),
```

<img width="220" alt="stwo" src="https://user-images.githubusercontent.com/59066341/129023374-5b406cff-1737-4942-805e-b178e165e6f0.png">