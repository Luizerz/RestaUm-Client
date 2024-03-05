//
//  DataWrapper.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 03/03/24.
//

import Foundation

struct DataWrapper: Codable {
    let data: Data
    let contentType: ContentType

    func toData() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
