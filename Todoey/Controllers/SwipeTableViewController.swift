//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Dino B on 2020-02-10.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set item height
        tableView.rowHeight = 80.0
    }
    
    // TableView DataSource Methods
    // here we initialize swipetableviewcell as the default cell for all
    // the tableviews that inherit this class.  This is needed becasue
    // this super class cannot be specific to Category or Item, so it can
    // not know of these.  This will deal with swiping so swiping should
    // therefore not be used in any children of this class but here.  That
    // is why we override this function here.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create reusable cell and add it to the table at indes path
        // we cast it down to SwipeTableViewCell which is commint from SwipeCellKit cocoapod
        // So we renamed string "CategoryCell" to "Cell" to make it
        // more generic but in order to do that, we have to go back to
        // main storyboard and change the identifier for CategoryCell to
        // Cell and also ToDoItemCell to Cell since we want them both the
        // ToDoListViewController and CategoryListViewController to use the
        // Swipe cells from the SwipeTableViewController superclass.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self //SwipeCellKit cocoapod
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // check that orientation of the swipe is from the right
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // closure to handle when cell gets swipted
            // action by updating model with deletion
            print("Delete cell")
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance by adding the image to part of cell when swiped
        // We dont have any images yet but we can get them from the SwipeCellKit cocoapod git.
        // So I downloaded their trashIcon and renamed it inot delete-icon and dragged it into
        // Asserts.xcassets area on XCode and then dragged it into 2x from 1x where it was
        // added automatically.  Then rename below to be "delete-icon" since that is our name.
        deleteAction.image = UIImage(named: "delete-icon")
        
        // return delete action as a response to swipe action
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        // allows to swipe all way to the right to delete
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model.  This has nothing in it but we override
        // it in our children classes to tap into it and do what we need
        // to do specifically to the child class.
        print("Item deleted from superclass")
    }
}
