//
//  SignInViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 27/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg3")!)

        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
        // Vẽ thêm đường kẻ dưới Email
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: emailTextField.frame.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayer)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
        // Vẽ thêm đường kẻ dưới Password
        let bottomLayer1 = CALayer()
        bottomLayer1.frame = CGRect(x: 0, y: 29, width: passwordTextField.frame.width, height: 0.5)
        bottomLayer1.backgroundColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayer1)
        
        
    }

}












