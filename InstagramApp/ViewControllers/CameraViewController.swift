//
//  CameraViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 28/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleSelectPhoto))
        photo.addGestureRecognizer(tap)
        photo.isUserInteractionEnabled = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            shareButton.isEnabled = true
            removeButton.isEnabled = true
            shareButton.backgroundColor = .blue
            shareButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            shareButton.isEnabled = false
            removeButton.isEnabled = false
            shareButton.backgroundColor = UIColor.lightGray
        }
    }
    
    // Ấn ngoài để ẩn bàn phím
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    guard let photoUrl = url?.absoluteString else {
                        return
                    }
                    self.sendDataToDatabase(photoUrl: photoUrl)
                })
            })

        } else {
            ProgressHUD.showError("Profile image can not empty")
        }
    }
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            // Chuyển về màn hình Home:
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "placeholderPhoto")
        self.selectedImage = nil
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Xử lý khi chọn xong 1 bức ảnh trong thư viện ảnh:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Ảnh có các thông tin được lưu dưới dạng Dictionary: (key, value)
        // value ảnh có key = UIImagePickerControllerOriginalImage
        // Vì vậy:
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = img
            photo.image = img
        }
        dismiss(animated: true, completion: nil)
    }
}





