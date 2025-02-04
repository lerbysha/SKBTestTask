//
//  TransactionsService.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import Foundation

final class TransactionsService {
    private var transactions: [Transaction] = []
    
    init() {
        loadTransactions()
    }
    
    private func loadTransactions() {
        guard let url = Bundle.main.url(forResource: "transactions", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            debugPrint(" transactions.plist not found or data is nil")
            return
        }
        
        do {
            if let plistArray = try PropertyListSerialization.propertyList(
                from: data, options: [], format: nil
            ) as? [[String: Any]] {
                self.transactions = plistArray.compactMap { dict in
                    guard
                        let sku = dict["sku"] as? String,
                        let currency = dict["currency"] as? String,
                        let amountStr = dict["amount"] as? String,
                        let amountDecimal = Decimal(string: amountStr)
                    else {
                        debugPrint("Invalid transaction dict: \(dict)")
                        return nil
                    }
                    return Transaction(sku: sku, currency: currency, amount: amountDecimal)
                }
            }
        } catch {
            debugPrint("Error parsing transactions.plist: \(error)")
        }
    }
    
    func allTransactions() -> [Transaction] {
        transactions
    }
    
    func transactions(for sku: String) -> [Transaction] {
        transactions.filter { $0.sku == sku }
    }
    
    func distinctSKUs() -> [String] {
        Array(Set(transactions.map { $0.sku })).sorted()
    }
}
