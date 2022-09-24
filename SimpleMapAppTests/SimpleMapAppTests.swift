//
//  SimpleMapAppTests.swift
//  SimpleMapAppTests
//
//  Created by Ege Girsen on 21.09.2022.
//

import XCTest
@testable import SimpleMapApp

class SimpleMapAppTests: XCTestCase {

    func testItemViewModel(){
        let category1 = Categories(title: "cafe")
        let category2 = Categories(title: "fast food")
        let items: [Items] = [Items(position: [123.12, 124.12], distance: 1000, title: "Starbucks", category: category1, id: "1231231312312"),
                              Items(position: [321.21, 421.21], distance: 500, title: "Burger King", category: category2, id: "456456456456")]
      
        
        let viewModel = Results(items: items)
        XCTAssertEqual(viewModel.items[0].title, "Starbucks")
        XCTAssertEqual(viewModel.items[0].position, [123.12, 124.12])
        
        XCTAssertEqual(viewModel.items[1].distance, 500)
        XCTAssertEqual(viewModel.items[1].category.title, "fast food")
        
    }

}
