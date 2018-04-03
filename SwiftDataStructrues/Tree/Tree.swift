//
//  Tree.swift
//  SwiftDataStructrues
//
//  Created by taehoon lee on 2018. 3. 25..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation
import UIKit

public class TreeNode<T> {
    public var value: T
    public weak var parent: TreeNode?
    public var childrens = [TreeNode]()
    
    public init(value: T) {
        self.value = value
    }
    
    public func addChild(_ node: TreeNode) {
        childrens.append(node)
        node.parent = self
    }
    
    public func addChilds(_ nodes: TreeNode...) {
        nodes.forEach { (node) in
            addChild(node)
        }
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        var desc = "\(value)"
        if !childrens.isEmpty {
            desc += ": { \(childrens.map{ $0.description }.joined(separator: ", "))}"
        }
        return desc
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        if value == self.value {
            return self
        } else {
            for child in childrens {
                if let found = child.search(value) {
                    return found
                }
            }
            return nil
        }
    }
}




func testTree() {
    let familyTrees = ["LJK_SBN": ["LYJ_HS":["LSH", "LSW"], "LHJ_LEJ":["LKM", "LUJ"], "LSJ_BSH":["BSY"], "LTH_PJA":[]]]
    // $0 == offset, $1 = element
    var root: TreeNode<String>?
    for (key, value) in familyTrees {
        print(key)
        root = TreeNode<String>(value: key)
        for (child, childs) in value {
            print("\t\(child)")
            let child = TreeNode<String>(value: child)
            root!.addChild(child)
            for grandChild in childs {
                print("\t\t\(grandChild)")
                if !grandChild.isEmpty && grandChild != "" {
                    let grandChildren = TreeNode<String>(value: grandChild)
                    child.addChild(grandChildren)
                }
            }
        }
    }
    
    if let root = root {
        print(root)
//        print("\(root) \(root.childrens.reduce("-"){ "\($0) \($1)," })")
        for child in root.childrens {
            print("\t> \(child) \(child.childrens.reduce("-"){ "\($0) \($1)," })")
        }
    }
    
}
