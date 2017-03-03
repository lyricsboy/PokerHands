//
//  PokerHand.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/1/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation

enum Suit: String {
    case heart = "H"
    case club = "C"
    case diamond = "D"
    case spade = "S"
}

enum Rank: Int {
    case two = 2
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace
    
    static func from(string: String) -> Rank? {
        switch string {
        case "2"..."9":
            guard let intValue = Int(string) else { return nil}
            return Rank(rawValue: intValue)
        case "0": return .ten
        case "J": return .jack
        case "Q": return .queen
        case "K": return .king
        case "A": return .ace
        default: return nil
        }
    }
    
}

extension Rank: Comparable { }

func <(lhs: Rank, rhs: Rank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

enum KnownHand: Equatable {
    case highCard(Rank)
    case pair(Rank)
    case twoPair(Rank, Rank)
    case threeOfAKind(Rank)

    static func from(pokerHand: PokerHand) -> KnownHand {
        // prefer the best hand
        
        let cardsSortedByRank = pokerHand.cards.sorted {
            $0.rank > $1.rank
        }

        // how many cards are there for each rank?
        let cardsGroupedByRank = pokerHand.cardsGroupedByRank()
        
        let rankGroupsSortedByCount = cardsGroupedByRank.sorted { (leftRankCards, rightRankCards) -> Bool in
            return leftRankCards.value.count > rightRankCards.value.count
        }
        
        // four of a kind
        if let fourOfAKind = rankGroupsSortedByCount.first(where: { $0.value.count == 4}) {
            return .fourOfAKind(fourOfAKind.key)
        }
        
        // three of a kind
        if let threeOfAKind = rankGroupsSortedByCount.first(where: { $0.value.count == 3 }) {
            return .threeOfAKind(threeOfAKind.key)
        }
        
        // pairs
        let pairs = rankGroupsSortedByCount.filter { (rankCards) -> Bool in
            rankCards.value.count == 2
        }
        if pairs.count == 2 {
            return .twoPair(pairs[0].key, pairs[1].key)
        } else if pairs.count == 1 {
            return .pair(pairs[0].key)
        }
        
        // at this point we know there are no two cards of the same rank
        
        // is it a straight?
        var totalDelta: Int = 0
        var previousCard: Card = cardsSortedByRank[0]
        cardsSortedByRank.dropFirst().forEach { (card) in
            totalDelta += previousCard.rank.rawValue - card.rank.rawValue
            previousCard = card
        }
        if totalDelta == cardsSortedByRank.count - 1 {
            // we have a straight
            return .straight(cardsSortedByRank[0].rank)
        }
        
        return .highCard(cardsSortedByRank[0].rank)
    }
}

func ==(lhs: KnownHand, rhs: KnownHand) -> Bool {
    switch (lhs, rhs) {
    case (.straight(let lrank), .straight(let rrank)):
        return lrank == rrank
    case (.fourOfAKind(let lrank), .fourOfAKind(let rrank)):
        return lrank == rrank
    case (.threeOfAKind(let lrank), .threeOfAKind(let rrank)):
        return lrank == rrank
    case (.twoPair(let lrank1, let lrank2), .twoPair(let rrank1, let rrank2)):
        return lrank1 == rrank1 && lrank2 == rrank2
    case (.pair(let lrank), .pair(let rrank)):
        return lrank == rrank
    case (.highCard(let lrank), .highCard(let rrank)):
        return lrank == rrank
    default:
        return false
    }
}

struct Card: Equatable {
    let suit: Suit
    let rank: Rank
    
    init?(string: String) {
        guard string.characters.count == 2 else {
            return nil
        }
        guard let possibleRank = string.characters.first, let possibleSuit = string.characters.dropFirst().first else {
            return nil
        }
        guard let rank = Rank.from(string: String(possibleRank)) else {
            return nil
        }
        guard let suit = Suit(rawValue: String(possibleSuit)) else {
            return nil
        }
        self.suit = suit
        self.rank = rank
    }
    
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
}

func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.suit == rhs.suit && lhs.rank == rhs.rank
}

extension Card: Hashable {
    
    var hashValue: Int {
        return suit.hashValue ^ rank.hashValue
    }
}


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
