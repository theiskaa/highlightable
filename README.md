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

## Installing
- See the official installing guideline from [highlightable/install](https://pub.dev/packages/highlightable/install)

## Usage

### _Basic usage:_
```dart
HighlightText(
  'Only numbers: [1, 25, 50, ...] will be highlighted',
  // would highlight only numbers.
  highlight: const Highlight(pattern: r'\d'),
)
```

<img width="600" alt="basic-usage" src="https://user-images.githubusercontent.com/59066341/159167993-31854ab2-011f-4138-97ae-9c83fc202181.png">

### _Custom usage:_
```dart     
HighlightText(                                   
  "Hello, Flutter!",                             
  // Would highlight only the "Flutter" full word 'cause [detectWords] is enabled.  
  highlight: const Highlight(                          
    words: ["Flutter"],                          
  ),                                             
  caseSensitive: true, // Turn on case-sensitive.
  detectWords: true,  // Turn on full-word-detection.
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
)
```
<img width="400" alt="custom-usage" src="https://user-images.githubusercontent.com/59066341/159168147-a565e5a6-fcad-4f44-908b-e472ce1517f9.png">
