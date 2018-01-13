//
//  ViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/9/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        // as soon as the selected category gets set with a value, didSet executes
        didSet{
             loadItems()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                                                 // Prototype Cell Identifier = ToDoItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            // Labeling the cell with the items from the array
            cell.textLabel?.text = item.title
            
            //Ternary operator
            // value = condition ? valueIfTrue : ValueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    //MARK  - TableView Delegate Methods
    // Does something when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item  = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        // commits to our db
//        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert
            
           
            if let currentCategory = self.selectedCategory {
                
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem) // append the new item to this category
                }
                } catch {
                    print("Error saving new items, \(error)" )
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField // alertTextField is scope is limited to this closure, so we have to widen it
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
 
    //Retrieving Data
    // with = external param request = internal param   //Default Value
    //MARK - loadItems
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        // optional binding
//        // The bottom statement is used instead of this one:
//        // let compoundPredicate = NSCompoundPredicate(andPredicateWithSubPredicates: [categoryPredicate, predicate])
//        // request.predicate = predicate
//        if let additionalPredicate = predicate {
//            // If predicate is not nil do this
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else {
//            // if predicate is nil do this
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }

        tableView.reloadData()
    }
    
}


//MARK: - Search bar methods
//
extension TodoListViewController: UISearchBarDelegate {

    // Tells the delegate that the search bar was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    // Every letter typed in initiates this method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // If the search box has been cleared
        if searchBar.text?.count == 0 {
            loadItems()


            // Run the resign method on the main queue
            DispatchQueue.main.async {

                // Removes the cursor from inside the search bar
                searchBar.resignFirstResponder()
            }


        }
    }

}


