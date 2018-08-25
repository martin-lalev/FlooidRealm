//
//  RealmResults.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

private extension Notification.Name {
    static let realmResultsLayerInitializedObservationName = NSNotification.Name("realmResultsLayerInitializedObservationName")
    static let realmResultsLayerUpdatedObservationName = NSNotification.Name("realmResultsLayerUpdatedObservationName")
    static let realmResultsLayerErrorObservationName = NSNotification.Name("realmResultsLayerErrorObservationName")
}

public class RealmResults<Managed:RealmObject> : NSObject {
    
    public var objects:[Managed]? {
        return Array(self.results)
    }
    private let results:Results<Managed>
    private var token:NotificationToken!
    
    init(for fetchRequest:Results<Managed>, in context:RealmContext) {
        self.results = fetchRequest
        super.init()
        self.token = self.results.observe({ [weak self] (change) in
            switch change {
            case .initial:
                self?.postInitialized()
            case .update:
                self?.postUpdated()
            case .error:
                self?.postError()
            }
        })
    }
    deinit {
        self.token.invalidate()
    }
    
    public func postInitialized() {
        NotificationCenter.default.post(name: .realmResultsLayerInitializedObservationName, object: self)
    }
    public func addInitialized(_ observer:Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .realmResultsLayerInitializedObservationName, object: self)
    }
    public func removeInitialized(_ observer:Any) {
        NotificationCenter.default.removeObserver(observer, name: .realmResultsLayerInitializedObservationName, object: self)
    }
    
    public func postUpdated() {
        NotificationCenter.default.post(name: .realmResultsLayerUpdatedObservationName, object: self)
    }
    public func addUpdated(_ observer:Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .realmResultsLayerUpdatedObservationName, object: self)
    }
    public func removeUpdated(_ observer:Any) {
        NotificationCenter.default.removeObserver(observer, name: .realmResultsLayerUpdatedObservationName, object: self)
    }
    
    public func postError() {
        NotificationCenter.default.post(name: .realmResultsLayerErrorObservationName, object: self)
    }
    public func addError(_ observer:Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .realmResultsLayerErrorObservationName, object: self)
    }
    public func removeError(_ observer:Any) {
        NotificationCenter.default.removeObserver(observer, name: .realmResultsLayerErrorObservationName, object: self)
    }
}
