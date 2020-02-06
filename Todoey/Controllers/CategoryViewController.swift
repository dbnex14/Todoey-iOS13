//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dino B on 2020-02-03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    // According to Realm documentation, the irst time you create a new
    // Realm instance, it can fail if your resources re constrained.
    // But in practice, this can happen only first time Realm instance is
    // created on a given thread.  So, even though using "try!" is a code smell
    // if you look at Realm documentation, this is perfectly valid.
    let realm = try! Realm()  // requires importing RealmSwift
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            // what happens when user clicks Add button
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categories.append(newCategory)
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create reusable cell and add it to the table at indes path
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        // return cell so it is rendered on the screen
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Triggered when we select one of the cells (category) and we want to
        // use that to navigate to that category and show its items.  So, we need
        // to trigger goToItems segue here.  But before we do that, we need to do
        // some preparation for the next view controller by initializing itemArray
        // inside the TodoListViewController with items that belong to the selected
        // category here.  We do that prep in prepare for segue delegate below.
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // here we want to initialize itemArray inside the TodoListViewController
        // with items that belong to the selected category in the above didSelectRowAt
        // delegate method.  This is triggered just before we perform this segue.
        let destinationVC = segue.destination as! TodoListViewController
        // grab the category that correpsond to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    func loadCategories() {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//        
//        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
}
