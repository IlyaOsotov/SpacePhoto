//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Илья Осотов on 01.02.2022.
//

import Foundation

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}
