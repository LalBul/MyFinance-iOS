//
//  InterfaceController.swift
//  AWVersion Extension
//
//  Created by Вова Сербин on 17.05.2021.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var mainTable: WKInterfaceTable!
    
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session.delegate = self
        session.activate()
    }
    
    var categoryCount: Int = 0
    var categoryNames: [String] = []
 
    override func willActivate() {
        super.willActivate()
        updateTable()
        print(categoryCount)
        print(categoryNames)
   
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func updateTable() {
        if categoryCount > 0 {
            print(categoryNames)
            mainTable.setNumberOfRows(categoryCount, withRowType: "cell")
            print("row = ", categoryCount)
            for index in 0..<categoryNames.count {
                let cell = mainTable.rowController(at: index) as? Row
                cell?.label.setText(String(categoryNames[index]))
                continue
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
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Popal")
        if let count = applicationContext["categoryCount"] as? Int, let names = applicationContext["categoryNames"] as? [String] {
            categoryCount = count
            categoryNames = names
        }
    }
    
}

