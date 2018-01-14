//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
       

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Inheriting from the super class // This returns a cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
 
        
        cell.backgroundColor = UIColor.randomFlat
        
        ///cell.backgroundColor = UIColor.randomFlat.hexValue()
        //cell.backgroundColor = UIColor(hexString: String)
        
        return cell
    }
    
    //MARK - Model Manipulation Methods
    
    func save(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving \(error)")
        }
        
        self.tableView.reloadData() // Calls all tableView methods again
        
    }
    
    
    //Retrieving Data
    // with = external param request = internal param   //Default Value
    func loadCategories(){
        
        categories  = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion  = self.categories?[indexPath.row]{

            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)" )
            }

        }
    }
    

    //MARK: - Add New Categories
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        var textField = UITextField()

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert

            // later on, we might want to prevent the item from going through if
            // the user typed nothing into the textfield
            let newCategory = Category()

            newCategory.name = textField.text!
            
            self.save(category: newCategory)
           
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField // alertTextField is scope is limited to this closure, so we have to widen it

        }

    
        present(alert, animated: true, completion: nil)

    
    }
    
    
    //MARK  - TableView Delegate Methods -
    // what should happen when we click on one of the cells inside of the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We would need an if statement if there were multiple segues
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}


