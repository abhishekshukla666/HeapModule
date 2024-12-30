// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Heap<Element> {
    
    public var elements : [Element]
    let priorityFunction : (Element, Element) -> Bool
    
    public var isEmpty : Bool {
        return elements.isEmpty
    }
    
    public var count : Int {
        return elements.count
    }
    public func peek() -> Element? {
        return elements.first
    }
    
    public func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    
    public func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    public func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    
    public func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    public func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    public func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
        else { return parentIndex }
        return childIndex
    }
    
    public func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(
                of: parent, and: leftChildIndex(of: parent)),
            and: rightChildIndex(of: parent))
    }
    
    public mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex
        else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
}
public extension Heap {
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }
    
    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index) // 1
        guard !isRoot(index), // 2
              isHigherPriority(at: index, than: parent) // 3
        else { return }
        swapElement(at: index, with: parent) // 4
        siftUp(elementAtIndex: parent) // 5
    }
}

public extension Heap {
    mutating func dequeue() -> Element? {
      guard !isEmpty // 1
        else { return nil }
      swapElement(at: 0, with: count - 1) // 2
      let element = elements.removeLast() // 3
      if !isEmpty { // 4
        siftDown(elementAtIndex: 0) // 5
      }
      return element // 6
    }
    
    mutating func siftDown(elementAtIndex index: Int) {
      let childIndex = highestPriorityIndex(for: index) // 1
      if index == childIndex { // 2
        return
      }
      swapElement(at: index, with: childIndex) // 3
      siftDown(elementAtIndex: childIndex)
    }
}
