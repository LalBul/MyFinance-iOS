//
//  Category.swift
//  MyFinance
//
//  Created by Вова Сербин on 01.05.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var color: String = "132743"
    let items = List<Items>()
}
