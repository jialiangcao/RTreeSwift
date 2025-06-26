//
//  RTree.swift
//
//  Created by Jialiang Cao on 6/26/25.
//

public class RTreeNode<T> {
    var boundingBox: Rect
    var entries: [Entry<T>] = []
    var children: [RTreeNode<T>] = []
    var isLeaf: Bool
    
    init(boundingBox: Rect, isLeaf: Bool) {
        self.boundingBox = boundingBox
        self.isLeaf = isLeaf
        self.entries = []
        self.children = []
    }
}

public class RTree<T> {
    var root: RTreeNode<T>
    private let maxEntries: Int = 4 // Determines how many entries a box can hold before it's split
    
    init() {
        root = RTreeNode<T>(boundingBox: Rect(minX: .infinity, minY: .infinity, maxX: -.infinity, maxY: -.infinity), isLeaf: true)
    }

    func insert(rect: Rect, data: T) {
        let entry = Entry(rect: rect, data: data)
        insert(entry, into: root)
    }
    
    // Overloaded function, recursive
    private func insert(_ entry: Entry<T>, into node: RTreeNode<T>) {
        if node.isLeaf {
            node.entries.append(entry)
            node.boundingBox = node.boundingBox.union(entry.rect)
            
            if node.entries.count > maxEntries {
                split(node)
            }
        } else {
            let bestChild = chooseSubtree(for: entry.rect, in: node)
            insert(entry, into: bestChild)
            node.boundingBox = node.boundingBox.union(entry.rect)
        }
    }
    
    private func chooseSubtree(for rect: Rect, in node: RTreeNode<T>) -> RTreeNode<T> {
        var bestChild: RTreeNode<T>? = nil
        var minDiff = Double.infinity
        var minArea = Double.infinity

        for child in node.children {
            let currentArea = child.boundingBox.area()
            let enlargedArea = child.boundingBox.union(rect).area()
            let diff = enlargedArea - currentArea
            
            if (diff < minDiff) || (diff == minDiff && currentArea < minArea) {
                minDiff = diff
                minArea = currentArea
                bestChild = child
            }
        }
        
        return bestChild!
    }
    
    // Splits entries into two equal parts
    private func split(_ node: RTreeNode<T>) {
        if node.isLeaf {
            let entries = node.entries
            let half = entries.count / 2
            let left = RTreeNode<T>(boundingBox: entries[0].rect, isLeaf: true)
            let right = RTreeNode<T>(boundingBox: entries[half].rect, isLeaf: true)
            
            for i in 0..<half {
                left.entries.append(entries[i])
                left.boundingBox = left.boundingBox.union(entries[i].rect)
            }
            
            for i in half..<entries.count {
                right.entries.append(entries[i])
                right.boundingBox = right.boundingBox.union(entries[i].rect)
            }
            
            // Promotes the root if split
            if node === root {
                let newRoot = RTreeNode<T>(boundingBox: left.boundingBox.union(right.boundingBox), isLeaf: false)
                newRoot.children = [left, right]
                root = newRoot
            } else {
                node.isLeaf = false
                node.entries = []
                node.children = [left, right]
                node.boundingBox = left.boundingBox.union(right.boundingBox)
            }
        }
    }
    
    func search(in node: RTreeNode<T>, queryRect: Rect) -> [T] {
        var results: [T] = []
        
        if node.isLeaf {
            for entry in node.entries {
                if entry.rect.intersects(queryRect) {
                    results.append(entry.data)
                }
            }
        } else {
            for child in node.children {
                if child.boundingBox.intersects(queryRect) {
                    results += search(in: child, queryRect: queryRect)
                }
            }
        }
        
        return results
    }
}
