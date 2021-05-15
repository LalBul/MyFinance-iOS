//
//  InterfaceController.swift
//  AppleWatchVersion Extension
//
//  Created by Вова Сербин on 14.05.2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var mainCategoryTabel: WKInterfaceTable!
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        session.delegate = self
        session.activate()
        
    }
    
    var categoryCount: Int = 0
    var categoryNames: [String] = []
    
    override func willActivate() {
        updateTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func updateTable() {
        if categoryCount > 0 {
            print(categoryNames)
            mainCategoryTabel.setNumberOfRows(categoryCount, withRowType: "cell")
            print("row = ", categoryCount)
            for index in 0..<categoryCount {
                let cell = mainCategoryTabel.rowController(at: index) as? Row
                cell!.categoryLabel.setText(String(index))
            }
        }
    }

}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        categoryCount = message["categoryCount"] as! Int
        categoryNames = message["categoryNames"] as! [String]
        updateTable()
    }
    
    
    
}
