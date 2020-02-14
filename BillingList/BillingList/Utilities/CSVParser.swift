//
//  CSVParser.swift
//  BillingList
//
//  Created by Vinay on 11/07/19.
//  Copyright © 2019 Vinay. All rights reserved.
//

import Foundation

struct CSVParser {
    static func saveCSVToCoreData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.pathExtension == "csv" {
                    let contents = try String(contentsOf: fileURL, encoding: .utf8)
                    let data = csv(data: contents)
                    CoreDataUtils.convertStringToModalObjects(data)
                    break
                }
            }
        } catch {
            print("Error while enumerating files \(documentsDirectory.path): \(error.localizedDescription)")
        }
    }
    
    private static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let cleanData = cleanRows(file: data)
        let rows = cleanData.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    private static func cleanRows(file: String) -> String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n\n", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}
