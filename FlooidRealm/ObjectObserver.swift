//
//  ObjectObserver.swift
//  FlooidRealm
//
//  Created by Martin Lalev on 1.04.19.
//  Copyright © 2019 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmObjectObserver<Managed:RealmObject> : NSObject {

    public enum Action { case deleted, updated }
    
    public var object: Managed
    private let action: Action
    
    private var observerToken: AnyObject?
    public init(for object: Managed, action: Action) {
        self.object = object
        self.action = action
        super.init()
        self.observerToken = self.object.observe({ [weak self] (objectChange) in
            guard let self = self else { return }
            switch (objectChange, self.action) {
            case (.deleted, .deleted):
                NotificationCenter.default.post(name: self.name, object: self.object, userInfo: nil)
            case (.change, .updated):
                NotificationCenter.default.post(name: self.name, object: self.object, userInfo: nil)
            default:
                break
            }
        })
    }
    deinit {
        self.observerToken = nil
    }
    
    private lazy var name: Notification.Name = .init("RealmObjectUpdatedObserver_\(self.object.description)")

    public func add(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: self.name, object: self.object)
    }
    public func remove(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: self.name, object: self.object)
    }
}

extension DataObjectProtocol where Self: Object {
    public static func observer(for id: String, action: RealmObjectObserver<Self>.Action, in context: RealmContext) -> RealmObjectObserver<Self>? {
        return Self.object(forID: id, in: context).map {
            return RealmObjectObserver(for: $0, action: action)
        }
    }
}
