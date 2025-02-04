//
//  AppDelegate.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        
        let loadingVC = LoadingViewController()
        window.rootViewController = loadingVC
        window.makeKeyAndVisible()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let ratesService = RatesService()
            let transactionsService = TransactionsService()
            
            DispatchQueue.main.async {
                self.showProductsScreen(ratesService: ratesService,
                                        transactionsService: transactionsService)
            }
        }
        return true
    }
    
    private func showProductsScreen(ratesService: RatesService,
                                    transactionsService: TransactionsService) {
        
        let productsPresenter = ProductsPresenter(
            ratesService: ratesService,
            transactionsService: transactionsService
        )
        
        let productsVC = ProductsViewController(presenter: productsPresenter)
        productsPresenter.view = productsVC
        
        let navigationController = UINavigationController(rootViewController: productsVC)
        
        window?.rootViewController = navigationController
    }
    
}

