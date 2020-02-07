//
//  Item.swift
//  Todoey
//
//  Created by Dino B on 2020-02-06.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// Also subclass Realm Object so we can save to Realm DB.
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // Inverse relationship to parent Category linking each
    // item to its parent Category so we specify the type,
    // hence "Category.self" and the property name of the
    // inverse relationship which relates to Category.Items
    // property in Category data model.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
