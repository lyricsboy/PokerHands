//
//  KnownHand.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/3/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation

enum KnownHand: Equatable {
    case highCard(Rank)
    case pair(Rank)
    case twoPair(Rank, Rank)
    case threeOfAKind(Rank)
    case straight(Rank)
    case flush(Suit, Rank)
    case fullHouse(threeOf: Rank, twoOf: Rank)
    case fourOfAKind(Rank)
    case straightFlush(Suit, Rank)
    
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
        if let fourOfAKind = rankGroupsSortedByCount.first, fourOfAKind.value.count == 4 {
            return .fourOfAKind(fourOfAKind.key)
        }
        
        // three of a kind
        if let threeOfAKind = rankGroupsSortedByCount.first, threeOfAKind.value.count == 3 {
            // check for full house
            if let pair = rankGroupsSortedByCount.dropFirst().first, pair.value.count == 2 {
                return .fullHouse(threeOf: threeOfAKind.key, twoOf: pair.key)
            }
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
        
        // is it a flush?
        let highCard = cardsSortedByRank[0]
        let otherSuitCards = cardsSortedByRank.dropFirst().filter { (card) -> Bool in
            card.suit != highCard.suit
        }
        // no other suits? it's a flush
        let isFlush = otherSuitCards.isEmpty
        
        // is it a straight?
        var totalDelta: Int = 0
        var previousCard: Card = cardsSortedByRank[0]
        cardsSortedByRank.dropFirst().forEach { (card) in
            totalDelta += previousCard.rank.rawValue - card.rank.rawValue
            previousCard = card
        }
        let isStraight = totalDelta == cardsSortedByRank.count - 1
        
        if isStraight && isFlush {
            return .straightFlush(highCard.suit, highCard.rank)
        } else if isStraight {
            return .straight(highCard.rank)
        } else if isFlush {
            return .flush(highCard.suit, highCard.rank)
        }
        
        return .highCard(highCard.rank)
    }
}

func ==(lhs: KnownHand, rhs: KnownHand) -> Bool {
    switch (lhs, rhs) {
    case (.fullHouse(let ltriple, let lpair), .fullHouse(let rtriple, let rpair)):
        return ltriple == rtriple && lpair == rpair
    case (.straightFlush(let lsuit, let lrank), .straightFlush(let rsuit, let rrank)):
        return lsuit == rsuit && lrank == rrank
    case (.flush(let lsuit, let lrank), .flush(let rsuit, let rrank)):
        return lsuit == rsuit && lrank == rrank
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
