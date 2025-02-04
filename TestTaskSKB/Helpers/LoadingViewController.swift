//
//  LoadingViewController.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import UIKit
import SnapKit

final class LoadingViewController: UIViewController {
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(label)
        label.text = "Loading..."
        label.textColor = .darkGray
        label.textAlignment = .center

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

