//
//  RatesService.swift
//  TestTaskSKB
//
//  Created by Artur Gaisin on 04.02.2025.
//

import Foundation

final class RatesService {
    private var rates: [Rate] = []
    private var graph: [String: [String: Decimal]] = [:]
    
    init() {
        loadRates()
        buildGraph()
    }
    
    private func loadRates() {
        guard let url = Bundle.main.url(forResource: "rates", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            debugPrint("rates.plist not found or data is nil")
            return
        }
        
        do {
            if let plistArray = try PropertyListSerialization.propertyList(
                from: data, options: [], format: nil
            ) as? [[String: Any]] {
                self.rates = plistArray.compactMap { dict in
                    guard
                        let from = dict["from"] as? String,
                        let to   = dict["to"]   as? String,
                        let rateStr = dict["rate"] as? String,
                        let rateDecimal = Decimal(string: rateStr)
                    else {
                        debugPrint("Invalid rate dict: \(dict)")
                        return nil
                    }
                    return Rate(from: from, to: to, rate: rateDecimal)
                }
            }
        } catch {
            debugPrint("Error parsing rates.plist: \(error)")
        }
    }
    
    private func buildGraph() {
        for rate in rates {
            graph[rate.from, default: [:]][rate.to] = rate.rate
        }
    }
    
    func convert(amount: Decimal, from: String, to: String) -> Decimal? {
        if from == to {
            return amount
        }
        guard let pathRate = findRatePath(from: from, to: to, visited: []) else {
            debugPrint("No conversion path from \(from) to \(to)")
            return nil
        }
        return amount * pathRate
    }
    
    private func findRatePath(from: String,
                              to: String,
                              visited: Set<String>) -> Decimal? {
        
        var visited = visited
        visited.insert(from)
        
        guard let edges = graph[from] else { return nil }
        
        if let directRate = edges[to] {
            return directRate
        }
        
        for (adjCurrency, rate) in edges {
            if !visited.contains(adjCurrency),
               let subRate = findRatePath(from: adjCurrency, to: to, visited: visited) {
                return rate * subRate
            }
        }
        return nil
    }
}
