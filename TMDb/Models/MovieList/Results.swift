//
//  Results.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 03/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import Foundation

class Results : Codable {
    var page: Int
    var results: [MovieStructure]
    var total_pages: Int
    var total_results: Int
}

struct MovieStructure : Codable {
    var adult: Bool
    var backdrop_path: String?
    var genre_ids: [Int]
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String?
    var release_date: String
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
}

