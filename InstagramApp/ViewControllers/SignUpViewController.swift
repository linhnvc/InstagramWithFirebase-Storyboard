//
//  SignUpViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 27/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg3")!)
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
        // Vẽ thêm đường kẻ dưới Username
        let bottomLayer3 = CALayer()
        bottomLayer3.frame = CGRect(x: 0, y: 29, width: usernameTextField.frame.width, height: 0.5)
        bottomLayer3.backgroundColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayer3)
        
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

        handleTextField()
        
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)

    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.black, for: .normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = true
    }
    

    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            let uid = authDataResult?.user.uid
            
            let storageRef = Storage.storage().reference(forURL: "gs://instagram-ac0dc.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }

                    storageRef.downloadURL(completion: { (url, err) in
                        guard let profileImageUrl = url?.absoluteString else {
                            return
                        }
                        let username: String = self.usernameTextField.text!
                        let email: String = self.emailTextField.text!

                        self.setUserInformation(profileImageUrl: profileImageUrl, username: username, email: email, uid: uid!)
                        
                    })
                })
            }
        }
    }
    
    func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String) {
        // thêm user vào database
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
    }
    
}



extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Xử lý khi chọn xong 1 bức ảnh trong thư viện ảnh:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = img
            profileImage.image = img
        }
        dismiss(animated: true, completion: nil)
    }
}











