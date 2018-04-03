//
//  BinarySearchTree.swift
//  SwiftAlgorithms
//
//  Created by taehoon lee on 2018. 3. 4..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
//  이진 탐색 트리 (Binary Search Tree (aka BST))
//  ; height = root 에서 가장 마지막 leaf 까지의 단계(a steps of root ~ lowest leaf).
//           대부분의 연산이 O(h) 로 해결된다. 밸런스가 잘 맞는 트리의 경우 백만개의 노드가 있더라도 20 단계 안에 검색을 완료할 수 있다.
//  ; level = virtual layer of nodes with the same height
//  - search: O(h) > h = height
//  - insert: O(h)
//  - delete: O(h)
//

import Foundation

// value 는 비교 가능한 타입이어야 한다. 그래야 검색/삽입/삭제가 가능하다.
public class BinarySearchTree<T:Comparable> {
    public typealias Node = BinarySearchTree
    // 자신의 값
    private(set) public var value: T
    // 부모
    private(set) public var parent: Node?
    // 왼쪽 자식 (자신보다 작은 값 저장)
    private(set) public var left: Node?
    // 오른쪽 자식 (자신보다 큰 값 저장)
    private(set) public var right: Node?
    private var queueForLevelOrder = [Node]()
    
    init(value: T) {
        self.value = value
    }
    
    public var isRoot: Bool {
        return parent == nil
    }

    public var hasLeft: Bool {
        return left != nil
    }
    
    public var hasRight: Bool {
        return right != nil
    }
    
    public var isLeaf: Bool {
        return !isRoot && !hasLeft && !hasRight
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasBothChild: Bool {
        return hasLeft && hasRight
    }
    
    public var hasAnyChild: Bool {
        return hasLeft || hasRight
    }
    
    // 특정 node 부터 가장 아래에 있는 leaf 까지의 거리. O(n)
    public var height: Int {
        // root 부터 left, right 의 leaf 까지 순회하여 둘 중 큰 값
        if isLeaf {
            return 1
        } else {
            return 1 + max(left?.height ?? 0, right?.height ?? 0)
        }
    }
    
    // 특정 node 부터 root 까지의 거리. O(h)
    public var depth: Int {
        var node = self
        var edge = 0
        while let parent = node.parent {
            node = parent
            edge += 1
        }
        return edge
    }
    
    // 전체 노드의 갯수
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    // ExpressibleByArrayLiteral 을 적용하지 않고 배열 형식으로 BinarySearchTree 를 초기화할 수 있다.
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for index in 1..<array.count {
            insert(array[index])
        }
    }
}

extension BinarySearchTree {
    func search(_ value: T) -> Node? {
        if value == self.value {
            return self
        }
        if value < self.value {
            return left?.search(value)
        } else {
            return right?.search(value)
        }
    }
    /*
     tree = [1, 3, 2, (5)<-root, 10, 8, 12]
     tree.search(3)
     > if 3 == 5 = false
     > if 3 < 5 = true then / *left[2].search(3)
      > if 3 == 2 = false
      > if 3 < 2 = false
      > if 3 > 2 = true then / **right[3].search(3)
       > if 3 == 3 true then return self > go to ** point > go to * point > end of method
     */
    
