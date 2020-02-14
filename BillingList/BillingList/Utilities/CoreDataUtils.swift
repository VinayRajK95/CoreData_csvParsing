//
//  CoreDataUtils.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataUtils {
    static func convertStringToModalObjects(_ data: [[String]]) {
        saveTitlesInUserDefaults(data[0])
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.showIndicator()
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            for row in data.dropFirst() {
                let sale = Sales(context, row)
                context.insert(sale)
            }
            do {
                try context.save()
            } catch {
                fatalError("Failed to save context \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                appDelegate.hideIndicator()
                if let rootVC = appDelegate.window?.rootViewController as? UINavigationController,
                    let salesVC = rootVC.viewControllers.first as? SalesListViewController {
                    salesVC.initializeDataSource()
                }
            }
        }
    }
    
    static func coreDataIsEmpty() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sales")
        do {
            let count = try managedContext.count(for: request)
            return count == 0
        } catch {
            print("Core data error \(error.localizedDescription)")
        }
        return false
    }
    
    static func fetchAllRows() -> [Sales]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sales")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "postalCode", ascending: true)]
        do {
            return try managedContext.fetch(fetchRequest) as? [Sales]
        } catch {
            print("Error while fetching \(error.localizedDescription)")
        }
        return nil
    }
    
    private static func saveTitlesInUserDefaults(_ titles: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(titles, forKey: "titles")
    }
    
    static func retrieveTitles() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: "titles") ?? [String]()
    }
}

extension Sales {
    convenience init(_ moc: NSManagedObjectContext, _ props: [String]) {
        self.init(context: moc)
        guard props.count == 5 else { return }
        self.setValue(props[0], forKey: "region")
        self.setValue(props[1], forKey: "state")
        self.setValue(props[2], forKey: "city")
        self.setValue(Int(props[3]), forKey: "postalCode")
        self.setValue(props[4], forKey: "amount")
    }
}
