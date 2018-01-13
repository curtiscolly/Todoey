//
//  Item.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated:  Date?
    
    // Used to specify an inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
