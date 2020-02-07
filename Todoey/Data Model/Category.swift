//
//  Category.swift
//  Todoey
//
//  Created by Dino B on 2020-02-06.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// This is Realm Object so we subclass from Realm Object so we can
// save it to Realm DB.
class Category: Object {
    // Dynamic var so we can monitor changes during run time
    @objc dynamic var name: String = ""
    // Forward relationship to Item: Each Category has Items (1:M)
    let items = List<Item>()
}
