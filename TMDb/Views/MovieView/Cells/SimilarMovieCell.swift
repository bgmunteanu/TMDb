//
//  SimilarMovieCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class SimilarMovieCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    func setSimilarMovie(posterImage: UIImage, movieTitle: String, movieDescription: String, movieRating: String) {
        self.posterImage.image = posterImage
        self.movieTitle.text = movieTitle
        self.movieDescription.text = movieDescription
        self.movieRating.text = movieRating
    }
    
}
