//
//  main.swift
//  Day 3
//
//  Created by Hayden McCabe on 12/13/24.
//

// 185797128

import Foundation

func processMul(str: String) -> Int {
    let mulRegex = /mul\((\d{1,3}),(\d{1,3})\)/

    let matches = str.matches(of: mulRegex)
    var sum = 0
    for match in matches {
        sum += Int(match.output.1)! * Int(match.output.2)!
    }

    return sum
}

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let part1 = processMul(str: dataString)
print("Part 1 sum: \(part1)")


// Part 2
let doRegex = /do(n't)?\(\)/

let doMatches = dataString.matches(of: doRegex)
var lowerBound = dataString.startIndex
var inDoRange = true

var part2 = 0

for doMatch in doMatches {
    // Each match will be either a do() or don't() operator
    // identified by the capture group
    let isDoOperator = doMatch.output.1 == nil
    // Continue if the operator is unnecessary
    if isDoOperator && inDoRange || !(isDoOperator || inDoRange) {
        continue
    }
    
    // The operator has switched. Mark the beginning of a range to process or process
    // a finished range
    if isDoOperator {
        lowerBound = doMatch.range.upperBound
    } else {
        let substring = dataString[(lowerBound..<doMatch.range.lowerBound)]
        part2 += processMul(str: String(substring))
    }
    inDoRange = isDoOperator
}
// If the last range is a do() range, find the substring
// and process
if inDoRange {
    let substring = dataString[(lowerBound..<dataString.endIndex)]
    part2 += processMul(str: String(substring))
}
print("Part 2: \(part2)")


