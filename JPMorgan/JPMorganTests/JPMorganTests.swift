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
    var viewModel: DataSourceViewModel = DataSourceViewModel()

    override class func setUp() {
        super.setUp()
         
    }
    
    override func setUpWithError() throws {
        viewModel.getResponseDataForPlanets()
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
       
        print(viewModel.cards.count)
        cardsPublisher = viewModel.fetchCards().sink(receiveCompletion: { (completion) in
            if case .failure(let error) = completion {
                print("fetch error -- \(error)")
            }
        }, receiveValue: {  cards in
            XCTAssertTrue(self.viewModel.cards.count > 0, "Cards are Present")
            XCTAssertEqual(cards, self.viewModel.cards)
        })
    
    }

    func testDataModel() {
        let dataModel = DataModel(planetName: "Planet Name", rotation_period: "25")
        let sectionModel = SectionModel(title: "Planets", rows: [dataModel])
        XCTAssert(sectionModel.rows.count == 1)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
