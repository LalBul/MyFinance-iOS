//
//  ViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import UIKit
import RealmSwift
import Charts
import SwipeCellKit
import ColorSlider
import ChameleonFramework

class MainScreenViewController: UIViewController {


    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var chartView: PieChartView!
    
    var downloadDataEnty: [PieChartDataEntry] = []
    var realm = try! Realm()
    var categoryArray: Results<Category>?
    var items: Results<Items>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateChartData()
        mainTableView.backgroundColor = UIColor(red: 0.07, green: 0.15, blue: 0.26, alpha: 1.00)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        viewCategory.layer.cornerRadius = 30
        mainTableView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear (_ animated: Bool) {
        updateChartData()
    }
    
    private func updateChartData() {
        
        downloadDataEnty = []
        categoryArray = realm.objects(Category.self)

        if let array = categoryArray {
            for i in array {
                let newPieChartData = PieChartDataEntry()
                newPieChartData.value = i.items.sum(ofProperty: "amount")
                newPieChartData.label = i.title
                downloadDataEnty.append(newPieChartData)
            }
        }

        let allAmount: Double = realm.objects(Items.self).sum(ofProperty: "amount")  // Сумма покупок за всё время
        chartView.centerText = String(allAmount)
        
        let dataSet = PieChartDataSet(entries: downloadDataEnty, label: nil)
        let colors = [UIColor(.black), UIColor(.gray)]
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data

        chartView.entryLabelColor = .white
        
        mainTableView.reloadData()
        
    }
    
    
//MARK: - Add Category
    
    @IBOutlet weak var addCategoryUIView: UIView!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryText: UITextField!
    
    private var blurEffectView = UIVisualEffectView()
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        colorView.layer.cornerRadius = 10
        colorView.backgroundColor = HexColor("#132743")
       
        
        addCategoryUIView.layer.cornerRadius = 20
        addCategoryUIView.center = view.center
        addCategoryUIView.transform = CGAffineTransform(scaleX: 0.05, y: 0.1)
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        categoryText.layer.cornerRadius = 10
        categoryText.attributedPlaceholder = NSAttributedString(string: "Add new category", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.08, green: 0.13, blue: 0.22, alpha: 1.00)])
       
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(addCategoryUIView)
        
        UIView.animate(withDuration: 0.3) {
            
            self.addCategoryUIView.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func addCategoryCancel(_ sender: UIButton) {
        backAnimate()
        self.blurEffectView.removeFromSuperview()
    }
    
    @IBAction func addCategoryButton(_ sender: UIButton) {
        
        if let category = categoryText.text {
            var colorHex: String = "132743"
            if let color = colorView.backgroundColor {
                colorHex = color.hexValue()
            }
            
            let newCategory = Category()
            newCategory.title = category
            do {
                try realm.write {
                    realm.add(newCategory)
                    updateChartData()
                    backAnimate()
                }
            } catch {
                print("Error added new Category")
            }
        }
    }
    
    func backAnimate() {
        categoryText.text = ""
        UIView.animate(withDuration: 0.3) {
            self.addCategoryUIView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            self.addCategoryUIView.removeFromSuperview()
        }
    }
    
//MARK: - Color Settings
    
    @IBOutlet weak var colorSettingsUIView: UIView!
    
    @IBOutlet weak var colorSlider: UIView!
    @IBOutlet weak var demonstrationView: UIView!
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        demonstrationView.backgroundColor = color
    }
    
    @IBAction func toColourSettings(_ sender: UIButton) {
        
        let previewColorSlider = DefaultPreviewView()
        previewColorSlider.side = .right
        previewColorSlider.animationDuration = 0
        previewColorSlider.offsetAmount = 10

        let newColorSlider = ColorSlider(orientation: .horizontal, previewView: previewColorSlider)
        newColorSlider.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        newColorSlider.center.x = colorSlider.center.x
        newColorSlider.center.y = newColorSlider.center.y + 25
        newColorSlider.addTarget(nil, action: #selector(changedColor(_:)), for: .valueChanged)
        
        colorSettingsUIView.center = view.center
        view.addSubview(colorSettingsUIView)
        colorSlider.addSubview(newColorSlider)
        
    }
    
    
    @IBAction func addColor(_ sender: UIButton) {
        colorView.backgroundColor = demonstrationView.backgroundColor
        colorSettingsUIView.removeFromSuperview()
        
    }
    
    
    @IBAction func toBackFromColourSettings(_ sender: UIButton) {
        colorSettingsUIView.removeFromSuperview()
    }
    
}

//MARK: - Table View

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { swipeAction, indexPath in
            
            if let array = self.categoryArray {
                do {
                    try self.realm.write {
                        self.realm.delete(array[indexPath.row].items)
                        self.realm.delete(array[indexPath.row])
                        self.updateChartData()
                    }
                } catch {
                    print("Delete error")
                }
                
            }
            
        }
        return [deleteAction]
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ItemsViewController
            if let indexPath = mainTableView.indexPathForSelectedRow {
                if let category = categoryArray?[indexPath.row] {
                    destinationVC.selectedCategory = category
                    destinationVC.title = category.title
                }
            }
        }
        
    }
    
    

}

