//
//  main.swift
//  Day 6
//
//  Created by Hayden McCabe on 12/18/24.
//

import Foundation

struct Point2D: Hashable {
    let row: Int
    let col: Int
}

enum Direction : Hashable {
    case up
    case down
    case left
    case right
}

// Load the data from the file
let dataUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/test_data.txt")
let data = try Data(contentsOf: dataUrl)
let dataString = String(data: data, encoding: .utf8)!
let dataRows = dataString.split(separator: "\n")
// Track the guard position
var position = Point2D(row: 0, col: 0)
var direction = Direction.up

// Make a set of locations with all of the obstacles.
var obstacles = Set<Point2D>()
var row = 0
for dataRow in dataRows {
    var col = 0
    for c in dataRow {
        if c == "#" {
            obstacles.insert(Point2D(row: row, col: col))
        } else if c == "^" {
            position = Point2D(row: row, col: col)
        }
        col += 1
    }
    row += 1
}

let originalPosition = position
let originalDirection = direction

let lastRow = dataRows.count - 1
let lastCol = dataRows[0].count - 1


// Track positions visited, including the starting position
var visited: Set<Point2D> = [originalPosition]

moveLoop: while true {
    switch direction {
    case .up:
        if position.row == 0 {
            break moveLoop
        }
        let pointAbove = Point2D(row: position.row - 1, col: position.col)
        if obstacles.contains(pointAbove) {
            direction = .right
        } else {
            position = pointAbove
        }
    case .down:
        if position.row == lastRow {
            break moveLoop
        }
        let pointBelow = Point2D(row: position.row + 1, col: position.col)
        if obstacles.contains(pointBelow) {
            direction = .left
        } else {
            position = pointBelow
        }
    case .left:
        if position.col == 0 {
            break moveLoop
        }
        let pointLeft = Point2D(row: position.row, col: position.col - 1)
        if obstacles.contains(pointLeft) {
            direction = .up
        } else {
            position = pointLeft
        }
    case.right:
        if position.col == lastCol {
            break moveLoop
        }
        let pointRight = Point2D(row: position.row, col: position.col + 1)
        if obstacles.contains(pointRight) {
            direction = .down
        } else {
            position = pointRight
        }
    }
    visited.insert(position)
}

print("Visited positions: \(visited.count)")

// Part 2
// To find positions that, if an obstacle were placed there, would cause the path to loop,
// we can check the position just ahead as we go.

struct PathPoint : Hashable {
    let point: Point2D
    let direction: Direction
}

typealias PathMap = Set<PathPoint>

func makesLoop(startingAt: Point2D, facing: Direction, in map: PathMap) -> Bool {
    // Follow a path from the starting point until either meeting
    // a position that has been previously visited or the path
    // leaves the map.
    
    // Create a local copy of the map, as a read-only map
    // can create an infinite loop.
    var localMap = map
    
    // Initialize local variables
    var direction = facing
    var position = startingAt
    while true {
        // Check for the success condition
        if localMap.contains(PathPoint(point: position, direction: direction)) {
            return true
        }
        switch direction {
        case .up:
            if position.row == 0 {
                return false
            }
            let pointAbove = Point2D(row: position.row - 1, col: position.col)
            if obstacles.contains(pointAbove) {
                direction = .right
            } else {
                position = pointAbove
            }
        case .down:
            if position.row == lastRow {
                return false
            }
            let pointBelow = Point2D(row: position.row + 1, col: position.col)
            if obstacles.contains(pointBelow) {
                direction = .left
            } else {
                position = pointBelow
            }
        case .left:
            if position.col == 0 {
                return false
            }
            let pointLeft = Point2D(row: position.row, col: position.col - 1)
            if obstacles.contains(pointLeft) {
                direction = .up
            } else {
                position = pointLeft
            }
        case .right:
            if position.col == lastCol {
                return false
            }
            let pointRight = Point2D(row: position.row, col: position.col + 1)
            if obstacles.contains(pointRight) {
                direction = .down
            } else {
                position = pointRight
            }
        }
        
        localMap.insert(PathPoint(point: position, direction: direction))
    }
    
    
    return false
}

// Reset the state variables
position = originalPosition
direction = originalDirection
var map: PathMap = [PathPoint(point: position, direction: direction)]
var insertCount = 0

moveLoop: while true {
    switch direction {
    case .up:
        if position.row == 0 {
            break moveLoop
        }
        let pointAbove = Point2D(row: position.row - 1, col: position.col)
        if obstacles.contains(pointAbove) {
            direction = .right
        } else {
            if position.col < lastCol {
                let pointRight = Point2D(row: position.row, col: position.col + 1)
                if makesLoop(startingAt: pointRight, facing: .right, in: map) {
                    insertCount += 1
                }
            }
            position = pointAbove
        }
    case .down:
        if position.row == lastRow {
            break moveLoop
        }
        let pointBelow = Point2D(row: position.row + 1, col: position.col)
        if obstacles.contains(pointBelow) {
            direction = .left
        } else {
            position = pointBelow
        }
    case .left:
        if position.col == 0 {
            break moveLoop
        }
        let pointLeft = Point2D(row: position.row, col: position.col - 1)
        if obstacles.contains(pointLeft) {
            direction = .up
        } else {
            position = pointLeft
        }
    case.right:
        if position.col == lastCol {
            break moveLoop
        }
        let pointRight = Point2D(row: position.row, col: position.col + 1)
        if obstacles.contains(pointRight) {
            direction = .down
        } else {
            position = pointRight
        }
    }
    map.insert(PathPoint(point: position, direction: direction))
}

print("Visited positions 2: \(map.count)")
print(insertCount)
