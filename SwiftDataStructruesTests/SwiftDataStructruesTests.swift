//
//  SwiftDataStructruesTests.swift
//  SwiftDataStructruesTests
//
//  Created by taehoon lee on 2018. 3. 21..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import XCTest
@testable import SwiftDataStructrues

class SwiftDataStructruesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        print("\n\n")
        var heap = Heap<Int>(array: [2, 8, 6, 1, 10, 15, 3, 12, 11], sort: >)
        print("heapify: \(heap.elements)")
        XCTAssertEqual(heap.elements, [15, 12, 6, 11, 10, 2, 3, 1, 8])
        print("remove(at: 1)")
        heap.remove(at: 1)
        XCTAssertEqual(heap.elements, [15, 11, 6, 8, 10, 2, 3, 1])
        print("add(12)")
        heap.add(12)
        XCTAssertEqual(heap.elements, [15, 12, 6, 11, 10, 2, 3, 1, 8])
        
        var maxHeapSorted = [Int]()
        print("start remove all element")
        for _ in 0..<heap.elements.count {
            maxHeapSorted.append(heap.remove()!)
        }
        print("finish remove all element")
        print("maxHeapSorted: \(maxHeapSorted)")
        XCTAssertEqual(maxHeapSorted, [15, 12, 11, 10, 8, 6, 3, 2, 1])
        print("\n\n")
        
//        func plus(_ num: Int) -> (Int) -> Int {
//            return { num + $0 }
//        }
//        print("plus(3)(7): \(plus(3)(7))")
//
//        print()
//        let str = "hello, world!"
//        let range = NSMakeRange(2, 4)
//        let subStr = (NSString(string: str).substring(with: range))
//        print("subStr: \(subStr)")
//        let regExp = try? NSRegularExpression(pattern: "[,]{1}", options: NSRegularExpression.Options.caseInsensitive)
//        let found = regExp?.rangeOfFirstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, str.count-1))
//        print("found: \(found)(is NSRange = \(found! is NSRange))")
//
//        print()
//        testStack()
    }
    
    
    func testStack() {
        print("\n\n")
        var stack = Stack<Int>(elements: [1, 3, 5, 7, 11])
        let dump = stack
        print("\ndump")
        dump.printSelf()
        print()
        stack.printSelf()
        print()
        stack.append(13)
        stack.printSelf()
        print()
        let mappedAndFiltered = stack.map{ $0 * 2 }.filter{ $0 % 3 == 0 }
        print("mappedAndFiltered: \(mappedAndFiltered)")
        print()
        stack.printSelf()
        print()
        stack.pop()
        stack.pop()
        stack.printSelf()
        print()
        print("\ndump")
        dump.printSelf()
        print("\n\n")
    }
    
    func testQueue() {
        print("\n\n")
        var queue = Queue<String>(elements:["0", "1", "2", "3", "4"])
        queue.printSelf()
        print()
        queue.dequeue()
        queue.printSelf()
        print()
        queue.enqueue("5")
        queue.printSelf()
        print()
        queue.dequeue()
        queue.printSelf()
        print("\n\n")
    }
    
    func testTreeNode() {
        testTree()
    }
    
    func testFoo() {
        print(#function)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
