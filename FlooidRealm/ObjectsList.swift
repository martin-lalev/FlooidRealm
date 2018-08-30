//
//  ObjectsList.swift
//  FlooidRealm
//
//  Created by Martin Lalev on 31.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmObjectsList<T: RealmObject> {
    private let list: List<T>
    
    public init(for list: List<T>) {
        self.list = list
    }
    
    public var items: [T] {
        return Array(self.list)
    }
    public func append(_ item: T) {
        self.list.append(item)
    }
    public func append(_ items: [T]) -> Void {
        self.list.append(objectsIn: items)
    }
    public func remove(_ item:T) -> Void {
        guard let index = self.list.index(of: item) else { return }
        self.list.remove(at: index)
    }
    public func remove(_ items:[T]) -> Void {
        for item in items {
            guard let index = self.list.index(of: item) else { return }
            self.list.remove(at: index)
        }
    }
    public func removeAll() -> Void {
        self.list.removeAll()
    }
}
