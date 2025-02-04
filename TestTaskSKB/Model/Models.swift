//
//  Models.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import Foundation

struct Transaction {
    let sku: String
    let currency: String
    let amount: Decimal
}

struct Rate {
    let from: String
    let to: String
    let rate: Decimal
}
