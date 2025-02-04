//
//  ProductDetailsPresenter.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//
import Foundation

final class ProductDetailsPresenter {
    weak var view: ProductDetailsViewProtocol?
    
    private let ratesService: RatesService
    private let transactionsService: TransactionsService
    private let sku: String
    
    private var transactions: [Transaction] = []
    private var convertedAmounts: [Decimal] = []
    private var totalGBP: Decimal = 0
    
    var numberOfTransactions: Int { transactions.count }
    
    init(ratesService: RatesService,
         transactionsService: TransactionsService,
         sku: String) {
        self.ratesService = ratesService
        self.transactionsService = transactionsService
        self.sku = sku
    }
    
    func loadData() {
        transactions = transactionsService.transactions(for: sku)
        
        convertedAmounts = transactions.map { t in
            ratesService.convert(amount: t.amount,
                                 from: t.currency,
                                 to: "GBP") ?? 0
        }
        totalGBP = convertedAmounts.reduce(0, +)
        view?.showTitle("Total GBP:£ \(totalGBP)")
        view?.reloadData()
    }
    
    func originalAmountText(at index: Int) -> String {
        let t = transactions[index]
        return "\(t.currency) \(t.amount)"
    }
    
    func convertedAmountText(at index: Int) -> String {
        let converted = convertedAmounts[index]
        return "£\(converted)"
    }
}
