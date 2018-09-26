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
    var predicates: [NSPredicate] = []
    var sortDescriptors: [NSSortDescriptor] = []
    
    let context: RealmContext
    init(for context: RealmContext) {
        self.context = context
    }
    
    public func filter(_ predicates: [NSPredicate]) -> Self {
        self.predicates.append(contentsOf: predicates)
        return self
    }
    public func filter(_ predicates: NSPredicate ...) -> Self {
        return self.filter(predicates)
    }
    public func sort(_ sort: [NSSortDescriptor]) -> Self {
        self.sortDescriptors.append(contentsOf: sort)
        return self
    }
    public func sort(_ sort: NSSortDescriptor ...) -> Self {
        return self.sort(sort)
    }

    func asFetchRequest() -> Results<T> {
        var results = self.context.context.objects(T.self)
        results = results.filter(NSCompoundPredicate(andPredicateWithSubpredicates: self.predicates))
        results = self.sortDescriptors.reversed().reduce(results, { (fr, sd) -> Results<T> in
            return fr.sorted(byKeyPath: sd.key!, ascending: sd.ascending)
        })

        return results
    }
    
    public func results() -> RealmResults<T> {
        return RealmResults<T>(for:self.asFetchRequest(), in:self.context)
    }
    public func execute() -> [T] {
        return Array(self.asFetchRequest())
    }
}
