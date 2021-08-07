//
//  JPMorganTests.swift
//  JPMorganTests
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import XCTest
@testable import JPMorgan
import Combine

class JPMorganTests: XCTestCase {

    private var cardsPublisher: AnyCancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
       let viewModel = DataSourceViewModel()
        viewModel.getResponseData()
        print(viewModel.cards.count)
        cardsPublisher = viewModel.fetchCards().sink(receiveCompletion: { (completion) in
            if case .failure(let error) = completion {
                print("fetch error -- \(error)")
            }
        }, receiveValue: {  cards in
            XCTAssertTrue(viewModel.cards.count > 0, "Cards are Present")
            XCTAssertEqual(cards, viewModel.cards)
        })
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
