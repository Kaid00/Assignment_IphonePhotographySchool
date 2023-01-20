//
//  DownloadManager_Tests.swift
//  Assignment_Tests
//
//  Created by Azamah Junior Khan on 19/01/2023.
//

import XCTest
import AVKit
@testable import Assignment

final class DownloadManager_Tests: XCTestCase {
    private var sut: DownloadManager!

    
    override func setUpWithError() throws {
        sut = DownloadManager()
    }

    override func tearDownWithError() throws {
    }
    
    func tests_formatFileName_returnsFormatted() {
        
        let actual = sut.formatFileName(name: " iPhone Lenses")
        
        
        let expected = "iPhone_Lenses"
        let notEqual = " iPhone_Lenses"
        XCTAssertNotEqual(actual, notEqual)
        XCTAssertEqual(actual, expected)
    }
    
   
    func test_DownloadManager_getVideoFileAsset_shouldReturnNil() {
        let file = sut.getVideoFileAsset(fileName: "\(Int.random(in: 1..<5))8eGs2")
        XCTAssertEqual(file, nil)
    }


    
}
