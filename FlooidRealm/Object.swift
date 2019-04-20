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
    
    func threadSafe() -> ThreadSafeRealmObject<Self> {
        return ThreadSafeRealmObject(ThreadSafeReference(to: self))
    }
    
    static func query(in context: RealmContext) -> RealmQuery<Self> {
        return RealmQuery(for: context)
    }
    
    static func object(forID id: String, in context:RealmContext) -> Self? {
        return Self.query(in: context).filter(NSPredicate(format: "\(self.idKey()) = %@", id)).execute().first
    }
    
    static func create(forID id: String, in context:RealmContext) -> Self {
        let item = Self()
        item.setValue(id, forKey: self.idKey())
        context.add(item)
        return item
    }
    
    static func create(in context:RealmContext) -> Self {
        let item = Self()
        context.add(item)
        return item
    }
    
    static func findOrCreate(in context:RealmContext, id: String) -> Self {
        return self.object(forID: id, in: context) ?? self.create(forID: id, in: context)
    }

    func delete(from context: CoreDataContext) {
        context.delete(self)
    }
    
}

public typealias RealmObject = Object & DataObjectProtocol
