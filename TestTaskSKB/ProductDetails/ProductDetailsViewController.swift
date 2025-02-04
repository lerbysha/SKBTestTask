//
//  ProductDetailsViewController.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import UIKit
import SnapKit

final class ProductDetailsViewController: UIViewController {
    
    private let presenter: ProductDetailsPresenter
    private let totalLabel = UILabel()
    private let tableView = UITableView()
    
    init(presenter: ProductDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        view.backgroundColor = .white
        setupUI()
        presenter.loadData()
    }
    
    private func setupUI() {
        view.addSubview(totalLabel)
        view.addSubview(tableView)
        
        totalLabel.textAlignment = .center
        totalLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    }
}

// MARK: - ProductDetailsViewProtocol
extension ProductDetailsViewController: ProductDetailsViewProtocol {
    func showTitle(_ text: String) {
        totalLabel.text = text
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTransactions
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let original = presenter.originalAmountText(at: indexPath.row)
        let converted = presenter.convertedAmountText(at: indexPath.row)
        cell.textLabel?.text = "\(original) → \(converted)"
        return cell
    }
}
