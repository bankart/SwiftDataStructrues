//
//  RingBuffer.swift
//  SwiftAlgorithms
//
//  Created by taehoon lee on 2018. 3. 2..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

/**
 순환 버퍼
 */
public struct RingBuffer<T> {
    
    private var array: [T?]
    
    private var readIndex: Int = 0
    
    private var writeIndex: Int = 0
    
    private var availableSpaceToReading: Int {
        return writeIndex - readIndex
    }
    
    private var availableSpaceToWriting: Int {
        return array.count - availableSpaceToReading
    }
    
    private var isFull: Bool {
        return availableSpaceToWriting == 0
    }
    
    private var isEmpty: Bool {
        return availableSpaceToReading == 0
    }
    
    init(count: Int) {
        array = [T?](repeating: nil, count: count)
    }
    
    /**
     버퍼에 element 를 저장한다.
     - Parameter element: RingBuffer<T> 타입
     - Return:
     - 버퍼에 모든 값이 차 있으면 false 반환
     - 버퍼에 성공적으로 element 를 저장했다면 true 반환
 */
    @discardableResult
    public mutating func write(_ element: T) -> Bool {
        guard !isFull else {
            return false
        }
        defer {
            writeIndex += 1
        }
        array[wrapped: writeIndex] = element
        return true
    }
    
    /**
     버퍼에 저장된 RingBuffer<T> 타입을 반환한다.
     - Return: 버퍼에 저장된 element 반환
 */
    public mutating func read() -> T? {
        guard !isEmpty else {
            return nil
        }
        defer {
            array[wrapped: readIndex] = nil
            readIndex += 1
        }
        return array[wrapped: readIndex]
    }
    
}

extension RingBuffer: Sequence {
    public func makeIterator() -> AnyIterator<T> {
       var index = readIndex
        return AnyIterator {
            guard index < self.writeIndex else {
                return nil
            }
            defer {
                index += 1
            }
            return self.array[wrapped: index]
        }
    }
}

private extension Array {
    subscript(wrapped index: Int) -> Element {
        get {
            return self[index % count]
        }
        set {
            self[index % count] = newValue
        }
    }
}
