//
//  Flow.swift
//  QuizTDDEngine
//
//  Created by Camile Ancines on 15/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
    func routeTo(result: [String : String])
}

class Flow {
    
    private let router: Router
    private let questions: [String]
    private var result: [String : String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    //coordinates question to question and pass the result
    private func nextCallback(from question: String) -> (String) -> Void {
//        return { [weak self] answer in
//            if let strongSelf = self {  //avoid leaking memory
//                self?.routeNext(question, answer)
//            }
//        }
        return {[weak self] in self?.routeNext(question, $0)}
    }
    
    //acumulating the results and passing it.
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
 
