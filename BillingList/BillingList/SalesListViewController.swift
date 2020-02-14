//
//  SalesListViewController.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

protocol FilterProtocol: class {
    func updateFilterValues(_ regions: [String]?, _ states: [String]?, _ cities: [String]?)
}

class SalesListViewController: UIViewController, FilterProtocol {
    
    var isFirstLaunch = true
    var salesArray: [Sales]?
    var filteredSalesArray: [Sales]? {
        didSet {
            tableView.reloadData()
        }
    }
    var regions: [String]!
    var states, cities: [String: [String]]!
    var titles: [String] = [String]()
    
    // Selected filter values by user
    var selectedRegions: [String] = [String]()
    var selectedStates: [String] = [String]()
    var selectedCities: [String] = [String]()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        tableView.backgroundColor = UIColor.darkGray
        navigationItem.title = "Sales List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTap))
        
        initializeTableView()
        initializeDataSource()
    }
    
    func initializeDataSource() {
        if !CoreDataUtils.coreDataIsEmpty() {
            salesArray = CoreDataUtils.fetchAllRows()
            filteredSalesArray = salesArray
            titles = CoreDataUtils.retrieveTitles()
            initializeFilterData()
        }
    }
    
    fileprivate func initializeTableView() {
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.kLightGray
        let tableViewConstraints = NSLayoutConstraint.constraints(with: ["H:|[tableView]|", "V:|[tableView]|"], views: ["tableView": tableView])
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    @objc func filterButtonTap() {
        let filterViewController = FilterViewController()
        let navigationController = UINavigationController(rootViewController: filterViewController)
        filterViewController.initializeFilterData(regions: regions, states: states, cities: cities)
        filterViewController.updateSelectedValues(regions: selectedRegions, states: selectedStates, cities: selectedCities)
        filterViewController.modalPresentationStyle = .formSheet
        filterViewController.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Filter delegate
    
    func updateFilterValues(_ regions: [String]?, _ states: [String]?, _ cities: [String]?) {
        selectedRegions = regions ?? []
        selectedStates = states ?? []
        selectedCities = cities ?? []
        
        filteredSalesArray = salesArray?.filter({
            return selectedRegions.isEmpty || selectedRegions.contains($0.region ?? "")
        }).filter({
            return selectedStates.isEmpty || selectedStates.contains($0.state ?? "")
        }).filter({
            return selectedCities.isEmpty || selectedCities.contains($0.city ?? "")
        })
    }
}

// MARK: - Tableview datasource methods

extension SalesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSalesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "saleCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "saleCell")
        }
        if let saleObj = filteredSalesArray?[indexPath.row] {
            cell?.selectionStyle = .none
            cell?.textLabel?.text = String(saleObj.postalCode)
            cell?.detailTextLabel?.text = saleObj.amount
        }
        return cell ?? UITableViewCell(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier) as? TableHeaderView, titles.count == 5 else {
            return nil
        }
        header.configure(pincodeText: titles[3], amountText: titles[4])
        return header
    }
}

// MARK: - Utility

extension SalesListViewController {
    
    private func initializeFilterData() {
        guard let sales = salesArray else {
            print("Sales array not initialised")
            return
        }
        print(" before",regions)
        regions = sales.compactMap { $0.region }.removeDuplicates()
        print("after",regions)
        var states = [String: [String]]()
        var cities = [String: [String]]()
        
        print(sales)
        for region in regions {
            states[region] = sales.compactMap { $0.region == region ? $0.state : nil }.removeDuplicates()
            if let statesPerRegion = states[region] {
                for state in statesPerRegion {
                    cities[state] = sales.compactMap { $0.state == state ? $0.city : nil }.removeDuplicates()
                }
            }
        }
        self.states = states
        self.cities = cities
    }
}

fileprivate extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
