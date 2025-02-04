//
//  ProductsViewProtocol.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

protocol ProductsViewProtocol: AnyObject {
    func reloadData()
    func showDetails(for sku: String)
}

protocol ProductsPresenterProtocol: AnyObject {
    var numberOfProducts: Int { get }
    func productSKU(at index: Int) -> String
    func transactionCount(for index: Int) -> Int
    func didSelectProduct(at index: Int)

    var ratesService: RatesService { get }
    var transactionsService: TransactionsService { get }
}
