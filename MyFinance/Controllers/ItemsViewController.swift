//
//  ItemsViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class ItemsViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var addItemOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        tableView.rowHeight = 80
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        addItemOutlet.image = UIImage(named: "add")
        defaultValue = defaults.double(forKey: "Limit")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    let realm = try! Realm()
    var items: Results<Items>?
    var selectedCategory: Category?
    let defaults = UserDefaults.standard
    var defaultValue: Double = 0
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "date")
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add Item
    
    @IBOutlet var addItemView: UIView!
    
    @IBOutlet weak var wasteTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var cancelOutlet: UIButton!
    
    private var blurEffectView = UIVisualEffectView()
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        
        tableView.isScrollEnabled = false
        
        addItemView.layer.cornerRadius = 15
        addItemView.center = view.center
        addItemView.center.y += 50
        addItemView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        wasteTextField.attributedPlaceholder = NSAttributedString(string: "What did you spend it on?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        wasteTextField.layer.cornerRadius = 15
        
        amountTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        amountTextField.layer.cornerRadius = 20
        amountTextField.keyboardType = .decimalPad
        
        cancelOutlet.setImage(UIImage(named:"cancel"), for: .normal)
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        view.addSubview(addItemView)
        
        UIView.animate(withDuration: 0.25) {
            self.addItemView.center.y -= 200
            self.addItemView.transform = CGAffineTransform.identity
        } completion: { _ in
            self.navigationController?.navigationBar.isHidden = true
        }
        
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        if let waste = wasteTextField.text, let amount = amountTextField.text {
            var format = numberFormatter.number(from: amount)
            if format == nil {
                numberFormatter.decimalSeparator = "."
                format = numberFormatter.number(from: amount)
            }
            guard let amountInDouble = format as? Double else {fatalError("Error converting in Double")}
            let newItem = Items()
            newItem.date = Date()
            newItem.title = waste
            newItem.amount = amountInDouble
            do {
                try realm.write {
                    selectedCategory?.items.append(newItem)
                    if defaults.double(forKey: "Limit") > 0  {
                        defaults.setValue(defaultValue-amountInDouble, forKey: "Limit")
                    }
                    backAnimate()
                    tableView.reloadData()
                }
            } catch {
                print("Error save item")
            }
        }
    }
    
    
    @IBAction func cancelAddItem(_ sender: UIButton) {
        backAnimate()
    }
    
    func backAnimate() {
        blurEffectView.removeFromSuperview()
        self.navigationController?.navigationBar.isHidden = false
        tableView.isScrollEnabled = true
        wasteTextField.text = ""
        amountTextField.text = ""
        UIView.animate(withDuration: 0.25) {
            self.addItemView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.addItemView.center.y += 500
        } completion: { _ in
            self.addItemView.removeFromSuperview()
        }
    }
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! BuyCell
        cell.delegate = self
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let item = items?[indexPath.row], let itemDate = items?[indexPath.row].date {
            cell.buyName.text = item.title
            cell.buyPrice.text = String(item.amount)
            cell.buyDate.text = formatter.string(from: itemDate)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { swipeAction, indexPath in
            do {
                try self.realm.write {
                    self.realm.delete((self.selectedCategory?.items[indexPath.row])!)
                    tableView.reloadData()
                }
            } catch {
                print("Fail delete cell")
            }
        }
        return [deleteAction]
    }
    
}
