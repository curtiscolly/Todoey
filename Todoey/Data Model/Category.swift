//
//  Category.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = "" // dynamic means we can monitor this variable during runtime
    let items = List<Item>() // One to Many relationship, each category will have a list of items
}
