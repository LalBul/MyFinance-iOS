//
//  Items.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var amount: Double = 0
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
