//
//  ResultsViewController.swift
//  QuizzTDDApp
//
//  Created by Camile Ancines on 22/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import UIKit

struct PresentableAnswer {
    let question: String
    let answer: String
    let isCorrect: Bool
}

class CorrectAnwerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
}

class WrongAnswerCell: UITableViewCell {
    
}

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var summary = ""
    private var answers = [PresentableAnswer]()
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
        tableView.register(UINib(nibName: "CorrectAnswerCell", bundle: nil), forCellReuseIdentifier: "CorrectAnswerCell")
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        
        if answer.isCorrect {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectAnswerCell") as! CorrectAnwerCell
            cell.questionLabel.text = answer.question
            cell.answerLabel.text = answer.answer
            return cell
        }
        return WrongAnswerCell()
    }
    
    
}
