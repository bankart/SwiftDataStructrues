//
//  LinkedList3.swift
//  SwiftAlgorithms
//
//  Created by taehoon lee on 2018. 3. 1..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

public final class LinkedList<T> {
    // - Mark: LinkedListNode
    // node
    // value: original data of type T
    // next: strong reference property
    // previous: weak reference property
    // >> defence of strong referece cycle
    public class LinkedListNode<T> {
        public var value: T
        public var next: LinkedListNode?
        weak public var previous: LinkedListNode?
        init(_ value: T) {
            self.value = value
        }
    }
    
    // - Mark: properties of LinkedList
    public typealias Node = LinkedListNode<T>
    // mark for very first node of list
    public var head: Node?
    // mark for very last node of list
    public var tail: Node?
    // convenience for head
    public var first: Node? {
        return head
    }
    // very last node of list
    // searching entire nodes of list
    public var last: Node? {
        if isEmpty() {
//            print("\(#function) isEmpty() return")
            return nil
        }
        if tail != nil {
//            print("\(#function) return tail")
            return tail
        }
        guard var node = head else {
//            print("\(#function) list[LinkedList: (\(self))] has no node[LinkedListNode]")
            return nil
        }
        while let next = node.next {
            node = next
        }
        return node
    }
    
    // has no node
    public func isEmpty() -> Bool {
        return head == nil
    }
    // referenced count of nodes
    fileprivate var internalCount: Int = 0
    // return internalCount
    public var count: Int {
        return internalCount
    }
    
    // searching node for served index
    public func node(at index: Int) -> Node {
        assert(!isEmpty(), "list[LinkedList: (\(self))] has no node[LinkedListNode]")
        if index == 0 {
            return head!
        } else {
            var node = head
            for _ in 0..<index {
                node = node?.next
                if node == nil {
                    break
                }
//                print("\(#function) searching loop: node = \(node!.value)")
            }
            return node!
        }
    }
    
    // - Mark: methods of append
    public func append(_ value: T) {
        let newNode = LinkedListNode(value)
        append(newNode)
    }
    
    public func append(_ node: Node) {
        if isEmpty() {
            head = node
            tail = node
//            print("\(#function) head(\(head!.value)) == tail(\(tail!.value))")
        } else {
            guard let lastNode = last else {
                return
            }
//            print("\(#function) \(lastNode.value).next = \(node.value)")
//            print("\(#function) \(node.value).previous = \(lastNode.value)")
//            print("\(#function) former tail: \(tail!.value)")
            lastNode.next = node
            node.previous = lastNode
            tail = node
//            print("\(#function) new tail: \(tail!.value)")
        }
        internalCount += 1
    }
    
    public func append(_ list: LinkedList) {
        if isEmpty() {
            head = list.head
            tail = list.tail
//            print("\(#function) from empty >> head: \(head!.value), tail: \(tail!.value)")
        } else {
            assert(!list.isEmpty(), "served list is empty")
            guard let lastNode = last else {
//                print("\(#function) list has no last node")
                return
            }
//            print("\(#function) list.tail = \(list.tail!.value)")
//            print("\(#function) tail = \(tail!.value)")
//            print("\(#function) last = \(lastNode.value).next = list.head(\(list.head!.value))")
            lastNode.next = list.head
//            print("\(#function) list.first(\(list.first!.value).previous = last(\(lastNode.value))")
            list.first?.previous = lastNode
//            print("list.head = \(list.head!.value)")
            tail = list.last
//            print("\(#function) tail = \(tail!.value)")
        }
        internalCount += list.count
    }
    
    // - Mark: methods of insert
    public func insert(_ value: T, at index: Int) {
        let newNode = LinkedListNode(value)
        insert(newNode, at: index)
    }
    
    public func insert(_ node: Node, at index: Int) {
        if index == 0 {
            node.next = head!
            head!.previous = node
            head = node
        } else {
            let prev = self.node(at: index - 1)
            let next = prev.next
            
            prev.next = node
            node.previous = prev
            node.next = next
            next?.previous = node
        }
        internalCount += 1
    }
    
