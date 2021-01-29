//
//  Item.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/27/20.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var time: Int = 0
    @objc dynamic var important: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
