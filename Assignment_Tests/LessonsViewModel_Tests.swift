//
//  LessonsViewModel_Tests.swift
//  Assignment_Tests
//
//  Created by Azamah Junior Khan on 19/01/2023.
//

import XCTest
import Combine
@testable import Assignment
// Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

final class LessonsViewModel_Tests: XCTestCase {
    
    private var sut: LessonsViewModel!
    var bag = Set<AnyCancellable>()
    let networkMonitor = NetworkMonitor()


    
    override func setUpWithError() throws {
        sut = LessonsViewModel()

    }

    override func tearDownWithError() throws {
        bag.removeAll()
        sut = nil
    }

    func test_LessonsViewModel_fetchLessons_shouldReturnLessons() throws {
        
        try XCTSkipUnless(
          networkMonitor.isConnected,
          "Network connectivity needed for this test.")
       
        let expectation = XCTestExpectation(description: "Should return and array of lessons")
        
        sut.$lessons
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &bag)
            
        sut.fetchLessons()
        
        // Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.lessons.count, 0)
    }
    

    
    
  

}
