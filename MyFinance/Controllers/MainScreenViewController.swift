//
//  ViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import UIKit
import RealmSwift

class MainScreenViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var sumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let i: Double = realm.objects(Items.self).sum(ofProperty: "amount")
        sumLabel.text = "В этом месяце вы потратили: \(String(i))"
        print(i)
        
    }
    
        
    var realm = try! Realm()
    var categoryArray: Results<Category>?
    var items: Results<Items>?

    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { alertAction in
            let newCategory = Category()
            if let text = textField.text {
                newCategory.title = text
            }
            do {
                try self.realm.write {
                    self.realm.add(newCategory)
                    self.mainTableView.reloadData()
                }
            } catch {
                print("Error adding realm data Category")
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func loadCategory() {
        categoryArray = realm.objects(Category.self)
    }
    
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsViewController
        if let indexPath = mainTableView.indexPathForSelectedRow {
            if let category = categoryArray?[indexPath.row] {
                destinationVC.selectedCategory = category
            }
        }
    }
    
    

}