    public func insert(_ list: LinkedList, at index: Int) {
        if index == 0 {
            list.tail?.next = first
            first!.previous = list.tail
            head = list.head
            list.tail = nil
        } else {
            let prev = self.node(at: index - 1)
            let next = prev.next
            
            prev.next = list.head
            list.head?.previous = prev
            list.tail?.next = next
            next?.previous = list.tail
            
            list.tail = nil
        }
        internalCount += list.count
    }
    
    // - Mark: methods of remove
    public func removeAll() {
        head = nil
        tail = nil
        internalCount = 0
    }
    
    @discardableResult public func removeLast() -> T? {
        assert(!isEmpty(), "list[LinkedList: (\(self))] has no node[LinkedListNode]")
        return remove(last!)
    }
    
    @discardableResult public func remove(_ node: Node) -> T? {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        internalCount -= 1
        return node.value
    }
    
    @discardableResult public func remove(at index: Int) -> T? {
        let node = self.node(at: index)
        return remove(node)
    }
    
    
}

// - Mark: methods for convenience
extension LinkedList: CustomStringConvertible {
    public var description: String {
        var desc = "[\t"
        var node = head
        while node != nil {
            desc += "(\(node!.previous?.value) - \(node!.value) - (\(node!.next?.value))"
            node = node!.next
            desc += (node == nil) ? "" : ",\n \t"
        }
        desc += " ]"
        return desc
    }
    
    public func reverse() {
        var node = head
        tail = node
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.previous, &currentNode.next)
            head = currentNode
        }
    }
    
    public convenience init(arrayLiteral elements: Array<T>) {
        self.init()
        for element in elements {
            append(element)
        }
    }
    
    public subscript(_ index: Int) -> T {
        assert(!isEmpty(), "list[LinkedList: (\(self))] has no node[LinkedListNode]")
        return node(at: index).value
    }
    
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while node != nil {
            result.append(transform(node!.value))
            node = node!.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(node!.value)
            }
            node = node!.next
        }
        return result
    }
}


extension LinkedList: Collection {
    public typealias Index = LinkedListIndex<T>
    
    public subscript(position: Index) -> Node {
        return position.node!
    }
    
    
    // 비어있지 않은 콜렉션의 첫 번째 원소 위치
    // 만약 콜렉션이 비어있다면 startIndex == endIndex 이므로 O(1)
    public var startIndex: Index {
        get {
            return Index(node: head, tag: 0)
//            return LinkedListIndex<T>(node: head, tag: 0)
        }
    }
    
    // 콜렉션의 'fast the end(빠른 마지막 접근)' 위치. 유효한 마지막 subscript 매개변수 보다 1이 큰 값 O(n)
    // 이는 콜렉션이 마지막 노드의 참조를 유지하는 한 개선될 수 있다.
    public var endIndex: Index {
        get {
            if let h = head {
                return Index(node: h, tag: count)
//                return LinkedListIndex<T>(node: h, tag: count)
            } else {
                return Index(node: nil, tag: startIndex.tag)
//                return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
            }
        }
    }
    
    public subscript(position: Index) -> T {
        get {
            return position.node!.value
        }
    }
    
    public func index(after index: Index) -> Index {
        return Index(node: index.node!.next, tag: index.tag+1)
//        return LinkedListIndex<T>(node: index.node!.next, tag:index.tag + 1)
    }
}

public struct LinkedListIndex<T>: Comparable, CustomStringConvertible {
    fileprivate let node: LinkedList<T>.LinkedListNode<T>?
    fileprivate let tag: Int
    
    public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }
    
    public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
    
    public init(node: LinkedList<T>.LinkedListNode<T>?, tag: Int) {
        self.node = node
        self.tag = tag
    }
    
    public var description: String {
        return "{ \(node!.value)(\(tag)) }"
    }
}



