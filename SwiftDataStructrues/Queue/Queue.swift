//
//  Queue.swift
//  SwiftDataStructrues
//
//  Created by taehoon lee on 2018. 3. 21..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
//  배열을 사용한 Queue
//

import Foundation

protocol Insertable: Printable {
    associatedtype Element
    var elements: [Element] {get set}
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
}

extension Insertable {
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func dequeue() -> Element? {
        return elements.removeFirst()
    }
    
    func printSelf() {
        print("\(String(describing:self).components(separatedBy: ".").last ?? "\(#file).\(#function)")")
        elements.enumerated().forEach( { print("elements[\($0)]: \($1)") } )
    }
}

struct Queue<T>: Insertable {
    var elements = [T]()
    var peek: T? {
        return elements.first
    }
    
    subscript(_ index: Int) -> T? {
        guard index < elements.count else {
            return nil
        }
        return elements[index]
    }
}

extension Queue: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T
    init(arrayLiteral elements: T...) {
        for element in elements {
            enqueue(element)
        }
    }
}

extension Queue: Sequence {
    func makeIterator() -> AnyIterator<T> {
        return AnyIterator(IndexingIterator(_elements: self.elements))
    }
}
