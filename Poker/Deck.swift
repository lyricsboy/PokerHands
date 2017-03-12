//
//  Deck.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/12/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation

struct Deck {
    
    private(set) var cards: [Card]
    
    init() {
        cards = Suit.allSuits.flatMap { suit in
            Rank.allRanks.map { rank in
                Card(suit: suit, rank: rank)
            }
        }
    }
    
    mutating func shuffle() {
        
    }
    
}
