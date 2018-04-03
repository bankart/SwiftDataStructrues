//
//  Heap.swift
//  SwiftDataStructrues
//
//  Created by taehoon lee on 2018. 3. 21..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
/*
 ## Heap
 1. complete binary tree
 2. confirm max/min heap property(parent always bigger/smaller than child)
 
 ### 배열을 가상의 이진 트리로 맵핑해보면 아래와 같다.
 ```
 [2, 8, 6, 1, 10, 15, 3, 12, 11]
 i = 0 > 2 (parent)
 i = 1 > 8 (left child of 2)
 i = 2 > 6 (right child of 2)
 i = 3 > 1 (left child of 8, parent of  12, 11)
 i = 4 > 10 (right child of 8, has no child)
 i = 5 > 15 (left child of 6, has no child)
 i = 6 > 3 (right child of 6, has no child)
 i = 7 > 12 (left child of 1, has no child)
 i = 8 > 11 (right child of 1, has no child)
 
 if i = 0
     index of node = i >> 0 {2}
     index of node's left child = (i * 2) + 1 >> 1 {8}
     index of node's right child = (i * 2) + 2 >> 2 {6}
 
 if i = 1
     index of node = i >> 1 {8}
     index of node's left child = (i * 2) + 1 >> 3 {1}
     index of node's right child = (i * 2) + 2 >> 4 {10}
 
 leftChildIndex = (i * 2) + 1
 rightChildIndex = (i * 2) + 2
 parentIndex = (i - 1) / 2
 
 ```
 
 */
//

import Foundation

struct Heap<T: Comparable> {
    typealias Comparator = (T, T) -> Bool
    typealias NodeIndexes = (left: Int, parent: Int, right: Int)
    
    private(set) var elements = [T]()
    private var sortMethod: Comparator
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var peek: T? {
        return elements.first
    }
    
    init(sort: @escaping Comparator) {
        self.sortMethod = sort
    }
    
    init(array: [T], sort: @escaping Comparator) {
        self.sortMethod = sort
        heapify(array: array)
    }
    
