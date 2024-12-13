//
//  main.swift
//  Day 1
//
//  Created by Hayden McCabe on 12/12/24.
//

import Foundation
import Collections

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/day_1.dat")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let dataRows = dataString.split(separator: "\n")

// Create min heaps to store the values
var leftHeap = Heap<Int>()
var rightHeap = Heap<Int>()
var rightCount = Dictionary<Int,Int>()

for row in dataRows {
    // Find the left and right values
    let parts = row.split(separator: " ")
    let left = Int(parts[0])!
    let right = Int(parts[1])!
    leftHeap.insert(left)
    rightHeap.insert(right)
    // Keep a count of the right values for part 2
    if let existingCount = rightCount[right] {
        rightCount[right] = existingCount + 1
    } else {
        rightCount[right] = 1
    }
}

var total = 0
var similarity = 0

while !leftHeap.isEmpty {
    // Part 1
    let leftMin = leftHeap.popMin()!
    let rightMin = rightHeap.popMin()!
    let difference = abs(leftMin - rightMin)
    total += difference
    
    // Part 2
    similarity += leftMin * (rightCount[leftMin] ?? 0)
}

// Part 1
print("Part 1 Total: \(total)")

// Part 2
print("Part 2 Total: \(similarity)")
