//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Stephanie on 12/18/19.
//  Copyright © 2019 Stephanie Chiu. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
