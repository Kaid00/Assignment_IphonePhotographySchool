//
//  LessonDetailViewModel_Tests.swift
//  Assignment_Tests
//
//  Created by Azamah Junior Khan on 20/01/2023.
//

import XCTest
import Combine
@testable import Assignment

final class LessonDetailViewModel_Tests: XCTestCase {
    private var sut: LessonDetailViewModel!
    var bag = Set<AnyCancellable>()


    override func setUpWithError() throws {
        sut = LessonDetailViewModel()

    }

    override func tearDownWithError() throws {
        bag.removeAll()
        sut = nil
        
    }
    
    func test_LessonDataVM_goToNext_getsNextLesson() {

        let currentLeasonIndex = 0
        sut.goToNext(mockLessonArray, currentLesson: mockLessonArray[currentLeasonIndex])
        
        let expectation =  XCTestExpectation(description: "Should return the next lesson index")
        expectation.fulfill()
        
        XCTAssertEqual(sut.nextLessonIndex, currentLeasonIndex + 1)
        
    }
    
    func test_LessonDataVM_goToNext_arrivedLastLesson() {

        let currentLeasonIndex = mockLessonArray.count - 1
        sut.goToNext(mockLessonArray, currentLesson: mockLessonArray[currentLeasonIndex])
        
        let expectation =  XCTestExpectation(description: "Should return true")
        expectation.fulfill()
        
        XCTAssertTrue(sut.islastLesson)
        
    }
    
    
    
    

}
