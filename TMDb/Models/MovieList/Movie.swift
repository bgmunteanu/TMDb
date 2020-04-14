//
//  Movie.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 11/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    var id: Int
    var poster: UIImage
    var title: String
    var year: String
    var rating: String
    var imageLink: String
    var hasPoster = false
    
    public init (id: Int, poster: UIImage, name: String, year: String, rating: String, imageLink: String) {
        self.id = id
        self.poster = poster
        self.title = name
        self.year = year
        self.rating = rating
        self.imageLink = imageLink
    }
    
    public init(id: Int, name: String, year: String, rating: String, imageLink: String) {
        self.id = id
        self.title = name
        self.year = year
        self.rating = rating
        self.imageLink = imageLink
        poster = UIImage()
    }
    
}
