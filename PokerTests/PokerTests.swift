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
    
}
