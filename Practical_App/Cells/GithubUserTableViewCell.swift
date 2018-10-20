//
//  GithubUserTableViewCell.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import UIKit
import Kingfisher

class GithubUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var siteadminLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var item:Item? {
        didSet{
            guard item != nil else { return }
            userNameLabel.text = item!.login
            scoreLabel.text = "\(item!.score)"
            siteadminLabel.text = item!.site_admin ? "Admin:  ✅" : "Admin:  ❎"
            typeLabel.text = "#\(item!.type)"
            userAvatarView.kf.setImage(with: URL(string: item!.avatar_url))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userAvatarView.layer.cornerRadius = 8
        userAvatarView.layer.masksToBounds = true
    }


}
