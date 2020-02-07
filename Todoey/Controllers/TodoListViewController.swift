//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

// Using Realm is much simpler than using CoreData.  In addition to its
// simplicity, it is also lots faster than CoreData or SqLite.  Realm is
// double fast as SQLite and much much more faster than CoreData.  But it
// has lots of other benefits, look at REalm blog.
class TodoListViewController: UITableViewController {

    // Collection of Results that are Item objects
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    // This is optional because it will be nil until we set it in
    // prepare segue inside CategoryViewController.  But once we
    // set it, that is the time point when we want to loadItems()
    // that belong to this category.  For that, we use special
    // keyword didSet which will execute as soon as selectedCategory
    // gets set up with a value.
    var selectedCategory: Category? { // optional Category
        didSet {
            // So here we know we did select a Category, so we can
            // load items that belong to that category.
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //print(textField.text) // now we can print local var
            // Look is our selectedCategory is nil becaue it is optional before updating
            // Realm DB.
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        // Append the newly created item to list of items in this Category.
                        // realm.write will then commit all that to the DB.
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        // add text field to alert called alertTextField
        // note that this closure is executed only once the
        // text field has been added to the alert, so printing
        // from it makes no sense
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //store to local var so we can print
            //print(alertTextField.text) //hence, this prints nothing
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If none, just return one cell with "No Items Added"
        // text label
        return todoItems?.count ?? 1
    }
    
    // this is called initially when table is loaded up so setting accosoryType
    // here makes no sense
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            // If no todo Items, so we just created this dummy one.
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This is where we update realm db.  This is where we select
        // a cell inside tableView in order to check or uncheck it by
        // updating 'done' property.  todoItems is container that
        // fetches from realm, so grab item that is selected.
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done // update
                    // to delete item, we just do this instead to update but we
                    // will make delete better by implementing it other way.
                    //realm.delete(item) //delete
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// create extension of our view controller to split out functionality
// of our view controller and have specific parts responsible for
// specific things like here in case of search bar.  This modularizing
// helps make it easier to maintain an app as you can test separately
// to that extension.  This will add extension similar to how MARK areas
// add area in drop down when you tap on your view controller at the top.
// This is prefered way to group by protocol methods in MVC
// UISearchBarDelegate - makes our viewcontroller search bar delegate
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Filter our todoItems by use NSPredicate to look for title
        // attribute of each Item in item array providing argument to
        // go into %@.  So, whatever we typed into search bar is passed
        // into argument %@ when we hit Search.  So our query becomes
        // "for all items in the items array, look for ones where title
        // contains whatever we typed into the search bar".
        // "title CONTAINS[cd] %@" is predicate
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // What should happen when we dismiss the search bar is handled here.
        // Triggered on text change.  We will use this to trigger only when text is
        // cleared to go back to original list of items that is not filtered
        if searchBar.text?.count == 0 {
            loadItems()

            // dismiss keyboard when search bar does not have cursor by telling
            // the search bar to stop being first responder.  So, since no longer cursor,
            // no longer keyboard.  Do this on main thread since it is UI
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

