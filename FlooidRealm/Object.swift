//
//  RealmObject.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public protocol DataObjectProtocol {
    static func idKey() -> String
}

public extension DataObjectProtocol where Self: Object {
    
    public func threadSafe() -> ThreadSafeRealmObject<Self> {
        return ThreadSafeRealmObject(ThreadSafeReference(to: self))
    }
    
    public static func query() -> RealmQuery<Self> {
        return RealmQuery()
    }
    
    public static func object(forID id: String, in context:RealmContext) -> Self? {
        return Self.query().filter(NSPredicate(format: "\(self.idKey()) = %@", id)).execute(in: context).first
    }
    
    public static func create(forID id: String, in context:RealmContext) -> Self {
        let item = Self()
        item.setValue(id, forKey: self.idKey())
        context.add(item)
        return item
    }
    
    public static func create(in context:RealmContext) -> Self {
        let item = Self()
        context.add(item)
        return item
    }
    
    public static func findOrCreate(in context:RealmContext, id: String) -> Self {
        return self.object(forID: id, in: context) ?? self.create(forID: id, in: context)
    }
    
}

public typealias RealmObject = Object & DataObjectProtocol
