//
//  LimitViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 07.05.2021.
//

import UIKit

class LimitViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in buttons {
            i.layer.cornerRadius = i.frame.size.height / 2
        }
    }
    
    private var pointBool = true
    
    @IBAction func buttons(_ sender: UIButton) {
        if let title = sender.currentTitle {
            if numberLabel.text == "0" {
                if title == "." {
                    numberLabel.text?.append(title)
                    pointBool = false
                } else {
                    numberLabel.text = title
                }
            } else if sender.currentTitle == "." {
                if pointBool == true {
                    numberLabel.text?.append(title)
                    pointBool = false
                } else {return}
            } else {
                numberLabel.text?.append(title)
            }
        }
    }
    
    @IBAction func addLimit(_ sender: UIButton) {
        if let number = numberLabel.text {
            guard let limit = Double(number) else {fatalError("Error converting in Double")}
            defaults.setValue(limit, forKey: "Limit")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        numberLabel.text = "0"
        pointBool = true
    }
    
}
