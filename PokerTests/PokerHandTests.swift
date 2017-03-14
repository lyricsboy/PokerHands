//
//  PokerHandTests.swift
//  PokerTests
//
//  Created by Brian Hardy on 3/1/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import XCTest
@testable import Poker

class PokerHandTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
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
        
}
