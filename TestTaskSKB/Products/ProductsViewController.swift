//
//  ProductsViewController.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import UIKit
import SnapKit

final class ProductsViewController: UIViewController {
    
    private let presenter: ProductsPresenterProtocol
    private let tableView = UITableView()
    
    init(presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension ProductsViewController: ProductsViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showDetails(for sku: String) {
        let detailsPresenter = ProductDetailsPresenter(
            ratesService: presenter.ratesService,
            transactionsService: presenter.transactionsService,
            sku: sku
        )
        let detailsVC = ProductDetailsViewController(presenter: detailsPresenter)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sku = presenter.productSKU(at: indexPath.row)
        let count = presenter.transactionCount(for: indexPath.row)
        cell.textLabel?.text = "\(sku) — \(count) transactions"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectProduct(at: indexPath.row)
    }
}
