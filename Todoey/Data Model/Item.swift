//
//  Item.swift
//  Todoey
//
//  Created by Curtis Colly on 1/10/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import Foundation


// For a class to be able to be encodable, all of
// it's properties must have standard data types, not custom classes

// Codable means that this model conforms to both Encodable and Decodable standards
class Item: Codable {
    
    var title : String = ""
    var done  : Bool = false

}
