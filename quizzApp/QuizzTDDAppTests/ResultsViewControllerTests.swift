//
//  ResultsViewControllerTests.swift
//  QuizzTDDAppTests
//
//  Created by Camile Ancines on 22/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizzTDDApp

class ResultsViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_rendersSummary(){
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func test_viewDidiLoad_rendersAnswers() {
        XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeDummyAnswer()]).tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_renderCorrectAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(isCorrect: true)])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnwerCell
        
        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withCorrectAnswer_rendersQuestionText() {
        let answer = makeAnswer(question: "Q1", isCorrect: true)
        let sut = makeSUT(answers: [answer])
        let cell = sut.tableView.cell(at: 0) as! CorrectAnwerCell
        
        XCTAssertEqual(cell.questionLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withWrongtAnswer_renderWrongAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(isCorrect: false)])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
    }
    
    //MARK: Helpers
    func makeSUT(summary:String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        _ = sut.view
        return sut
    }
    
    func makeDummyAnswer() -> PresentableAnswer {
        return makeAnswer(isCorrect: false)
    }
    
    func makeAnswer(question: String = "", answer: String = "", isCorrect: Bool) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, isCorrect: isCorrect)
    }
}

