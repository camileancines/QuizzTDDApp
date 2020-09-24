//
//  AppDelegate.swift
//  QuizzTDDApp
//
//  Created by Camile Ancines on 18/09/20.
//  Copyright © 2020 Camile Ancines. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       let viewController = ResultsViewController(summary: "you are a genius", answers: [
            PresentableAnswer(question: "Question??", answer: "YEAH!", wrongAnswer: nil),
            PresentableAnswer(question: "Another Question", answer: "NOO", wrongAnswer: "YEAH")
       ])
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}

