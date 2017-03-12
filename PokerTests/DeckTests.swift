//
//  DeckTests.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/12/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import XCTest
@testable import Poker

class DeckTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStandardDeck() {
        let deck = Deck()
        XCTAssertEqual(deck.cards.count, 52)
    }

}