//
//  UnArchiver.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import Foundation
import SSZipArchive

struct UnArchiver {
    static func unZipFile() -> Bool {
        do {
            guard let filePath = Bundle.main.url(forResource: "sample_data", withExtension: "zip") else {
                fatalError("Zip file doesn't exist")
            }
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
            try SSZipArchive.unzipFile(atPath: filePath.path, toDestination: documentsDirectory.path, overwrite: true, password: nil)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
