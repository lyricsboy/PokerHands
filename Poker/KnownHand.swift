//
//  KnownHand.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/3/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import Foundation

enum KnownHand: Equatable, Comparable {
    case highCard([Rank])
    case pair(pairRank: Rank, otherRanks: [Rank])
    case twoPair(highPairRank: Rank, lowPairRank: Rank, otherRank: Rank)
    case threeOfAKind(threeRank: Rank, otherRanks: [Rank])
    case straight(Rank)
    case flush(suit: Suit, ranks: [Rank])
    case fullHouse(threeOf: Rank, twoOf: Rank)
    case fourOfAKind(fourOf: Rank, otherRank: Rank)
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
        
        // convenience function to DRY this particular sorting code
        func sortedRanksFromRankGroups(_ rankGroups: AnyRandomAccessCollection<(key: Rank, value: [Card])>) -> [Rank] {
            return rankGroups.map { $0.key }.sorted().reversed()
        }
        
        // four of a kind
        if let fourOfAKind = rankGroupsSortedByCount.first, fourOfAKind.value.count == 4 {
            return .fourOfAKind(fourOf: fourOfAKind.key, otherRank: rankGroupsSortedByCount.dropFirst().first!.key)
        }
        
        // three of a kind
        if let threeOfAKind = rankGroupsSortedByCount.first, threeOfAKind.value.count == 3 {
            // check for full house
            if let pair = rankGroupsSortedByCount.dropFirst().first, pair.value.count == 2 {
                return .fullHouse(threeOf: threeOfAKind.key, twoOf: pair.key)
            }
            return .threeOfAKind(threeRank: threeOfAKind.key, otherRanks: sortedRanksFromRankGroups(AnyRandomAccessCollection(rankGroupsSortedByCount.dropFirst())))
        }
        
        // pairs
        let pairs = rankGroupsSortedByCount.filter { (rankCards) -> Bool in
            rankCards.value.count == 2
        }.sorted { (rankGroup1, rankGroup2) -> Bool in
            return rankGroup1.key > rankGroup2.key
        }
        if pairs.count == 2 {
            return .twoPair(highPairRank: pairs[0].key, lowPairRank: pairs[1].key, otherRank: rankGroupsSortedByCount.dropFirst(2).first!.key)
        } else if pairs.count == 1 {
            return .pair(pairRank: pairs[0].key, otherRanks: sortedRanksFromRankGroups(AnyRandomAccessCollection(rankGroupsSortedByCount.dropFirst())))
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
            return .flush(suit: highCard.suit, ranks: sortedRanksFromRankGroups(AnyRandomAccessCollection(rankGroupsSortedByCount)))
        }
        
        return .highCard(cardsSortedByRank.map { $0.rank })
    }
    
    fileprivate var compareValue: Int64 {
        let handCompareValue: Int
        let rankCompareValue: Int64
        switch self {
        case .straightFlush(_, let rank):
            handCompareValue = 8
            rankCompareValue = Int64(rank.rawValue)
        case .fourOfAKind(let fourRank, let otherRank):
            handCompareValue = 7
            rankCompareValue = [fourRank, otherRank].compareValue
        case .fullHouse(threeOf: let threeRank, twoOf: let twoRank):
            handCompareValue = 6
            rankCompareValue = [threeRank, twoRank].compareValue
        case .flush(_, let ranks):
            handCompareValue = 5
            rankCompareValue = ranks.compareValue
        case .straight(let rank):
            handCompareValue = 4
            rankCompareValue = Int64(rank.rawValue)
        case .threeOfAKind(let threeRank, let otherRanks):
            handCompareValue = 3
            rankCompareValue = ([threeRank] + otherRanks).compareValue
        case .twoPair(let highPairRank, let lowPairRank, let otherRank):
            handCompareValue = 2
            rankCompareValue = [highPairRank, lowPairRank, otherRank].compareValue
        case .pair(let pairRank, let otherRanks):
            handCompareValue = 1
            rankCompareValue = ([pairRank] + otherRanks).compareValue
        case .highCard(let ranks):
            handCompareValue = 0
            rankCompareValue = ranks.compareValue
        }
        // leave five least-significant bytes for rankCompareValue
        // remaining most significant bytes are for handCompareValue
        return (1 << (5 + handCompareValue)) + rankCompareValue
    }
}

extension Collection where IndexDistance == Int, Iterator.Element == Rank {
    
    var compareValue: Int64 {
        return enumerated().reduce(0, { (total, current: (offset: Int, rank: Rank)) -> Int64 in
            total + (Int64(current.rank.rawValue) << Int64((count - 1) - current.offset))
        })
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
    case (.threeOfAKind(let lthreeRank, let lotherRanks), .threeOfAKind(let rthreeRank, let rotherRanks)):
        return lthreeRank == rthreeRank && lotherRanks == rotherRanks
    case (.twoPair(let lhighPairRank, let llowPairRank, let lotherRank), .twoPair(let rhighPairRank, let rlowPairRank, let rotherRank)):
        return lhighPairRank == rhighPairRank && llowPairRank == rlowPairRank && lotherRank == rotherRank
    case (.pair(let lpairRank, let lotherRanks), .pair(let rpairRank, let rotherRanks)):
        return lpairRank == rpairRank && lotherRanks == rotherRanks
    case (.highCard(let lranks), .highCard(let rranks)):
        return lranks == rranks
    default:
        return false
    }
}

func <(lhs: KnownHand, rhs: KnownHand) -> Bool {
    return lhs.compareValue < rhs.compareValue
}
