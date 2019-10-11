//
//  MovieList.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 03/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import Foundation

class MovieList {
    var movieList: [MovieListMember]
    
    init(movieList: [MovieListMember]) {
        self.movieList = movieList
    }
}


struct MovieListMember {
    var movieId: Int
    var movieTitle: String
    var movieYear: String
    var movieRating: String
    var imageLink: String
    
    
    init(movieId: Int, movieTitle: String, movieYear: String, movieRating: String, imageLink: String) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.movieYear = movieYear
        self.movieRating = movieRating
        self.imageLink = imageLink
    }
}

