//
//  Stack.swift
//  SwiftDataStructrues
//
//  Created by taehoon lee on 2018. 3. 21..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
//  배열을 사용한 Stack
//

import Foundation

protocol Printable {
    func printSelf()
}
protocol Popable: Printable {
    associatedtype Element
    var elements: [Element] {get set}
    mutating func append(_ element: Element)
    mutating func pop() -> Element?
}

extension Popable {
    mutating func append(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
    
    func printSelf() {
        print("\(String(describing:self).components(separatedBy: ".").last ?? "\(#file).\(#function)")")
        elements.enumerated().forEach({ print("elements[\($0)]: \($1)") })
    }
}

struct Stack<T>: Popable {
    var elements = [T]()
    var peek: T? {
        return elements.last
    }
    
    subscript(_ index: Int) -> T? {
        guard index < elements.count else {
            return nil
        }
        return elements[index]
    }
}

extension Stack: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T
    init(arrayLiteral: T...) {
        self.init()
        for element in arrayLiteral {
            append(element)
        }
    }
}

extension Stack: Sequence {
    func makeIterator() -> AnyIterator<T> {
        return AnyIterator(IndexingIterator(_elements: self.elements))
    }
}



//func testStack() {
//    var intStack = Stack<Int>()
//    intStack.append(1)
//    intStack.append(7)
//    intStack.printSelf() // 1, 7
//
//    for element in intStack {
//        print("looping: \(element * 2)")
//    }
//    let mapped = intStack.map{ $0 * 2 }
//    print("mapping: \(mapped)")
//
//    print("pop: \(intStack.pop()!)") // 7
//    intStack.printSelf() // 1
//
//    var stringStack = Stack<String>()
//    stringStack.append("a")
//    stringStack.append("b")
//    stringStack.printSelf() // a, b
//    print("pop: \(stringStack.pop()!)") // b
//    stringStack.printSelf() // a
//}
//
//
