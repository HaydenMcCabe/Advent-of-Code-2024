//
//  main.swift
//  Day 3
//
//  Created by Hayden McCabe on 12/13/24.
//

import Foundation

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!

let mulRegex = /mul\((\d{1,3}),(\d{1,3})\)/
let test = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

let matches = dataString.matches(of: mulRegex)
var sum = 0
for match in matches {
    sum += Int(match.output.1)! * Int(match.output.2)!
}
print("Part 1 sum: \(sum)")
