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
        let suits: [Suit] = [.club, .diamond, .heart, .spade]
        let ranks: [Rank] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace]
        cards = suits.flatMap { suit in
            ranks.map { rank in
                Card(suit: suit, rank: rank)
            }
        }
    }
    
}
