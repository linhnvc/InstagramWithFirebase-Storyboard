//
//  SignInViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 27/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
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
        
        
        signInButton.isEnabled = false
        handleTextField()
        
    }
    
    // Khi chạm vào màn hình
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }

    }
    
    func handleTextField() {
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.setTitleColor(UIColor.black, for: .normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        // ProgressHUD trong ProgressHUD.h vừa được thêm vào
        // ProgressHUD là một interface, trong đó được định nghĩa trước một số phg thức như show(),...
        // ProgressHUD định nghĩa trước 1 số giao diện trong lúc đợi đăng nhập hoặc thông báo đăng nhập fail các kiểu,...
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }, onError: { err in
            ProgressHUD.showError(err)
        
        })
    }
    

}












