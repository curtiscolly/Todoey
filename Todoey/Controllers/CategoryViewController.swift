//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        loadCategories()
        
        tableView.rowHeight = 80.0
       

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Prototype Cell Identifier = CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)  as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Selected Yet"
        
        cell.delegate = self
        
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

//MARK: Swipe Cell Delegate Methods
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    // What happens when a user swipes a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let categoryForDeletion  = self.categories?[indexPath.row]{
                
                do{
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)" )
                }
                
               // tableView.reloadData()
            }
            
            
       
            
    
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
