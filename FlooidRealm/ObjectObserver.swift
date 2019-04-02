//
//  ObjectObserver.swift
//  FlooidRealm
//
//  Created by Martin Lalev on 1.04.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public typealias Change = (old: Any?, new: Any?)
extension DataObjectProtocol where Self: Object {
    public static func deleteObserver(for id: String, in context:RealmContext, callback: @escaping () -> Void) -> AnyObject? {
        return Self.object(forID: id, in: context)?.deleteObserver(callback: callback)
    }
    public func deleteObserver(callback: @escaping () -> Void) -> AnyObject {
        return self.observe({ (objectChange) in
            guard case .deleted = objectChange else { return }
            callback()
        })
    }
    
    public static func updateObserver(for id: String, in context:RealmContext, callback: @escaping ([String: (old: Any?, new: Any?)]) -> Void) -> AnyObject? {
        return Self.object(forID: id, in: context)?.updateObserver(callback: callback)
    }
    public func updateObserver(callback: @escaping ([String: (old: Any?, new: Any?)]) -> Void) -> AnyObject {
        return self.observe({ (objectChange) in
            guard case .change(let propertyChanged) = objectChange else { return }
            callback(propertyChanged.reduce(into: [:]) { $0[$1.name] = (old:$1.oldValue,new:$1.newValue) })
        })
    }
}
