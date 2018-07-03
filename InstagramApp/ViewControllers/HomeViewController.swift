//
//  HomeViewController.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 28/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

// 8:13 Ep 24

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPost()
//        let post = Post(captionText: "test", photoUrlString: "url")
//        print(post.caption)
    }
    
    func loadPost() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
    }

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
    
    
    
    
   
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.item].caption
        return cell
    }
}









