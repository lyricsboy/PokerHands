//
//  KnownHandTests.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/3/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import XCTest
@testable import Poker

class KnownHandTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testHighCard() {
        let aceHigh = PokerHand(string: "4H 3D QD JD AH")
        XCTAssertNotNil(aceHigh)
        XCTAssertEqual(KnownHand.from(pokerHand: aceHigh!), .highCard([.ace, .queen, .jack, .four, .three]))
        
        let sevenHigh = PokerHand(string: "4H 3D 5S 2S 7C")
        XCTAssertNotNil(sevenHigh)
        XCTAssertEqual(KnownHand.from(pokerHand: sevenHigh!), .highCard([.seven, .five, .four, .three, .two]))
    }
    
    func testPairs() {
        let pairOfFours = "4H 4D QD JD AH"
        
        let pairOfFoursHand = PokerHand(string: pairOfFours)
        XCTAssertNotNil(pairOfFoursHand)
        
        var knownHand = KnownHand.from(pokerHand: pairOfFoursHand!)
        XCTAssertEqual(knownHand, KnownHand.pair(pairRank: .four, otherRanks: [.ace, .queen, .jack]))
        
        let pairOfQueens = "4H QD JD QH KH"
        let pairOfQueensHand = PokerHand(string: pairOfQueens)
        XCTAssertNotNil(pairOfQueensHand)
        knownHand = KnownHand.from(pokerHand: pairOfQueensHand!)
        XCTAssertEqual(knownHand, KnownHand.pair(pairRank: .queen, otherRanks: [.king, .jack, .four]))
    }
    
    func testTwoPair() {
        let twoPair = PokerHand(string: "4H 4C 2C AH AC")
        XCTAssertNotNil(twoPair)
        XCTAssertEqual(KnownHand.from(pokerHand: twoPair!), .twoPair(highPairRank: .ace, lowPairRank: .four, otherRank: .two))
    }
    
    func testThreeOfAKind() {
        let threeFours = PokerHand(string: "4H 4C 4S AS KS")
        XCTAssertNotNil(threeFours)
        XCTAssertEqual(KnownHand.from(pokerHand: threeFours!), .threeOfAKind(threeRank: .four, otherRanks: [.ace, .king]))
    }
    
    func testFourOfAKind() {
        let fourFours = PokerHand(string: "4H 4C 4D 4S AS")
        XCTAssertNotNil(fourFours)
        XCTAssertEqual(KnownHand.from(pokerHand: fourFours!), .fourOfAKind(.four))
    }
    
    func testFullHouse() {
        let fullHouse = PokerHand(string: "4H 4C JD JS JC")
        XCTAssertNotNil(fullHouse)
        XCTAssertEqual(KnownHand.from(pokerHand: fullHouse!), .fullHouse(threeOf: .jack, twoOf: .four))
    }
    
    func testStraight() {
        let straight = PokerHand(string: "4H 5C 6D 7H 8C")
        XCTAssertNotNil(straight)
        XCTAssertEqual(KnownHand.from(pokerHand: straight!), .straight(.eight))
        
        let royalStraight = PokerHand(string: "0H JC QH KS AC")
        XCTAssertNotNil(royalStraight)
        XCTAssertEqual(KnownHand.from(pokerHand: royalStraight!), .straight(.ace))
    }
    
    func testFlush() {
        let flush = PokerHand(string: "4H 5H 9H 7H KH")
        XCTAssertNotNil(flush)
        XCTAssertEqual(KnownHand.from(pokerHand: flush!), .flush(.heart, .king))
    }
    
    func testStraightFlush() {
        let straightFlush = PokerHand(string: "0H JH KH QH AH")
        XCTAssertNotNil(straightFlush)
        XCTAssertEqual(KnownHand.from(pokerHand: straightFlush!), .straightFlush(.heart, .ace))
    }
    
    func testComparison() {
        // reference: http://www.cardplayer.com/rules-of-poker/hand-rankings
        let orderedHands: [String] = [
            "AD KD QD JD 0D", // royal flush
            "8C 7C 6C 5C 4C", // straight flush
            "JH JD JS JC 7D", // four of a kind
            "0H 0D 0S 9C 9D", // full house
            "4S JS 8S 2S 9S", // flush
            "9C 8D 7S 6D 5H", // straight
            "7C 7D 7S KC 3D", // three of a kind
            "4C 4S 3C 3D QS", // two pair
            "AH AD 8C 4S 7H", // one pair
            "3D JC 8S 4H 2S", // high card
        ]
        let knownHands = orderedHands.flatMap(PokerHand.init).map(KnownHand.from)
        XCTAssertEqual(orderedHands.count, knownHands.count)
        var iterator = knownHands.makeIterator()
        guard let firstHand = iterator.next() else { return }
        while let nextHand = iterator.next() {
            XCTAssertGreaterThan(firstHand, nextHand)
        }
        
        // compare two full houses
        let acesAndKings = PokerHand(string: "AH AS AD KH KS")
        XCTAssertNotNil(acesAndKings)
        let acesAndQueens = PokerHand(string: "AH AS AD QH QS")
        XCTAssertNotNil(acesAndQueens)
        XCTAssertGreaterThan(KnownHand.from(pokerHand: acesAndKings!), KnownHand.from(pokerHand: acesAndQueens!))
        
        let threesAndKings = PokerHand(string: "3D 3H 3S KH KD")
        XCTAssertNotNil(threesAndKings)
        let twosAndThrees = PokerHand(string: "2H 2D 2C 3H 3D")
        XCTAssertNotNil(twosAndThrees)
        XCTAssertGreaterThan(KnownHand.from(pokerHand: threesAndKings!), KnownHand.from(pokerHand: twosAndThrees!))
        
        let twosAndAces = PokerHand(string: "2H 2D 2C AH AD")
        XCTAssertNotNil(twosAndAces)
        // rank of triple wins over rank of pair
        XCTAssertGreaterThan(KnownHand.from(pokerHand: threesAndKings!), KnownHand.from(pokerHand: twosAndAces!))
    }
    
    func testComparison_HighCards() {
        let kingHighTen = PokerHand(string: "KH 0S 2C 3H 4C")
        XCTAssertNotNil(kingHighTen)
        let kingHighNine = PokerHand(string: "KH 9S 2C 3H 4C")
        XCTAssertNotNil(kingHighNine)
        XCTAssertGreaterThan(KnownHand.from(pokerHand: kingHighTen!), KnownHand.from(pokerHand: kingHighNine!))
        
        let lastCardThree = PokerHand(string: "KH QC JS 0S 3C")
        XCTAssertNotNil(lastCardThree)
        let lastCardTwo = PokerHand(string: "KH QC JS 0S 2C")
        XCTAssertNotNil(lastCardTwo)
        XCTAssertGreaterThan(KnownHand.from(pokerHand: lastCardThree!), KnownHand.from(pokerHand: lastCardTwo!))
    }
    
    func testComparison_PairHighCards() {
        let twoJacksTenNineEight = KnownHand.pair(pairRank: .jack, otherRanks: [.ten, .nine, .eight])
        let twoJacksTenNineSeven = KnownHand.pair(pairRank: .jack, otherRanks: [.ten, .nine, .seven])
        XCTAssertGreaterThan(twoJacksTenNineEight, twoJacksTenNineSeven)
    }
    
    func testComparison_TwoPair() {
        let queensAndJacksAndFive = KnownHand.twoPair(highPairRank: .queen, lowPairRank: .jack, otherRank: .five)
        let queensAndJacksAndFour = KnownHand.twoPair(highPairRank: .queen, lowPairRank: .jack, otherRank: .four)
        XCTAssertGreaterThan(queensAndJacksAndFive, queensAndJacksAndFour)
    }
    
    func testComparison_ThreeOfAKind() {
        let threeJacksFiveFour = KnownHand.threeOfAKind(threeRank: .jack, otherRanks: [.five, .four])
        let threeJacksFiveThree = KnownHand.threeOfAKind(threeRank: .jack, otherRanks: [.five, .three])
        XCTAssertGreaterThan(threeJacksFiveFour, threeJacksFiveThree)
    }
    
}
