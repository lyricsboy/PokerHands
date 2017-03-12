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
        let expectedCards = Suit.allSuits.flatMap { suit in
            Rank.allRanks.map { rank in
                Card(suit: suit, rank: rank)
            }
        }
        XCTAssertEqual(deck.cards, expectedCards)
    }
    
    func testShuffle() {
        let standardDeck = Deck()
        var shuffledDeck = standardDeck
        shuffledDeck.shuffle(seed: 1)
        XCTAssertNotEqual(standardDeck.cards, shuffledDeck.cards)
        var shuffledDeck2 = standardDeck
        shuffledDeck2.shuffle(seed: 1)
        XCTAssertEqual(shuffledDeck.cards, shuffledDeck2.cards)
    }
    
    func testDeal() {
        var deck = Deck()
        let hand1 = deck.deal(5)
        XCTAssertEqual(hand1?.count, 5)
        XCTAssertEqual(deck.cards.count, 47)
        let bigHand = deck.deal(500)
        XCTAssertNil(bigHand)
    }

}
