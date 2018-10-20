//
//  UserCollectionViewCell.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    //UserCellID2
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    var item:Item? {
        didSet{
            guard item != nil else { return }
            loginLabel.text = item!.login
            avatarImageView.kf.setImage(with: URL(string: item!.avatar_url))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        avatarImageView.layer.cornerRadius = 12
//        avatarImageView.layer.masksToBounds = true
    }
    
    
}
