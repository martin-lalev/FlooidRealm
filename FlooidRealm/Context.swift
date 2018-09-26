//
//  RealmContext.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmContext {
    let context: Realm
    init(_ context: Realm) {
        self.context = context
    }
    
    public func transaction(_ action:@escaping (RealmContext)->Void) {
        try? self.context.write {
            action(self)
        }
    }
    
    public func add(_ object:RealmObject) {
        self.context.add(object)
    }
    
    public func delete(_ item:RealmObject) {
        self.context.delete(item)
    }
    
}

extension RealmQuery {
    public func deleteAll() {

        
        self.context.context.delete(self.asFetchRequest())
    }
    
}
