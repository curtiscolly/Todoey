//
//  Data.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
