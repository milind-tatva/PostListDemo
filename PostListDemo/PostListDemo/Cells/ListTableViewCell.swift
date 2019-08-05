//
//  ListTableViewCell.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDate      : UILabel!
    @IBOutlet weak var switchToggle : UISwitch!

    static let cell = "ListTableViewCell"

    var post: PostModel! {
        didSet {
            lblTitle.text = post.title
            lblDate.text = post.createdAt
            switchToggle.isOn = post.isPostSelected
        }
    }
    
}
