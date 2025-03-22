//
//  main.swift
//  Day 4
//
//  Created by Hayden McCabe on 12/14/24.
//

import Foundation

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let dataRows = dataString.split(separator: "\n")

let rowCount = dataRows.count
let colCount = dataRows[0].count

// Part 1
var partOneCount = 0

let asciiX = 88
let asciiM = 77
let asciiA = 65
let asciiS = 83

for rowNumber in 0 ..< dataRows.count {
    let dataRow = dataRows[rowNumber]
    for colNumber in 0 ..< colCount {
        let colIndex = dataRow.utf8.index(dataRow.utf8.startIndex, offsetBy: colNumber)
        if dataRow.utf8[colIndex] == asciiX {
            // X found
            // Check in each direction for M-A-S
            //Forward
            if colCount - colNumber >= 4 {
                let mIndex = dataRow.utf8.index(after: colIndex)
                let aIndex = dataRow.utf8.index(after: mIndex)
                let sIndex = dataRow.utf8.index(after: aIndex)
                if dataRow.utf8[mIndex] == asciiM &&
                    dataRow.utf8[aIndex] == asciiA &&
                    dataRow.utf8[sIndex] == asciiS {
                    partOneCount += 1
                }
            }
            // Reverse
            if colNumber >= 3 {
                let mIndex = dataRow.utf8.index(before: colIndex)
                let aIndex = dataRow.utf8.index(before: mIndex)
                let sIndex = dataRow.utf8.index(before: aIndex)
                if dataRow.utf8[mIndex] == asciiM &&
                    dataRow.utf8[aIndex] == asciiA &&
                    dataRow.utf8[sIndex] == asciiS {
                    partOneCount += 1
                }
            }
            // Down (and diagonals)
            if rowCount - rowNumber >= 4 {
                let mRow = dataRows[rowNumber + 1]
                let aRow = dataRows[rowNumber + 2]
                let sRow = dataRows[rowNumber + 3]
                
                // Straight down
                let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber)
                let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber)
                let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber)
                if mRow.utf8[mIndex] == asciiM &&
                    aRow.utf8[aIndex] == asciiA &&
                    sRow.utf8[sIndex] == asciiS {
                    partOneCount += 1
                }
                
                // Down - Left
                if colNumber >= 3 {
                    let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber - 1)
                    let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber - 2)
                    let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber - 3)
                    if mRow.utf8[mIndex] == asciiM &&
                        aRow.utf8[aIndex] == asciiA &&
                        sRow.utf8[sIndex] == asciiS {
                        partOneCount += 1
                    }
                }
                // Down - Right
                if colCount - colNumber >= 4 {
                    let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber + 1)
                    let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber + 2)
                    let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber + 3)
                    if mRow.utf8[mIndex] == asciiM &&
                        aRow.utf8[aIndex] == asciiA &&
                        sRow.utf8[sIndex] == asciiS {
                        partOneCount += 1
                    }
                }
            }
            // Up
            if rowNumber >= 3 {
                let mRow = dataRows[rowNumber - 1]
                let aRow = dataRows[rowNumber - 2]
                let sRow = dataRows[rowNumber - 3]
                let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber)
                let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber)
                let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber)
                if mRow.utf8[mIndex] == asciiM &&
                    aRow.utf8[aIndex] == asciiA &&
                    sRow.utf8[sIndex] == asciiS {
                    partOneCount += 1
                }
                // Up - Left
                if colNumber >= 3 {
                    let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber - 1)
                    let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber - 2)
                    let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber - 3)
                    if mRow.utf8[mIndex] == asciiM &&
                        aRow.utf8[aIndex] == asciiA &&
                        sRow.utf8[sIndex] == asciiS {
                        partOneCount += 1
                    }
                }
                // Up - Right
                if colCount - colNumber >= 4 {
                    let mIndex = mRow.utf8.index(mRow.utf8.startIndex, offsetBy: colNumber + 1)
                    let aIndex = aRow.utf8.index(aRow.utf8.startIndex, offsetBy: colNumber + 2)
                    let sIndex = sRow.utf8.index(sRow.utf8.startIndex, offsetBy: colNumber + 3)
                    if mRow.utf8[mIndex] == asciiM &&
                        aRow.utf8[aIndex] == asciiA &&
                        sRow.utf8[sIndex] == asciiS {
                        partOneCount += 1
                    }
                }
            }
        }
    }
}

print("XMAS count: \(partOneCount)")

// Part 2

var partTwoCount = 0

for rowNumber in 0 ..< dataRows.count - 2 {
    let dataRow = dataRows[rowNumber]
    for colNumber in 0 ..< colCount - 2 {
        let colIndex = dataRow.utf8.index(dataRow.utf8.startIndex, offsetBy: colNumber)
        let topLeft = dataRow.utf8[colIndex]
        if topLeft == asciiM || topLeft == asciiS {
            let rightIndex = dataRow.utf8.index(dataRow.utf8.startIndex, offsetBy: colNumber + 2)
            let topRight = dataRow.utf8[rightIndex]
            guard topRight == asciiM || topRight == asciiS else {
                continue
            }
            // The following rows need to be accessed
            let nextRow = dataRows[rowNumber + 1]
            let centerIndex = nextRow.utf8.index(nextRow.utf8.startIndex, offsetBy: colNumber + 1)
            let center = nextRow.utf8[centerIndex]
            guard center == asciiA else {
                continue
            }
            
            let bottomRow = dataRows[rowNumber + 2]
            let bottomLeftIndex = bottomRow.utf8.index(bottomRow.utf8.startIndex, offsetBy: colNumber)
            let bottomRightIndex = bottomRow.utf8.index(bottomRow.utf8.startIndex, offsetBy: colNumber + 2)
            let bottomLeft = bottomRow.utf8[bottomLeftIndex]
            let bottomRight = bottomRow.utf8[bottomRightIndex]
            let msSum = asciiM + asciiS
            guard topLeft + bottomRight == msSum && topRight + bottomLeft == msSum else {
                continue
            }
            
            // All of the checks have been passed
            partTwoCount += 1
        }
        
    }
}

print("X-MAS count: \(partTwoCount)")
