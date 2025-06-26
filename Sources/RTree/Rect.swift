//
//  Rect.swift
//
//  Created by Jialiang Cao on 6/26/25.
//

// Bounding box with coordinates and helper functions
public struct Rect {
    var minX, minY: Double
    var maxX, maxY: Double
    
    func intersects(_ other: Rect) -> Bool {
        return maxX >= other.minX &&
        minX <= other.maxX &&
        maxY >= other.minY &&
        minY <= other.maxY
    }

    // Returns a larger bounding box of the minimum size required to contain both sub-rectangles
    func union(_ other: Rect) -> Rect {
        return Rect(
            minX: min(minX, other.minX),
            minY: min(minY, other.minY),
            maxX: max(maxX, other.maxX),
            maxY: max(maxY, other.maxY)
        )
    }

    func contains(_ other: Rect) -> Bool {
        return other.minX >= minX &&
        other.minY >= minY &&
        other.maxX <= maxX &&
        other.maxY <= maxY
    }

    func area() -> Double {
        return (maxX - minX) * (maxY - minY)
    }
    
    // Creates a bounding box representing a single point
    static func fromPoint(x: Double, y: Double) -> Rect {
        return Rect(minX: x, minY: y, maxX: x, maxY: y)
    }
}

// Represents a data object and it's bounding box, flexible type
public struct Entry<T> {
    var rect: Rect
    var data: T
}
