//
//  Savedimage.swift
//  Gradiate
//
//  Created by Fabrice Ulysse on 12/2/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//

import Foundation

struct Savedimage: Codable {
    var id: Int
    var base64: String
}

// {"data": []}

struct gradientResponse: Codable {
    var data: [Savedimage]
}

struct DeleteGradientResponse: Codable {
    var data: Savedimage
}
