//
//  GameViewController.swift
//  8803MAS-LockGame
//
//  Created by yxue on 8/31/19.
//  Copyright © 2019 yxue. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
//import Firebase

class GameViewController: UIViewController {
    
    var continueMode: Bool?
    
//    @IBAction func menuButtonHandler(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    @IBAction func restartButtonHandler(_ sender: Any) {
      
//         let gvc = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
//  gvc.continueMode = false
//         present(gvc, animated: true, completion: nil)
        self.viewDidLoad()
//        Analytics.logEvent("Restart_button_pressed", parameters: nil)
        let url: URL = URL(string:"https://mas-fc6e1.firebaseio.com/test.json")!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody =
                try JSONSerialization.data(withJSONObject: ["first":"Jack", "last": "Sparrow"], options: .prettyPrinted)
            
//                Data(base64Encoded: "{ \"first\": \"Jack\", \"last\": \"Sparrow\" }")
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            if response != nil {
                print(response!)
            }
        }
        
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        
        let skView = self.view as! SKView
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        if let continueIsTrue = continueMode {
            scene.continueMode = continueIsTrue
        }
        
        skView.presentScene(scene)
    }
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
////            if let scene = SKScene(fileNamed: "GameScene") {
//            let scene = GameScene(size: view.bounds.size)
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//            if let continueIsTrue = continueMode {
//                scene.continueMode = continueIsTrue
//            }
//            view.presentScene(scene)
//
//
//            view.ignoresSiblingOrder = true
//
////            view.showsFPS = true
////            view.showsNodeCount = true
//
//
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
