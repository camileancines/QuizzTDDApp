//
//  QuestionViewControllerTest.swift
//  QuizzTDDAppTests
//
//  Created by Camile Ancines on 18/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizzTDDApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_renderQuestionHeaderText() {
    //not call viewDidLoad here, should not invoke it directily
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withNoOptions_renderZeroOptions() {
        let sut = makeSUT(options: [])
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_viewDidLoad_withOneOption_renderOneOption() {
        let sut = makeSUT(options: ["A1"])
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withOptions_renderOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_renderOneOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_notifiesDelegate() {
        var recievedAnswer = [String]()
        let sut = makeSUT(options: ["A1"]) { recievedAnswer = $0 }
        sut.tableView.select(row: 0)
        
        XCTAssertEqual(recievedAnswer, ["A1"])
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var recievedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { recievedAnswer = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(recievedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(recievedAnswer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"]) { _ in callbackCount += 1 }
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionsEnable_notifiesDelegateSelection() {
        var recievedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { recievedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(recievedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(recievedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionsEnable_notifiesDelegate() {
        var recievedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { recievedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(recievedAnswer, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(recievedAnswer, [])
    }
    
    //MARK: Helper - function to create the System Under Test:
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping ([String]) -> Void = {_ in}) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}
