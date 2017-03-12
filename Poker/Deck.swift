//
//  Deck.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/12/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation
import GameplayKit

public struct Deck {
    
    public private(set) var cards: [Card]
    
    public init() {
        cards = Suit.allSuits.flatMap { suit in
            Rank.allRanks.map { rank in
                Card(suit: suit, rank: rank)
            }
        }
    }
    
    public mutating func shuffle(seed: UInt64? = nil) {
        let randomSource: GKRandomSource
        if let seed = seed {
            randomSource = GKLinearCongruentialRandomSource(seed: seed)
        } else {
            randomSource = GKRandomSource.sharedRandom()
        }
        cards = randomSource.arrayByShufflingObjects(in: cards) as! [Card]
    }
    
}
