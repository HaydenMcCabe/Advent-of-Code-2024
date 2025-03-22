//
//  main.swift
//  Day 5
//
//  Created by Hayden McCabe on 12/15/24.
//

import Foundation

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
// Split the text where there's a blank line
let dataParts = dataString.split(separator: "\n\n")
let orderRules = dataParts[0].split(separator: "\n")
let orders = dataParts[1].split(separator: "\n")

// Make a hash lookup for the order rules.
var orderHash = Dictionary<Int,[Int]>()
for orderRule in orderRules {
    let parts = orderRule.split(separator: "|")
    let first = Int(String(parts[0]))!
    let last = Int(String(parts[1]))!
    if var existing = orderHash[first] {
        existing.append(last)
        orderHash[first] = existing
    } else {
        orderHash[first] = [last]
    }
}

// Check the proposed orders
var middleSum = 0
orderLoop: for order in orders {
    let pages = order.split(separator: ",").map() { Int($0)! }
    for i in 1 ..< pages.count {
        let page = pages[i]
        guard let followingPages = orderHash[page] else {
            continue
        }
        for j in 0 ..< i {
            let previousPage = pages[j]
            if followingPages.contains(previousPage) {
                // This set will not work
                continue orderLoop
            }
        }
    }
    // At this point, the set is verified to be okay.
    // Find the middle page number and add it to the sum.
    let middleIndex = (pages.count / 2)
    middleSum += pages[middleIndex]
}
print("Part 1 total: \(middleSum)")
