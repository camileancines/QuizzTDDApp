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
        let sut = makeSUT(question: "Q1")
        
        XCTAssertEqual(sut.headerLabel.text, "Q1")
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
        var recievedAnswer = ""
        let sut = makeSUT(options: ["A1"]) {
            recievedAnswer = $0
        }
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(recievedAnswer, "A1")
    }
    
    //MARK: Helper - function to create the System Under Test:
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (String) -> Void = {_ in}) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}

private extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        return cell(at: row)?.textLabel?.text
    }
}
