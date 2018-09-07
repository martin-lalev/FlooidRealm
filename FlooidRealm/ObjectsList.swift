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
extension RealmObjectsList {
    @discardableResult
    public func replace(with items: [T]) -> [T] {
        let oldItems = self.items
        self.removeAll()
        self.append(items)
        return oldItems
    }
    @discardableResult
    public func replace(with items: Set<T>) -> [T] {
        return self.replace(with: Array(items))
    }
}

public class RealmObjectsReadOnlyList<T: RealmObject> {
    private let linkingObjects: LinkingObjects<T>
    
    public init(for linkingObjects: LinkingObjects<T>) {
        self.linkingObjects = linkingObjects
    }
    
    public var items: [T] {
        return Array(self.linkingObjects)
    }
}



public class RealmObjectProperty<T> {
    private let key: String
    private let object: RealmObject
    
    public init(for object: RealmObject, key: String) {
        self.object = object
        self.key = key
    }
    
    public var value: T? {
        return self.object.value(forKey: key) as? T
    }
    public func replace(with value: T?) -> T? {
        let oldValue = self.value
        self.object.setValue(value, forKey: self.key)
        return oldValue
    }
    
}
