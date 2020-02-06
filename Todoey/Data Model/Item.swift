//
//  Item.swift
//  Todoey
//
//  Created by Dino B on 2020-02-06.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    // inverse relationship to parent Category (note that is type; hence, ".self"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
