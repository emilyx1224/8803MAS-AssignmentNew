//
//  MenurViewController.swift
//  8803MAS-LockGame
//
//  Created by yxue on 8/31/19.
//  Copyright © 2019 yxue. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBAction func playButtonHandler(sender: AnyObject){
        let gvc = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        gvc.continueMode = false
        present(gvc, animated: true, completion: nil)
    }
    @IBAction func continueButtonHandler(sender: AnyObject){
        let gvc = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        gvc.continueMode = true
        present(gvc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
