//
//  FilterViewController.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var numberOfItemsPerRow: CGFloat = 3
    var regions: [String]!
    var states, cities: [String: [String]]!
    
    // Selected filter values by user
    var selectedRegions = [String]()
    var selectedStates: [String] = [String]()
    var selectedCities: [String] = [String]()
    
    // Possible values based on selection
    var stateValues = [String]()
    var cityValues = [String]()
    var titles: [String] = [String]()
    
    weak var delegate: FilterProtocol?
    
    fileprivate let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    fileprivate let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.setTitle("CONFIRM", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        button.setTitleColor(UIColor.kLightBlue, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.kLightBlue.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    fileprivate let resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.setTitle("RESET", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        button.setTitleColor(UIColor.kLightBlue, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.kLightBlue.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    func initializeFilterData(regions: [String], states: [String: [String]], cities: [String: [String]]) {
        self.regions = regions
        self.states = states
        self.cities = cities
    }
    
    func updateSelectedValues(regions: [String]?, states: [String]?, cities: [String]?) {
        selectedRegions = regions ?? []
        selectedStates = states ?? []
        selectedCities = cities ?? []
        stateValues = statesForSelectedRegion()
        cityValues = citiesForSelectedStates()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        self.titles = CoreDataUtils.retrieveTitles()
        initializeViews()
    }
    
    fileprivate func initializeViews() {
        view.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 45)
        
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        self.view.addSubview(collectionView)
        self.view.addSubview(confirmButton)
        self.view.addSubview(resetButton)
        
        let collectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -8),
            
            resetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resetButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            confirmButton.widthAnchor.constraint(equalTo: resetButton.widthAnchor),
            
            
            resetButton.heightAnchor.constraint(equalToConstant: 35),
            confirmButton.heightAnchor.constraint(equalToConstant: 35),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            resetButton.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    @objc func cancelTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func resetTapped() {
        delegate?.updateFilterValues(nil, nil, nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmTapped() {
        delegate?.updateFilterValues(selectedRegions, selectedStates, selectedCities)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                numberOfItemsPerRow = 3
            case .regular:
                numberOfItemsPerRow = 5
            case .unspecified:
                break
            @unknown default:
                break
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - Collection view datasource

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell, let cellValue = cell.title else {
            return
        }
        var isSelected = false
        switch indexPath.section {
        case 0:
            isSelected = selectedRegions.contains(cellValue)
            if isSelected {
                selectedRegions.removeAll(where: { $0 == cellValue })
            } else {
                selectedRegions += [cellValue]
            }
            stateValues = statesForSelectedRegion()
            cityValues = citiesForSelectedStates()
            selectedStates.removeAll(where: { !stateValues.contains($0) })
            selectedCities.removeAll(where: { !cityValues.contains($0) })
        case 1:
            isSelected = selectedStates.contains(cellValue)
            if isSelected {
                selectedStates.removeAll(where: { $0 == cellValue })
            } else {
                selectedStates += [cellValue]
            }
            cityValues = citiesForSelectedStates()
            selectedCities.removeAll(where: { !cityValues.contains($0) })
        case 2:
            isSelected = selectedCities.contains(cellValue)
            if isSelected {
                selectedCities.removeAll(where: { $0 == cellValue })
            } else {
                selectedCities += [cellValue]
            }
        default:
            break
        }
        cell.toggleButtonSelection(isSelected)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as? CollectionHeaderView, titles.count == 5 else {
                return UICollectionReusableView(frame: .zero)
            }
            headerView.title = titles[indexPath.section]
            return headerView
        }
        fatalError()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count = 1
        count += selectedRegions.isEmpty ? 0 : 1
        count += selectedStates.isEmpty ? 0 : 1
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return regions.count
        case 1:
            var count = 0
            for region in selectedRegions {
                count += states[region]?.count ?? 0
            }
            return count
        case 2:
            var count = 0
            for state in selectedStates {
                count += cities[state]?.count ?? 0
            }
            return count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell(frame: .zero)
        }
        var title = ""
        var sectionValues = [String]()
        switch indexPath.section {
        case 0:
            title = regions[indexPath.row]
            sectionValues = selectedRegions
        case 1:
            title = stateValues[indexPath.row]
            sectionValues = selectedStates
        case 2:
            title = cityValues[indexPath.row]
            sectionValues = selectedCities
        default:
            break
        }
        cell.title = title
        cell.toggleButtonSelection(sectionValues.contains(title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20 - numberOfItemsPerRow*10
        return CGSize(width: width / numberOfItemsPerRow, height: 35.0)
    }
}

// MARK: - Data manipulation utils

extension FilterViewController {
    func statesForSelectedRegion() -> [String] {
        var stateValues = [String]()
        for region in selectedRegions {
            stateValues += states[region] ?? []
        }
        return stateValues
    }
    
    func citiesForSelectedStates() -> [String] {
        var cityValues = [String]()
        for state in selectedStates {
            cityValues += cities[state] ?? []
        }
        return cityValues
    }
}
