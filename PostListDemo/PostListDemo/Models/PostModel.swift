//
//  PostModel.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import Foundation
import SwiftyJSON

class PostModel : IsJsonable{
    
    let postID          : String!
    let title           : String!
    let createdAt       : String!
    var isPostSelected  : Bool = false
    
    required init(parameter: JSON) {
        postID         = parameter["objectID"].stringValue
        title          = parameter["title"].stringValue
        createdAt      = parameter["created_at"].stringValue.createdAtString
    }
}
