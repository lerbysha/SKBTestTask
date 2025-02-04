//
//  TransactionsService.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import Foundation

final class TransactionsService {
    private var transactionsBySKU: [String: [Transaction]] = [:]

    init() {
        loadTransactions()
    }
    
    private func loadTransactions() {
        guard let url = Bundle.main.url(forResource: "transactions", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            debugPrint("transactions.plist not found or data is nil")
            return
        }
        
        do {
            if let plistArray = try PropertyListSerialization.propertyList(
                from: data, options: [], format: nil
            ) as? [[String: Any]] {
                for dict in plistArray {
                    guard
                        let sku = dict["sku"] as? String,
                        let currency = dict["currency"] as? String,
                        let amountStr = dict["amount"] as? String,
                        let amount = Decimal(string: amountStr) else {
                        debugPrint("Invalid transaction dict: \(dict)")
                        continue
                    }
                    let transaction = Transaction(sku: sku, currency: currency, amount: amount)
                    transactionsBySKU[sku, default: []].append(transaction)
                }
            }
        } catch {
            debugPrint("Error parsing transactions.plist: \(error)")
        }
    }

    func transactions(for sku: String) -> [Transaction] {
        return transactionsBySKU[sku] ?? []
    }

    func distinctSKUs() -> [String] {
        return Array(transactionsBySKU.keys).sorted()
    }
}
