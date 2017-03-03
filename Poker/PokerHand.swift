//
//  PokerHand.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/1/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation

struct PokerHand {
    
    let cards: [Card]
    
    init?(string: String) {
        let stringCards = string.components(separatedBy: " ")
        guard stringCards.count == 5 else {
            return nil
        }
        let validCards = stringCards.flatMap {
            Card(string: $0)
        }
        // only a five-card hand of non-duplicates is valid
        guard Array(Set<Card>(validCards)).count == 5 else {
            return nil
        }
        self.cards = validCards
    }
    
    func cardsGroupedByRank() -> [Rank: [Card]] {
        var cardsByRank: [Rank: [Card]] = [:]
        for card in cards {
            var existingCards = cardsByRank[card.rank] ?? []
            existingCards.append(card)
            cardsByRank[card.rank] = existingCards
        }
        return cardsByRank
    }
    
}
