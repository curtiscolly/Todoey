//
//  ViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/9/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
        // searchBar.delegate = self -- I added the delegate from teh storyboard, so I don't need this
    
        loadItems()
        
        
        
        // Optional loading if there are items in the array
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
       
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "YourCellXibName", bundle: nil), forCellReuseIdentifier: "Cell")
        
                                                 // Prototype Cell Identifier = ToDoItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Labeling the cell with the items from the array
        cell.textLabel?.text = item.title
        
        //Ternary operator
        // value = condition ? valueIfTrue : ValueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    //MARK  - TableView Delegate Methods
    // Does something when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
//        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row]) // deletes from temp area
//        itemArray.remove(at: indexPath.row) // does nothing for our core data, just updates the item array
       
        
        // commits to our db
        saveItems()
       
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
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done  = false
           
            self.itemArray.append(newItem)

            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField // alertTextField is scope is limited to this closure, so we have to widen it
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        
        
        do{
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
   
    //Retrieving Data
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
       
        
    }
    


}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    // Tells the delegate that the search bar was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
    }
    
}

