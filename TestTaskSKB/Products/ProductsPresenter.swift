//
//  ProductsPresenter.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

final class ProductsPresenter: ProductsPresenterProtocol {
    
    weak var view: ProductsViewProtocol?
    
    let ratesService: RatesService
    let transactionsService: TransactionsService
    
    private var skus: [String] = []
    
    init(ratesService: RatesService,
         transactionsService: TransactionsService) {
        self.ratesService = ratesService
        self.transactionsService = transactionsService
        loadData()
    }
    
    private func loadData() {
        skus = transactionsService.distinctSKUs()
        view?.reloadData()
    }
    
    var numberOfProducts: Int {
        skus.count
    }
    
    func productSKU(at index: Int) -> String {
        skus[index]
    }
    
    func transactionCount(for index: Int) -> Int {
        let sku = skus[index]
        return transactionsService.transactions(for: sku).count
    }
    
    func didSelectProduct(at index: Int) {
        let sku = skus[index]
        view?.showDetails(for: sku)
    }
}
