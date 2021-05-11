//
//  AddItemViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 08.05.2021.
//

import UIKit
import RealmSwift

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedCategory: Category?
    let realm = try! Realm()
    let itemsView = ItemsViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemName.layer.cornerRadius = 10
        itemName.attributedPlaceholder = NSAttributedString(string: "Waste", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

        numberTextField.keyboardType = .decimalPad
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        dateLabel.text = formatter.string(from: Date())
    }
    
    
    @IBAction func addItem(_ sender: UIButton) {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        if let name = itemName.text, let amount = numberTextField.text, let format = numberFormatter.number(from: amount) {
            guard let amountInDouble = format as? Double else {fatalError("Error converting in Double")}
            let newItem = Items()
            newItem.title = name
            newItem.amount = amountInDouble
            newItem.date = Date()
            do {
                try realm.write {
                    selectedCategory?.items.append(newItem)
                }
            } catch {
                print("Error save new item")
            }
            navigationController?.popViewController(animated: true)
                
        }
        
    }

}
