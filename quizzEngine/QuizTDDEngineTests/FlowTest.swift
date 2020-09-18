//
//  FlowTest.swift
//  QuizTDDEngineTests
//
//  Created by Camile Ancines on 15/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizTDDEngine

class FlowTest: XCTestCase {
    
    //Router cannot be constructed because it is a protocol.
    //a RouterSpy is created. 'Spy' is a common terminology for a specific type of 'test double'. A 'Spy'is used for collecting usage information such as method invocation count and values recieve during tests. so it is used only for testing, never in production.
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        //a router that routed to any question when started with no questions.
        //XCTAssertEqual(router.routedQuestionCount, 0)
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    //testing the count.
    func test_start_withOneQuestion_routesToQuestion() {
        makeSUT(questions: ["Q1"]).start()
        
        //a router that routed to a question when started with 1 questions.
        //XCTAssertEqual(router.routedQuestionCount, 1)
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    //testing the value passed to the router.
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        
        //a router that routed to the correct question - Q1 - when started with 1 questions.
        //XCTAssertEqual(router.routedQuestion, "Q1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        
        //a router that routed to the correct question - Q2 - when started with 1 questions.
        //XCTAssertEqual(router.routedQuestion, "Q2")
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        makeSUT(questions: ["Q1","Q2"]).start()
        
        //a router that routed to the first question when started with 2 questions.
        //XCTAssertEqual(router.routedQuestion, "Q1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        
        //a router that routed to the first question when started with 2 questions for the second time.
        //XCTAssertEqual(router.routedQuestion, "Q1")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    //how to go from Q1 to Q2?
    func test_startAndAnswerFirstQuestion_withTwoQuestions_routesToSecondQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallback("A1")
        
        //a router that routed to the second question when the first question is answerd.
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    //if the test has three questions. the first and second questions were answered and the router has to routed to the third question.
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        //a router that routed to the Third question when the first and second questions are answerd.
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    //if the quiz has just one question, the question is answered and the router should route to any question
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRoutesToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        router.answerCallback("A1")
        
        //has to be only one question routed
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    //if have no questions and it starts, should route to an empty result.
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        
        //the router result should be empty.
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    //a quiz with one question, the question is aswered and the router has to route to the question and the answer.
    func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        router.answerCallback("A1")
        
        //has to be only one question routed
        XCTAssertEqual(router.routedResult!, ["Q1" : "A1"])
    }
    
    //a quiz with two questions, the first and second questions are aswered and the router has to route to the questions and the answers.
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        //has to be only one question routed
        XCTAssertEqual(router.routedResult!, ["Q1" : "A1", "Q2" : "A2"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRoutesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallback("A1")
        
        //does not routes to a result
        XCTAssertNil(router.routedResult)
    }
    
    func test_startWithOneQuestion_doesNotRoutesToResult() {
        makeSUT(questions: ["Q1"]).start()
        
        //does not routes to a result
        XCTAssertNil(router.routedResult)
    }
    
    
    //MARK: Helpers
    //sut: system under test, is equal to the flow's game.
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    //created just for the tests. the spy should be silmple and clean. if starts to get complecated, you probably are doing too much.
    class RouterSpy: Router {
        //        var routedQuestionCount: Int = 0
        //        var routedQuestion: String? = nil
        var routedQuestions: [String] = []
        var routedResult: [String : String]? = nil
        var answerCallback: Router.AnswerCallback = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            //            routedQuestionCount += 1
            //            routedQuestion = question
            
            //everytime the program routed a question, it appends the question.
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
}
