//
//  Beer.swift
//  BeerTracker
//
//  Created by user166111 on 4/28/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct Beer {
    var id: String?
    var name: String?
    var brewery: String?
    var type: String?
    var ABV: String?
    var mark: String?
}

struct UserBeer {
    var id: String?
    var savedAs: String?
    var name: String?
    var brewery: String?
    var type: String?
    var ABV: String?
    //var location: CLLocation?
    var date: Date?
}
