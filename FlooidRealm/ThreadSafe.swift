//
//  RealmThreadSafe.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public class ThreadSafeRealmObject<T: Object> {
    let reference:ThreadSafeReference<T>
    init(_ reference:ThreadSafeReference<T>) {
        self.reference = reference
    }
    
    public func resolve(in context:RealmContext) -> T {
        return context.context.resolve(self.reference)!
    }
}
