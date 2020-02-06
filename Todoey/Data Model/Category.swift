//
//  Category.swift
//  Todoey
//
//  Created by Dino B on 2020-02-06.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // forward relationship to Item: Each Category has Items (1:M)
    let items = List<Item>()
}
