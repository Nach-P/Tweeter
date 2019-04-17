//
//  TweeterTests.swift
//  TweeterTests
//
//  Created by Nach on 14/4/19.
//  Copyright © 2019 Edenred. All rights reserved.
//

import XCTest
@testable import Tweeter

class TweeterTests: XCTestCase {
    
    var mainVC:ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainVC = ViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }   
    
    func testSplitMessage() {
        XCTAssertEqual(mainVC.splitMessage("I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."),["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."])
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
