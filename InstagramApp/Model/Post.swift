//
//  Post.swift
//  InstagramApp
//
//  Created by nguyen van cong linh on 02/07/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import Foundation

class Post {
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
}
