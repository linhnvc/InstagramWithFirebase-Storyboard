//
//  AuthService.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 29/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    // khi khai báo Static, nơi gọi hàm có thể gọi trực tiếp mà không cần tạo ra đối tượng thuộc lớp AuthService
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            let uid = authDataResult?.user.uid
            
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
            
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        guard let profileImageUrl = url?.absoluteString else {
                            return
                        }
                        self.setUserInformation(profileImageUrl: profileImageUrl, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                    })
                })
        }
    }
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: () -> Void) {
        // thêm user vào database
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
}








