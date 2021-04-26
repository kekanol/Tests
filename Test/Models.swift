//
//  Model.swift
//  Test
//
//  Created by Константин on 25.04.2021.
//

import SwiftUI

struct Model {
    var cities: [City] = []
    var choosed = City()
    var showIndicator = false
    var errors = false
}

struct City: Hashable {
    var city: String = ""
    var country: String = ""
    var countryCode: String = ""
    var id: Int = 0
    var population : Int = 0
    var wikiDataId: String = ""
    var elevationMeters: Int?
}
