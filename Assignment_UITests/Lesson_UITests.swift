//
//  LessonList_UITests.swift
//  Assignment_UITests
//
//  Created by Azamah Junior Khan on 20/01/2023.
//

import XCTest

// Naming structure: test_[struct]_[ui component]_[expected result]

final class Lesson_UITests: XCTestCase {
    
    let app = XCUIApplication()
    

    override func setUpWithError() throws {
       
        continueAfterFailure = false
        app.launch()
        
    }

    override func tearDownWithError() throws {
    }

 
    func test_LessonList_navigationLink_shouldOpenDetails() {
        
        // Given
        let LessonList = app.navigationBars["Lessons"].staticTexts["Lessons"]
        let lesson = app.scrollViews.otherElements.buttons["The Key To Success In iPhone Photography"]
        sleep(2)
        lesson.tap()
        
        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Lessons"]
        
        backButton.tap()
        LessonList.tap()

        XCTAssert(LessonList.waitForExistence(timeout: 40))
    }
    
    
    func test_LessonDetails_nextLesson_shouldOpenToNextLesson() {
        let lesson =  app.scrollViews.otherElements.buttons["The Key To Success In iPhone Photography"]
        lesson.tap()
        
        let nextLessonButton = app.buttons["Next lesson"]
        sleep(1)
        nextLessonButton.tap()
        
        let navBtn = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        
        let backButton = navBtn.buttons["Back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 40))

        
    }
    
    func test_LessonDetails_downloadButton_shouldShowCancelDownloadAndProgress() {
       
        app.scrollViews.otherElements.buttons["The Key To Success In iPhone Photography"].tap()
        
        let detailNavButtons = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        
        detailNavButtons/*@START_MENU_TOKEN@*/.buttons["Download"]/*[[".otherElements[\"Download\"].buttons[\"Download\"]",".buttons[\"Download\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let cancelDownloadBtn = detailNavButtons/*@START_MENU_TOKEN@*/.buttons["Cancel download"]/*[[".otherElements[\"Cancel download\"].buttons[\"Cancel download\"]",".buttons[\"Cancel download\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssert(cancelDownloadBtn.waitForExistence(timeout: 30))

        cancelDownloadBtn.tap()
        
        let cancelDownloadBtnexist = cancelDownloadBtn.waitForExistence(timeout: 30)
        XCTAssertFalse(cancelDownloadBtnexist)
  
    }
    
    func test_LessonDetails_videoPlayer_videoPlayerShouldExist() {
        
        app.scrollViews.otherElements.buttons["The Key To Success In iPhone Photography"].tap()
        
        let videoFrame = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        videoFrame.children(matching: .image).element(boundBy: 0).tap()
        
        let AVplayer = videoFrame.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        AVplayer.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
        AVplayer.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
              
        XCTAssertTrue(videoFrame.exists)
    }
    
    func test_LessonDetails_goToLessonsBtn_shouldGoToLessonsList() {
        
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        sleep(3)
        elementsQuery.buttons["Secrets For Capturing Beautiful iPhone Portrait Photos"].tap()
        app.buttons["Back to lessons"].tap()
        
        let lessonsList = app.navigationBars["Lessons"].staticTexts["Lessons"]
        
        XCTAssert(lessonsList.waitForExistence(timeout: 20))
        
       
                        
    }
    
}
 
