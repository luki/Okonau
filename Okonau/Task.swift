//
//  Task.swift
//  Okonau
//
//  Created by Lukas A. Müller on 14/04/16.
//  Copyright © 2016 Lukas A. Müller. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let key: String
    let taskName: String
    let checked: Bool
    let ref: Firebase?
    
    init(key: String, taskName: String, checked: Bool) {
        self.key = key
        self.taskName = taskName
        self.checked = checked
        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        taskName = snapshot.value["taskName"] as! String
        checked = snapshot.value["checked"] as! Bool
        ref = snapshot.ref
    }
}

extension Task {
    func toAnyObject() -> AnyObject {
        return [
            "taskName": self.taskName,
            "checked": self.checked
        ]
    }
}