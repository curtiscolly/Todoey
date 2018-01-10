//
//  ViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/9/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // Store Key => Value pairs for users
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Optional loading if there are items in the array
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
       
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                                                 // Prototype Cell Identifier = ToDoItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Labeling the cell with the items from the array
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    
    //MARK  - TableView Delegate Methods
    // Does something when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        
        // Grab a reference to the cell that is at a particular index path
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none

        } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert
        
            // later on, we might want to prevent the item from going through if
            // the user typed nothing into the textfield
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") // the key is going to identify this array through our user defaults
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField // alertTextField is scope is limited to this closure, so we have to widen it
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
    
    
    



}