    mutating private func heapify(array: [T]) {
        elements = array
        for i in stride(from: (elements.count-1)/2, through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    @inline(__always) private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    @inline(__always) private func leftChildIndex(of index: Int) -> Int {
        return (index * 2) + 1
    }
    
    @inline(__always) private func rightChildIndex(of index: Int) -> Int {
        return (index * 2) + 2
    }
    
    // 편의를 위한 함수. 좀 더 함축적으로 사용할 수 있도록 개선 필요 >>>
    @inline(__always) private func indexes(of index: Int) -> NodeIndexes {
        return (left: leftChildIndex(of: index), parent: parentIndex(of: index), right: rightChildIndex(of: index))
    }
    
    @inline(__always) private func leftChild(of indexes: NodeIndexes) -> T? {
        guard indexes.left < elements.count else {return nil}
        return elements[indexes.left]
    }
    
    @inline(__always) private func rightChild(of indexes: NodeIndexes) -> T? {
        guard indexes.right < elements.count else {return nil}
        return elements[indexes.right]
    }
    // 편의를 위한 함수. 좀 더 함축적으로 사용할 수 있도록 개선 필요 <<<
    
    mutating public func add(_ element: T) {
        elements.append(element)
        shiftUp(elements.count - 1)
    }
    
    mutating public func replace(_ element: T, at index: Int) {
        guard index < elements.count else { return }
        remove(at: index)
        add(element)
    }
    
    // remove 를 반복 호출하면 heap sort 인듯!
    // 원소들이 sortMethod 의 ordering 으로 정렬된 배열을 만들 수 있다.
    @discardableResult
    mutating public func remove() -> T? {
        if elements.count == 1 {
            // 원소가 1개이면 해당 원소 리턴 후 종료
            return elements.removeLast()
        } else {
            // 반환할 삭제 원소 저장
            let removed = elements[0]
            // 마지막 leaf 를 root 로 이동 후 shiftDown 을 root 부터 실행
            elements[0] = elements.removeLast()
            shiftDown(0)
            // 삭제된 원소 반환 후 종료
            return removed
        }
    }
    
    @discardableResult
    mutating public func remove(at index: Int) -> T? {
        var removed: T? = nil
        guard index < elements.count else { return removed }
        let size = elements.count - 1
        if index != size {
            // 삭제할 node 를 가장 마지막 leaf 와 위치 교환
            elements.swapAt(index, size)
            // 위치 교환 후 해당 leaf 삭제
            removed = elements.removeLast()
            print("\(#function) swapped > elements: \(elements)")
            // index 를 parent 로 하는 이진 트리에 대해 heap property 유지하기 위해 삭제된 node 대신 자리를 차지한 녀석을 shift down 해준다.
            shiftDown(from: index, until: size)
            // shift down 완료 후 index 에 위치한 node 에 대해 shift up 을 진행해 전체 이진 트리의 heap property 를 유지시킨다.
            shiftUp(index)
        }
        return removed
    }
    
    /// elements[index] 의 값이 elements[parentIndex] 보다 크거나/작으면
    /// elements[index] 의 값이 해당 서브 트리에서 가장 크거나/작을 때까지 index 와 parentIndex 의 값을 교환한다.
    ///
    ///
    /// - Parameter index: shift up 을 시작할 node 의 index
    mutating private func shiftUp(_ index: Int) {
        var childIndex = index
        // shift up 할 자신의 값을 저장
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(of: childIndex)
        
        // root 를 제외한 level 까지 loop 를 돌면서 parent 와 자신의 값을 비교
        while childIndex > 0 && sortMethod(child, elements[parentIndex]) {
            // sortMethod 를 만족하면 childIndex 와 parentIndex 의 값을 교환
            elements.swapAt(childIndex, parentIndex)
            print("\(#function) swapped > elements: \(elements)")
            // 하번의 shift up 이 종료된 후 childIndex 값과 parentIndex 값도 갱신해준다.
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }
        
        // 자신의 값이 해당 서브 힙에서 가장 크거나/작은 값인 자리에 자신을 넣으며 shift up 종료
        elements[childIndex] = child
        print("\t\(#function) finish shiftUp for \(index)\r\t\(elements)")
    }
    
    
    /// elements[index] 의 left/right 자식 중 큰/작은 녀석이 있다면 위치 교환
    /// 위치 교환 후 다시 자식들 중 큰/작은 녀석이 있다면 위치교환... 재귀적으로 반복 후
    /// 더 이상 큰/작은 녀석이 없거나 자식이 없는 경우 함수 종료
    ///
    /// - Parameters:
    ///   - index: shift down 을 시작할 node 의 index
    ///   - endIndex: shift down 을 진행할 node 의 index(기본 elements.count 까지임. shiftDown(_:) 함수에서 그렇게 호출함)
    mutating private func shiftDown(from index: Int, until endIndex: Int) {
        let indexes = self.indexes(of: index)
        let left = leftChild(of: indexes)
        let right = rightChild(of: indexes)
        // 자신의 index 저장
        var willParentIndex = index
        
        // binary tree 이기 때문에 left 가 없으면, 자식이 하나도 없다.
        if left != nil {
            // right 가 있으면 자식들 중 더 크거나/작은 녀석의 index 로 willParentIndex 를 갱신
            if right != nil {
                willParentIndex = sortMethod(left!, right!) ? indexes.left : indexes.right
            } else {
                // right 가 없으면 left 와 자신의 값을 비교해 left 가 더 크면 willParentIndex 를 leftChildIndex 로 갱신
                if sortMethod(left!, elements[index]) {
                    willParentIndex = indexes.left
                }
            }
        }
        // 자식이 없는 경우 shift down 종료
        if willParentIndex == index {
            print("\t\(#function) finish shiftDown for \(index)\r\t\(elements)")
            return
        }
        // 자식들 중 더 크거나/작은 녀석과 위치 교환
        elements.swapAt(willParentIndex, index)
        // 위치 교환 이후 해당 자식을 기준으로 shift down 재시작하여 해당 route 의 leaf 까지 heap property 를 유지시킨다.
        shiftDown(willParentIndex)
    }
    
    mutating public func shiftDown(_ index: Int) {
        shiftDown(from: index, until: elements.count)
    }
    
}
