//
//  Category.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/27/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}

