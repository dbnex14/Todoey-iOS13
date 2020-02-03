//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems() // uses default
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks Add Item button on our UIAlert
            //print(textField.text) // now we can print local var
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            // persist data to NSUserDefaults
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
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
    // we add external parameter 'with' in addition to internal param 'request'
    // so that we  can call this method like loadItems(with: request).
    // we provide default value after '=' sign so we can call this method with
    // or without parameters passed in.
    // So, we have here an external, internal and default parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        // here we are using core data.  In swift, there are very few cases where
        // you need to specify data type like here "Item".  Swift figures that out
        // but here we have to do that.
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
//    func loadItems() {
        // here we are using encoding/decoding
//        if let data = try? Data.init(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                // we have to provide the data type since swift was unable to reliable infer.
//                // It is an array of Item but because we are not specifying object but type, we
//                // have to also write .self and then we also pass our data to it.
//                // since it throws error, we have to mark it with try and do it inside do block.
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
//    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // reload tableView to refresh and show on ui
        tableView.reloadData()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // this is called initially when table is loaded up so setting accosoryType here makes no sense
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        // To delete we remove from context then from array. Note that this
//        // order is important since you change indexPath.row when you remove from
//        // array which will cause app to crash if we want to delete last item or
//        // to remove wrong item(s) if we try to remove other than last item.
//        // Also, just deleting deletes just temporary data which is our context.
//        // We must call save on our context which we do in saveItems() call
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems() // Commit context to persist it to our persistant container
        
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
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query and reload our tableview on search
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // tag on query to specify what to return.  for that we use
        // NSPredicate to look for title attribute of each Item in item array
        // providing argument to go into %@.  So, whatever we typed into search
        // bar is passed into argument %@ when we hit Search.  So our query becomes
        // "for all items in the items array, look for ones where title contains
        // whatever we typed into the search bar".
        // cd = case and diacritic insensitive sensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sorting
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //triggered on text change.  We will use this to trigger only when text is
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

