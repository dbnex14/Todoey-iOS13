//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dino B on 2020-02-03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Tap into superclass method to get the cell
        //NOTE: For both ToDoListViewController and CategoryViewController
        // we need to set the Class to SwipeTableViewCell and Module to
        // SwipeCellKit in main.storyboard, when you select "Cell" for
        // these 2 view controllers and go to IdentiyInspector in upper
        // right corner.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // .. and then add more information like the text for textLabel.
        // This is needed since our superclass cannot know about Category
        // or item, we only know that here, that is why we overrode this
        // same method in the superclass to set parts there and parts here.
        // So, when this gets cßalled, it first goes to superclass to create
        // new cell as SwipeTableCell, sets it as delegate and then returns
        // it here where we set textLabel and return it to our current
        // TableView inside CategoryViewController class.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        // modify cell color using Chameleon randomFlat()
        //cell.backgroundColor = UIColor.randomFlat()
        
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
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        // no need for this since it is empty in superclass
        //super.updateModel(at: indexPath)
        
        // This override then deletes a Category, so specific only to
        // Categories.  It is overriden from super class.
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}
