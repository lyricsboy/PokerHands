//
//  PokerTests.swift
//  PokerTests
//
//  Created by Brian Hardy on 3/1/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import XCTest
@testable import Poker

class PokerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateHandFromString() {
        // define a string hand
        let validHand = "4H 4S 4D 9S 9D"
        // try to create a PokerHand from that string
        let hand = PokerHand(string: validHand)
        // verify that it has the right cards
        XCTAssertNotNil(hand)
        XCTAssertEqual(hand?.cards.count, 5)
        
        let expectedCards: [Card] = [
            Card(suit: .heart, rank: .four),
            Card(suit: .spade, rank: .four),
            Card(suit: .diamond, rank: .four),
            Card(suit: .spade, rank: .nine),
            Card(suit: .diamond, rank: .nine)
        ]
        XCTAssertEqual(hand!.cards, expectedCards)
    }
    
    func testCreateHandFromInvalidString() {
        var invalidHand = ""
        
        var hand = PokerHand(string: invalidHand)
        XCTAssertNil(hand)
        
        invalidHand = "100J 2H 5K 2Q ZX"
        hand = PokerHand(string: invalidHand)
        XCTAssertNil(hand)
        
        invalidHand = "JH JH 4H AH KH" // two of the same card (Jack of Hearts)
        hand = PokerHand(string: invalidHand)
        XCTAssertNil(hand)
    }
    
    func testCreateCardFromString() {
        let suits: [String: Suit] = [
            "S": .spade,
            "H": .heart,
            "C": .club,
            "D": .diamond
        ]
        let ranks: [String: Rank] = [
            "2": .two,
            "3": .three,
            "4": .four,
            "5": .five,
            "6": .six,
            "7": .seven,
            "8": .eight,
            "9": .nine,
            "0": .ten,
            "J": .jack,
            "Q": .queen,
            "K": .king,
            "A": .ace
        ]
        for suit in suits {
            for rank in ranks {
                let actualCard = Card(string: rank.key+suit.key)
                let expectedCard = Card(suit: suit.value, rank: rank.value)
                XCTAssertEqual(actualCard, expectedCard)
            }
        }
    }
    
    func testHighCard() {
        let aceHigh = PokerHand(string: "4H 3D QD JD AH")
        XCTAssertNotNil(aceHigh)
        XCTAssertEqual(KnownHand.from(pokerHand: aceHigh!), .highCard(.ace))
        
        let sevenHigh = PokerHand(string: "4H 3D 5S 2S 7C")
        XCTAssertNotNil(sevenHigh)
        XCTAssertEqual(KnownHand.from(pokerHand: sevenHigh!), .highCard(.seven))
    }
    
    func testPairs() {
        let pairOfFours = "4H 4D QD JD AH"
        
        let pairOfFoursHand = PokerHand(string: pairOfFours)
        XCTAssertNotNil(pairOfFoursHand)
        
        var knownHand = KnownHand.from(pokerHand: pairOfFoursHand!)
        XCTAssertEqual(knownHand, KnownHand.pair(.four))
        
        let pairOfQueens = "4H QD JD QH KH"
        let pairOfQueensHand = PokerHand(string: pairOfQueens)
        XCTAssertNotNil(pairOfQueensHand)
        knownHand = KnownHand.from(pokerHand: pairOfQueensHand!)
        XCTAssertEqual(knownHand, KnownHand.pair(.queen))
    }
    
    func testTwoPair() {
        let twoPair = PokerHand(string: "4H 4C 2C AH AC")
        XCTAssertNotNil(twoPair)
        XCTAssertEqual(KnownHand.from(pokerHand: twoPair!), .twoPair(.four, .ace))
    }

}
