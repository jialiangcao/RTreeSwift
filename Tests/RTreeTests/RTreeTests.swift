import XCTest
@testable import RTree

final class RTreeTests: XCTestCase {
    func testInsertion() {
        let tree = RTree<String>()
        let samples: [(Rect, String)] = [
            (Rect(minX: 0, minY: 0, maxX: 1, maxY: 1), "A"),
            (Rect(minX: 2, minY: 2, maxX: 3, maxY: 3), "B"),
            (Rect(minX: 0.5, minY: 0.5, maxX: 1.5, maxY: 1.5), "C"),
            (Rect(minX: -1, minY: -1, maxX: 0, maxY: 0), "D"),
            (Rect(minX: 4, minY: 4, maxX: 5, maxY: 5), "E")
        ]
        
        for (rect, label) in samples {
            tree.insert(rect: rect, data: label)
            print("Inserted \(label): \(rect)")
        }
        
        let extra = Rect(minX: 6, minY: 6, maxX: 7, maxY: 7)
        tree.insert(rect: extra, data: "F")
        print("Inserted F: \(extra)")
    }
    
    func testRootPropertiesAfterInsertion() {
        let tree = RTree<String>()
        let samples: [(Rect, String)] = [
            (Rect(minX: 0, minY: 0, maxX: 1, maxY: 1), "A"),
            (Rect(minX: 2, minY: 2, maxX: 3, maxY: 3), "B"),
            (Rect(minX: 0.5, minY: 0.5, maxX: 1.5, maxY: 1.5), "C"),
            (Rect(minX: -1, minY: -1, maxX: 0, maxY: 0), "D"),
            (Rect(minX: 4, minY: 4, maxX: 5, maxY: 5), "E"),
            (Rect(minX: 6, minY: 6, maxX: 7, maxY: 7), "F")
        ]
        
        for (rect, label) in samples {
            tree.insert(rect: rect, data: label)
        }
        
        print("Root isLeaf? \(tree.root.isLeaf)")
        print("Root bounding box: \(tree.root.boundingBox)")
        print("Root children count: \(tree.root.children.count)")
        
        XCTAssertFalse(tree.root.isLeaf, "Root should not be a leaf after insertions")
        XCTAssertEqual(tree.root.children.count, 2)
    }
    
    func testSearchQueries() {
        let tree = RTree<String>()
        let samples: [(Rect, String)] = [
            (Rect(minX: 0, minY: 0, maxX: 1, maxY: 1), "A"),
            (Rect(minX: 2, minY: 2, maxX: 3, maxY: 3), "B"),
            (Rect(minX: 0.5, minY: 0.5, maxX: 1.5, maxY: 1.5), "C"),
            (Rect(minX: -1, minY: -1, maxX: 0, maxY: 0), "D"),
            (Rect(minX: 4, minY: 4, maxX: 5, maxY: 5), "E"),
            (Rect(minX: 6, minY: 6, maxX: 7, maxY: 7), "F")
        ]
        
        for (rect, label) in samples {
            tree.insert(rect: rect, data: label)
        }
        
        let queries = [
            Rect(minX: 0, minY: 0, maxX: 2, maxY: 2),
            Rect(minX: 5, minY: 5, maxX: 6.5, maxY: 6.5)
        ]
        
        for query in queries {
            let hits = tree.search(in: tree.root, queryRect: query)
            print("Search \(query) -> found: \(hits)")
        }
        
        let firstQueryResults = tree.search(in: tree.root, queryRect: queries[0])
        XCTAssertTrue(firstQueryResults.contains("A"), "Expected to find 'A' in first query")
        XCTAssertTrue(firstQueryResults.contains("B"), "Expected to find 'B' in first query")
        XCTAssertTrue(firstQueryResults.contains("C"), "Expected to find 'C' in first query")
        XCTAssertTrue(firstQueryResults.contains("D"), "Expected to find 'D' in first query")
        
        let secondQueryResults = tree.search(in: tree.root, queryRect: queries[1])
        XCTAssertTrue(secondQueryResults.contains("E"), "Expected to find 'E' in second query")
        XCTAssertTrue(secondQueryResults.contains("F"), "Expected to find 'F' in second query")
    }
}
