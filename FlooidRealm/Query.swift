//
//  RealmQuery.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmQuery<T:RealmObject> {
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor] = []
    
    public func filter(_ predicate: NSPredicate) -> Self {
        self.predicate = predicate
        return self
    }
    public func sort(_ sort: [NSSortDescriptor]) -> Self {
        self.sortDescriptors = sort.reversed()
        return self
    }
    
    func asFetchRequest(in context:RealmContext) -> Results<T> {
        
        var results = context.context.objects(T.self)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        results = sortDescriptors.reduce(results, { (fr, sd) -> Results<T> in
            return fr.sorted(byKeyPath: sd.key!, ascending: sd.ascending)
        })
        
        return results
    }
    
    public func results(for context:RealmContext) -> RealmResults<T> {
        return RealmResults<T>(for:self.asFetchRequest(in: context), in:context)
    }
    public func execute(in context:RealmContext) -> [T] {
        return Array(self.asFetchRequest(in: context))
    }
    public func forEach(in context:RealmContext, _ iterator:(T)->Void) {
        for item in self.execute(in: context) {
            iterator(item)
        }
    }
}
