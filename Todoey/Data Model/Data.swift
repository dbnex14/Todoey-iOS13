//
//  Data.swift
//  Todoey
//
//  Created by Dino B on 2020-02-04.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // because we use Realm Object here, we have to mark each property
    // as dynamic.  Dynamic is declaration modifier that tells the runtime
    // to use dynamic dispatch instead of standard static dispatch.  This
    // allows this property to be monitored for changes at runtime, while your
    // app is running.  So, if user changes the value of name for example,
    // that allows Realm to dynamically update these changes in the DB.
    // dynamic commes with ObjectiveC so we have to mark with @objc.
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
