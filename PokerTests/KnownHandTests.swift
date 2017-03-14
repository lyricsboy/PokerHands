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
    
    func testThreeOfAKind() {
        let threeFours = PokerHand(string: "4H 4C 4S AS KS")
        XCTAssertNotNil(threeFours)
        XCTAssertEqual(KnownHand.from(pokerHand: threeFours!), .threeOfAKind(.four))
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

}