    // 가장 작은 값. left 만 순회하여 가장 마지막 값 추출
    func minimum() -> Node {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    // 가장 큰 값. right 만 순회하여 가장 마지막 값 추출
    func maximum() -> Node {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }
    
    // 특정 node 의 값보다 크면서 가장 작은 node 찾기
    func successor() -> Node? {
        print("\(#function)")
        if let right = right {
            // 오른쪽 subTree 가 존재할 때 자신보다 크면서 가장 작은 값
            return right.minimum()
        } else {
            var node = self
            // parent 로 거슬러 올라가며 자신보다 큰 값 찾기
            while let parent = node.parent {
                if parent.value > value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
    
    // 특정 node 의 값보다 작으면서 가장 큰 node 찾기
    func predecessor() -> Node? {
        if let left = left {
            // 왼쪽 subTree 가 존재할 때 자신보다 작으면서 가장 큰 값
            return left.maximum()
        } else {
            var node = self
            // parent 로 거슬러 올라가며 자신보다 작은 값 찾기
            while let parent = node.parent {
                if parent.value < value {
                    return parent
                }
                node = parent
            }
        }
        return nil
    }
    
    @discardableResult
    func iterateSearch(_ value: T) -> Node? {
        print("\(#function)")
        // raywenderlich code
        var n: Node? = self
        while let node = n {
            if value < node.value {
                n = node.left
            } else if value > node.value {
                n = node.right
            } else {
                return node
            }
        }
        return nil
        /*
         위의 코드와 아래의 코드는 같은 결과를 낸다.
         하지만 가독성 및 코드의 간결함은 엄청난 차이가 있다.
         */
//        while (child != nil) {
//            if value == child!.value {
//                break
//            }
//            if value < child!.value {
//                if child!.hasLeft {
//                    child = child!.left
//                    if value == child!.value {
//                        break
//                    }
//                }
//            } else {
//                if child!.hasRight {
//                    child = child!.right
//                    if value == child!.value {
//                        break
//                    }
//                }
//            }
//        }
//        return child
    }
    
    // 자신의 값보다 작으면 left 로, 크면 right 로
    func insert(_ newValue: T) {
        // raywenderlich code
        if newValue < value {
            if let left = left {
                left.insert(newValue)
            } else {
                left = Node(value: newValue)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(newValue)
            } else {
                right = Node(value: newValue)
                right?.parent = self
            }
        }
        /*
         패턴 매칭을 사용할 것인지 이미 구현해 놓은 hasLeft/hasRight 를 사용할 것인지는 개취의 영역인듯
         */
//        if newValue < value {
//            if hasLeft {
//                print("\(value) has left then [\(value)].left.insert(\(newValue)")
//                left!.insert(newValue)
//                print("     after left.insert(\(newValue)")
//            } else {
//                print("\(value) have no left then left = [(\(newValue)] and left.parent = [\(value)]")
//                left = Node(value: newValue)
//                left?.parent = self
//            }
//        } else {
//            if hasRight {
//                print("\(value) has right then [\(value)].right.insert(\(newValue)")
//                right!.insert(newValue)
//                print("     after right.insert(\(newValue)")
//            } else {
//                print("\(value) have no right then right = [(\(newValue)] and right.parent = [\(value)]")
//                right = Node(value: newValue)
//                right?.parent = self
//            }
//        }
//        print("<<< end of \(#function)")
    }
    
    // 코드의 가독성을 위한 함수
    private func reconnectParentToNode(node: Node?) {
        if let parent = parent {
//            print("\(node?.value)'s parent is \(parent.value)")
//            print("\(node?.value).isLeftChild: \(isLeftChild), \(node?.value).isRightChild: \(isRightChild)")
            if isLeftChild {
                parent.left = node
            } else if isRightChild {
                parent.right = node
            }
        }
        node?.parent = parent
//        print("node?.parent: \(node?.parent)")
    }
    
    @discardableResult
    func remove() -> Node? {
        let replacement: Node?
        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
//        print("\(value)'s replacement is \(replacement?.value)")
        replacement?.remove()
        
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
//        print("\(replacement?.value)'s right = \(value)'s right: \(right)")
//        print("\(replacement?.value)'s left = \(value)'s left: \(left)")
//        print("left/right's parent = \(replacement)(left?.parent: \(left?.parent), right?.parent\(right?.parent)")
        reconnectParentToNode(node: replacement)
        
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
}

extension BinarySearchTree {
    // 선순위로 자신의 값을 출력한다. value -> left.value -> right.Value
    func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traverseInOrder(process: process)
        right?.traverseInOrder(process: process)
    }
    
    // 중순위로 자신의 값을 출력한다. left.value -> value -> right.Value
    func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    // 후순위로 자신의 값을 출력한다. left.value -> right.Value -> value
    func traversePostOrder(process:(T) -> Void) {
        left?.traverseInOrder(process: process)
        right?.traverseInOrder(process: process)
        process(value)
    }
    
    /*
     동일 레벨의 순서(left -> right)대로 출력한다.
     1. queue 에 node 를 넣는다.
     2. queue 에서 node 를 빼고 출력한다.
     3. dequeue 된 node 의 자식들을 enqueue 한다. (존재한다면 left -> right 순으로)
     4. queue 가 empty 되기 전까지 1~3을 반복한다.
     */
    func traverseLevelOrder() {
        queueForLevelOrder.append(self)
        var result = ""
        while !queueForLevelOrder.isEmpty {
            let node = queueForLevelOrder.removeFirst()
            result += "\(node.value) "
            if node.hasLeft {
                queueForLevelOrder.append(node.left!)
            }
            if node.hasRight {
                queueForLevelOrder.append(node.right!)
            }
        }
        print(result)
    }
    
    // BST 정렬이 잘 이루어져 있는지 확인
    func isBST(minValue min: T, maxValue max: T) -> Bool {
        print("\(#function) \(min) < \(value) < \(max)")
        if value < min || value > max { return false }
        let leftBST = left?.isBST(minValue: min, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: max) ?? true
        return leftBST && rightBST
    }
}

extension BinarySearchTree {
    func map(transform: (T) -> T) -> [T] {
        var arr = [T]()
        if let left = left {
            arr += left.map(transform: transform)
        }
        arr.append(transform(value))
        if let right = right {
            arr += right.map(transform: transform)
        }
        return arr
    }
    // map 을 사용하여 간편하게 배열로 변환할 수 있다.
    func toArray() -> [T] {
        return map{ $0 }
    }
}

extension BinarySearchTree: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        var desc = ""
        if hasLeft {
            desc += "(\(left!.description)) <- "
        }
        desc += "\(value)"
        if hasRight {
            desc += " -> (\(right!.description))"
        }
        return desc
    }
    
    public var debugDescription: String {
        var desc = ""
        if hasLeft {
            desc += "[\(left!.debugDescription)] <- "
        } else {
            desc += "[], "
        }
        desc += "\(value)(p: \(parent?.value))"
        if hasRight {
            desc += " -> [\(right!.debugDescription)]"
        } else {
            desc += "[]"
        }
        return desc
    }
}




