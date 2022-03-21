## 1.0.5 - (22/03/22)

### Updates:

Resolved [#12](https://github.com/theiskaa/highlightable/issues/12) 
 - Updated state behaviour type of [HighlightText] widget.
 - Improved default-text-determining by theme.

## 1.0.4 - (20/03/22)

### Updates:

Resolved [#5](https://github.com/theiskaa/highlightable/issues/5) 
 - Re-structured the whole widget to improve rendering speed.
 - Added a new model object to pass Regular-Expression patterns, as higlighting search options.

**The new widget structure:**
```
 ╭──────╮        Highlight                                
 │ Data │       ╭─────────────────────────────────╮       
 ╰──────╯       │ ╭─────────╮   ╭───────────────╮ │       
    │       ╭──▶│ │ Pattern │ & │ Words/Letters │ │       
    │       │   │ ╰─────────╯   ╰───────────────╯ │       
    │       │   ╰─────────────────────────────────╯       
    ╰───────╯                                             
        │                                                 
    ╭── ▼ ──╮         ╭─────────────────────────────────╮ 
    │ Parser ───▶ ... │ Highlighted Data as Text Widget │ 
    ╰───────╯         ╰─────────────────────────────────╯ 
```

## 1.0.3 - (18/10/21)

- Resolved [#6](https://github.com/theiskaa/highlightable/issues/6) (Added case sensitive support)

#### Example:

```dart     
HighlightText(
  "Hello, Flutter!",
  highlightableWord: "flu, He",
  caseSensitive: true // Turn on case-sensitive. (as default it's false "disabled").
),
```

## 1.0.2 - (15/08/21)

- Added `detectWord` property to focus on concrete matcher words

#### Example:

```dart     
HighlightText(
  "Hello, Flutter!",
  highlightableWord: "flu, He",
  detectWords: true,
  defaultStyle: ...
  highlightStyle: ...
),
```

<img width="200" alt="stwo" src="https://user-images.githubusercontent.com/59066341/129483513-c379f0d6-d5ba-43e1-a2d7-0722aeb5dafa.png">

---

## 1.0.1 - (11/08/21)

- Fixed lower/upper case matching problem

## 1.0.0 - (11/08/21)
<p align="center">
<img width="300" src="https://user-images.githubusercontent.com/59066341/129020944-6be3379a-fc3e-4c2c-aeea-ce476fd93aae.png" alt="Package Logo">
</p>

---

```dart
HighlightText(
  'Hello World',
  highlightableWord: 'hello',
),
```

<img width="200" alt="s1" src="https://user-images.githubusercontent.com/59066341/129022549-25bd74a7-e6de-48fe-af4e-bda99106be27.png">

---

<a href="https://github.com/theiskaa/field_suggestion">
   <img src="https://img.shields.io/badge/Special%20Made%20for-FieldSuggestion-blue" alt="License: MIT"/>
</a>
<a href="https://github.com/theiskaa/highlightable-text/blob/main/LICENSE">
<img src="https://img.shields.io/badge/License-MIT-red.svg" alt="License: MIT"/>
</a>
<a href="https://github.com/theiskaa/highlightable-text/blob/main/CONTRIBUTING.md">
<img src="https://img.shields.io/badge/Contributions-Welcome-brightgreen" alt="CONTRIBUTING"/>
</a>
