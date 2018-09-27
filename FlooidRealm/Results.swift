//
//  RealmResults.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmResults<Managed:RealmObject> : NSObject {
    
    public var objects:[Managed] {
        return Array(self.results)
    }
    private let results:Results<Managed>
    private var token:NotificationToken!
    
    init(for fetchRequest:Results<Managed>, in context:RealmContext) {
        self.results = fetchRequest
        super.init()
        self.token = self.results.observe({ [weak self] (change) in
            switch change {
            case .initial: self?.postObserver(.initialized)
            case .update: self?.postObserver(.updated)
            case .error: self?.postObserver(.errored)
            }
        })
    }
    deinit {
        self.token.invalidate()
    }
    
    public enum NotificationType: String {
        case initialized, updated, errored
        func asNotificationName() -> Notification.Name { return NSNotification.Name("realmResultsLayer-\(self.rawValue)-ObservationName") }
    }
    public func postObserver(_ type: NotificationType) {
        NotificationCenter.default.post(name: type.asNotificationName(), object: self)
    }
    public func addObserver(_ observer:Any, selector: Selector, for type: NotificationType) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: type.asNotificationName(), object: self)
    }
    public func removeObserver(_ observer:Any, for type: NotificationType) {
        NotificationCenter.default.removeObserver(observer, name: type.asNotificationName(), object: self)
    }
}
