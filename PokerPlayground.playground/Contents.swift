//: Playground - noun: a place where people can play

import Cocoa
import Poker

var deck1 = Deck()
var deck2 = Deck()
deck1.shuffle()
deck1.cards
deck2.shuffle()
deck2.cards

deck1 = Deck()
deck2 = Deck()
let seed: UInt64 = 1
deck1.shuffle(seed: seed)
let shuffle1 = deck1.cards
deck2.shuffle(seed: seed)
let shuffle2 = deck2.cards
shuffle1 == shuffle2