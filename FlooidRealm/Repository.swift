//
//  RealmRepository.swift
//  FlooidStorage
//
//  Created by Martin Lalev on 25.08.18.
//  Copyright © 2018 Martin Lalev. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmRepository {
    
    private let configuration: Realm.Configuration
    public let mainContext: RealmContext
    
    public init(inMemory: Bool) {
        self.configuration = (inMemory ? Realm.Configuration(inMemoryIdentifier: "identifier") : Realm.Configuration.defaultConfiguration)
        
        self.mainContext = RealmContext(try! Realm(configuration: self.configuration))
        
    }
    
    public func performInBackground(action:@escaping (RealmContext)->Void, then: @escaping ()->Void) {
        DispatchQueue(label: UUID().uuidString).async {
            action(RealmContext(try! Realm(configuration: self.configuration)))
            DispatchQueue.main.async {
                self.mainContext.context.refresh()
                then()
            }
        }
    }
    
}
