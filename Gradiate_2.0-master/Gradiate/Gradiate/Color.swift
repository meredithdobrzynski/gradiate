//
//  Color.swift
//  Gradiate
//
//  Created by Fabrice Ulysse on 12/1/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//

import Foundation

struct Color: Codable {
    var red: Int
    var green: Int
    var blue: Int
    var fraction: Double
}

// {"data": []}

struct ColorsResponse: Codable {
    var data: [Color]
}
