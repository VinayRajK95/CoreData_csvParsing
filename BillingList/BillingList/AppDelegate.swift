//
//  AppDelegate.swift
//  BillingList
//
//  Created by Arun Eswaramurthi on 11/07/19.
//  Copyright © 2019 Arun Eswaramurthi. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var indicator = UIActivityIndicatorView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let salesListViewController = SalesListViewController()
        let navigationController = UINavigationController(rootViewController: salesListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if CoreDataUtils.coreDataIsEmpty() && UnArchiver.unZipFile() {
            createIndicator()
            CSVParser.saveCSVToCoreData()
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BillingList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Activity Indicator
    
    func createIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)) as UIActivityIndicatorView
        indicator.style = .whiteLarge
        indicator.backgroundColor = UIColor.darkGray
        indicator.alpha = 1
    }
    
    func showIndicator(){
        indicator.startAnimating()
        window?.rootViewController?.view.addSubview(indicator)
    }
    
    func hideIndicator(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }

}

