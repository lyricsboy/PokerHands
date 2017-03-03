//
//  Card.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/3/17.
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
