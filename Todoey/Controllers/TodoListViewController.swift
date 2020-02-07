//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

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
            // so here we know we did select a Category, so we can load items
            // that belong to that category.
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
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
        return todoItems?.count ?? 1
    }
    
    // this is called initially when table is loaded up so setting accosoryType here makes no sense
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // this is where we update realm db.  This is where we select
        // a cell inside tableView in order to check or uncheck it by
        // updating 'done' property.  todoItems is container that fetches
        // from realm, so grab item that is selected.
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems() // Commit context to persist it to our persistant container
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// create extension of our view controller to split out functionality of our
// view controller and have specific parts responsible for specific things like
// here in case of search bar.  This modularizing helps make it easier to maintain
// an app as you can test separately to that extension.  This will add extension
// similar to how MARK areas add area in drop down when you tap on your view
// controller at the top.
// This is preered way to group by protocol methods in MVC
// UISearchBarDelegate - makes our viewcontroller search bar delegate
//MARK: - Search bar methods
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // query and reload our tableview on search
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        // tag on query to specify what to return.  for that we use
//        // NSPredicate to look for title attribute of each Item in item array
//        // providing argument to go into %@.  So, whatever we typed into search
//        // bar is passed into argument %@ when we hit Search.  So our query becomes
//        // "for all items in the items array, look for ones where title contains
//        // whatever we typed into the search bar".
//        // cd = case and diacritic insensitive sensitive
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sorting
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //triggered on text change.  We will use this to trigger only when text is
//        // cleared to go back to original list of items that is not filtered
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            // dismiss keyboard when search bar does not have cursor by telling
//            // the search bar to stop being first responder.  So, since no longer cursor,
//            // no longer keyboard.  Do this on main thread since it is UI
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

