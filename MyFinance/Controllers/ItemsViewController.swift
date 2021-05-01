//
//  ItemsViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import UIKit
import RealmSwift

class ItemsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    let realm = try! Realm()
    var items: Results<Items>?
    
    var selectedCategory: Category?
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        var textField1 = UITextField()
        var textField2 = UITextField()
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Title"
            textField1 = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Amount"
            textField2 = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            if let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField1.text!
                        if let text2 = textField2.text {
                            guard let amountDouble = Double(text2) else {fatalError("Error converting in Double")}
                            newItem.amount = amountDouble
                        }
                        newItem.date = Date()
                        category.items.append(newItem)
                        self.realm.add(newItem)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error adding Item")
                }
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items?.count ?? 1
   }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath)
       if let item = items?[indexPath.row] {
        cell.textLabel?.text = item.title
       }
       return cell
   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToInformation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! InformationViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if let item = items?[indexPath.row] {
                destinationVC.amount = item.amount
                destinationVC.date = item.date
            }
        }
    }
    
   
    
    
    
    
    
}
