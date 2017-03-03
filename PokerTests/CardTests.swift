//
//  CardTests.swift
//  PokerHands
//
//  Created by Brian Hardy on 3/3/17.
//  Copyright © 2017 Kata Corp. All rights reserved.
//

import XCTest
@testable import Poker

class CardTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
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
    
}
