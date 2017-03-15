build-lists: true
footer: © Brian Hardy, 2017. [@lyricsboy](https://github.com/lyricsboy)

# Poker Hands
## In Swift
### With TDD

Brian Hardy
Atlanta iOS Developers

---

# The Poker Hands Kata

* 52-card deck
* 4 suits, Aces high
* Sample hand: `2H 3D 5S 9C KD`
* Goal: Compare hands to determine a winner.

Reference: [Coding Dojo](http://codingdojo.org/kata/PokerHands/)

---

# In Swift (3)

* Protocols
    * Equatable
    * Comparable
    * Hashable
* Enumerations
    * Associated Values

---

# With TDD

* Test
* Driven
* Design

---

# Red, Green, Refactor

1. Red: Write a failing test
1. Green: Make the test pass
1. Refactor: Improve, DRY, etc.

---
[.autoscale: true]

# Things To Do

1. Model Card, Suit, Rank
1. Model Poker Hand 
    * (5 cards)
1. Identify Known Hands 
    * (pair, full house, flush)
1. Compare Hands
    * hand ranking
    * card ranking
    
---

# Demo Time