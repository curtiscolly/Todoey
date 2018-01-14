//
//  ViewController.swift
//  Todoey
//
//  Created by Curtis Colly on 1/9/18.
//  Copyright © 2018 Snaap. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        // as soon as the selected category gets set with a value, didSet executes
        didSet{
             loadItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
       
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            if let navBarColor = UIColor(hexString: colorHex) {
                
                navBar.barTintColor = navBarColor
                
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                if #available(iOS 11.0, *) { //<-- this is only available on later versions of iOS
                    navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true) ]
                } else {
                    // Fallback on earlier versions
                }
                
                searchBar.barTintColor = navBarColor
                
            }
            
        }
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    // Method for populating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {

            // Labeling the cell with the items from the array
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
          
            
            

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

        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
       
        if let item  = todoItems?[indexPath.row]{
            do{
                try realm.write {
            
                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
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




