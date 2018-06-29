//
//  HomeViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 28/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBAction func logOut_TouchUpInSide(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logOutErr {
            print(logOutErr)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
