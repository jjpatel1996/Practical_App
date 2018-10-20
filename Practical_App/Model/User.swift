//
//  User.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import Foundation

struct Users : Decodable {
    
    var total_count:Int = 0
    var items:[Item] = [Item]()
    var searchBarText:String?
    var nextListLink:String?
    
    mutating func reset(){
        total_count = 0
        items.removeAll()
    }
    
}

struct Item : Decodable {
    var login:String
    var avatar_url:String
    var type:String
    var site_admin:Bool
    var score:Double
}

