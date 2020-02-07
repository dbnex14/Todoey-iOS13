//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dino B on 2020-02-03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    // According to Realm documentation, the irst time you create a new
    // Realm instance, it can fail if your resources re constrained.
    // But in practice, this can happen only first time Realm instance
    // is created on a given thread.  So, even though using "try!"
    // is a code smell if you look at Realm documentation, this is
    // perfectly valid.
    let realm = try! Realm()  // requires importing RealmSwift
    
    // Results is realms auto-updating container type that gets
    // return to you whenever you query a database.  However,
    // force-unwrapping like below is not ideal because what
    // happens if you forgot to call loadCategories in viewDidLoad,
    // it will be nil.
    //var categories: Results<Category>!
    // , so better make it optional so we can be safe.
    var categories: Results<Category>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // Create an alert with with Text field and Add action.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            // When user clicks on that Add button, we create a
            // new Category and save it to Realm DB.
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If categories is not nil (?); then return count; else, it
        // simply returns 1 cell and that cell will then have text
        // label saying "No Categories Added Yet" as shown below.
        // This is called nil coalescining operator in swift
        return categories?.count ?? 1
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create reusable cell and add it to the table at indes path
        // we cast it down to SwipeTableViewCell which is commint from SwipeCellKit cocoapod
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        // Again use of nil coalescing operator
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.delegate = self //SwipeCellKit cocoapod
        // Return cell so it is rendered on the screen
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When we click on a cell, we fire this didSelectRowAt
        // indexPath method and we perform a segue with its id that
        // takes us to ToDoListViewController.
        // Triggered when we select one of the cells (category) and
        // we want to use that to navigate to that category and show
        // its items.  So, we need to trigger goToItems segue here.
        // But before we do that, we need to do some preparation for
        // the next view controller by initializing itemArray
        // inside the TodoListViewController with items that belong
        // to the selected category here.  We do that prep in prepare
        // for segue delegate below.
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // But before we perform the segue above, we need to prepare by
    // creating new instance of our destination viewController and
    // set its selectedCategory property to the category we selected.
    // That takes us to our ToDoListViewController selectCategory
    // property.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Here we want to initialize itemArray inside the
        // TodoListViewController with items that belong to the
        // selected category in the above didSelectRowAt
        // delegate method.  This is triggered just before we perform
        // this segue.
        let destinationVC = segue.destination as! TodoListViewController
        // Grab the category that correpsond to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            // Again nil coalescing operator just without ??
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadCategories() {
        // Fetch all objects that bellong to the Category
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        // We receive Category to save
        do {
            // Write is called to commit changes to Realm DB, in
            // this case to save to DB.
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARK: SwipeCell Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // check that orientation of the swipe is from the right
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // closure to handle when cell gets swipted
            // action by updating model with deletion
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
                //tableView.reloadData()
            }
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
}
