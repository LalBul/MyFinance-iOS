//
//  InformationViewController.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        if let dateNoNil = date {
            dateLabel.text = "Data - \(formatter.string(from: dateNoNil))"
        }
        amountLabel.text = "Amount - \(String(amount))"
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var amount: Double = 0
    var date: Date?

    

}
