//
//  main.swift
//  Day 7
//
//  Created by Hayden McCabe on 12/21/24.
//

import Foundation

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let dataRows = dataString.split(separator: "\n")

// Part 2

// A recursive function to see if the given value can be reached
// by multiplying or adding the operands in order. As the values
// found through continuous multiplication and addition increase
// monotonically, any value larger than the target value lead to
// paths that will never achieve a correct value and can be
// terminated early.
func partOneCanReach(value: Int, subtotal: Int, with operands: [Int], index: Int) -> Bool {
    // End of recursion: If it's the last index, check to see if adding or multiplying
    // the final value reaches the goal value.
    if index == operands.count - 1 {
        return (subtotal + operands[index] == value) || (subtotal * operands[index] == value)
    }
    // Check using the given index to add to and multiply the subtotal, and launch
    // recursions for cases where the subtotal is less than the target value.
    
    var sumResult = false
    var productResult = false
    
    let sumSubtotal = subtotal + operands[index]
    if sumSubtotal <= value {
        sumResult = partOneCanReach(value: value, subtotal: sumSubtotal, with: operands, index: index + 1)
    }
    let productSubtotal = subtotal * operands[index]
    if productSubtotal <= value {
        productResult = partOneCanReach(value: value, subtotal: productSubtotal, with: operands, index: index + 1)
    }
    
    return (sumResult || productResult)
}




var partOneTotal = 0

for dataRow in dataRows {
    let parts = dataRow.split(separator: ": ")
    let value = Int(parts[0])!
    let operands = parts[1].split(separator: " ").map({ Int($0)!})
    if partOneCanReach(value: value, subtotal: operands[0], with: operands, index: 1) {
        partOneTotal += value
    }
}
print("Part one total: \(partOneTotal)")

// Part 2
// Override || to create an integer concatenation operator
func || (left: Int, right: Int) -> Int {
    return Int("\(left)\(right)")!
}


// Modified version of the function for the revised requirements
func partTwoCanReach(value: Int, subtotal: Int, with operands: [Int], index: Int) -> Bool {
    // End of recursion: If it's the last index, check to see if adding, multiplying,
    // or concatenating the final value reaches the goal value.
    if index == operands.count - 1 {
        return (subtotal + operands[index] == value) || (subtotal * operands[index] == value)
            || ((subtotal || operands[index]) == value)
    }
    // Check using the given index to add to and multiply the subtotal, and launch
    // recursions for cases where the subtotal is less than the target value.
    
    var sumResult = false
    var productResult = false
    var catResult = false
    
    let sumSubtotal = subtotal + operands[index]
    if sumSubtotal <= value {
        sumResult = partTwoCanReach(value: value, subtotal: sumSubtotal, with: operands, index: index + 1)
    }
    let productSubtotal = subtotal * operands[index]
    if productSubtotal <= value {
        productResult = partTwoCanReach(value: value, subtotal: productSubtotal, with: operands, index: index + 1)
    }
    
    let catSubtotal = subtotal || operands[index]
    if catSubtotal <= value {
        catResult = partTwoCanReach(value: value, subtotal: catSubtotal, with: operands, index: index + 1)
    }
    
    return (sumResult || productResult || catResult)
}

var partTwoTotal = 0

for dataRow in dataRows {
    let parts = dataRow.split(separator: ": ")
    let value = Int(parts[0])!
    let operands = parts[1].split(separator: " ").map({ Int($0)!})
    if partTwoCanReach(value: value, subtotal: operands[0], with: operands, index: 1) {
        partTwoTotal += value
    }
}
print("Part two total: \(partTwoTotal)")
