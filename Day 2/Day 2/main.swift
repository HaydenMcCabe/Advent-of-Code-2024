//
//  main.swift
//  Day 2
//
//  Created by Hayden McCabe on 12/13/24.
//

import Foundation

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let dataRows = dataString.split(separator: "\n")


// Part 1
var safeCount = 0
rowLoop: for row in dataRows {
    let values = row.split(separator: " ").map{Int($0)!}
    // Check the first two values
    // to see if they're increasing or decreasing,
    // and that the change is within range.
    let delta = values[1] - values[0]
    guard delta != 0 && delta >= -3 && delta <= 3  else {
        continue
    }
    
    // If these are the only values, the report is safe.
    guard values.count > 2 else {
        safeCount += 1
        continue
    }
    
    let increasing = (delta > 0) ? true : false
    
    // Check the remaining values to check
    // that they continue in the same direction and
    // are within range.
    for i in 1 ..< values.count - 1 {
        let delta = increasing ? values[i+1] - values[i] : values[i] - values[i+1]
        guard delta >= 1 && delta <= 3 else {
            continue rowLoop
        }
    }
    safeCount += 1
}

print("Part 1 safe count: \(safeCount)")

// Part 2
safeCount = 0
rowLoop2: for row in dataRows {
    let values = row.split(separator: " ").map{Int($0)!}
    // Track indices for previous, current, and next index.
    var previous = 0
    var current = 0
    var next = 1
    // Keep a flag tracking if we've allowed for one bad value already
    var errorIgnored = false
    deltaLoop: while next < values.count {
        var badIndex = false
        let delta = values[next] - values[current]
//        print(delta)
        
        if !(delta != 0 && delta >= -3 && delta <= 3) {
            
            badIndex = true
        }
        
        if current > 0 {
            let backDelta = values[current] - values[previous]
            if !(backDelta != 0 && backDelta >= -3 && backDelta <= 3) {
//                print("Bad backdelta")
//                print(backDelta)
                badIndex = true
            }
            if delta.signum() != backDelta.signum() {
                badIndex = true
            }
        }
        
        // If a bad value was found, check/set the flag
        // and update the indices.
        if badIndex {
            if errorIgnored {
                continue rowLoop2
            } else {
                errorIgnored = true
                current = next
                next += 1
                continue deltaLoop
            }
        }
        
        // Iterate the values
        previous = current
        current = next
        next += 1
    }
//    print()

    safeCount += 1
}

print("Part 2 safe count: \(safeCount)")
