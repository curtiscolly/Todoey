//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/12/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    
    // Handles CRUD operations
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        loadCategories()
       

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Prototype Cell Identifier = CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        // Labeling the cell with the items from the array
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK - Model Manipulation Methods
    
    func saveCategories() {
        
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    //Retrieving Data
    // with = external param request = internal param   //Default Value
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
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
            let newCategory = Category(context: self.context)

            newCategory.name = textField.text!

            self.categoryArray.append(newCategory)

            self.saveCategories()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField // alertTextField is scope is limited to this closure, so we have to widen it

        }

        alert.addAction(action)

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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
 
    
   
    
    
}
