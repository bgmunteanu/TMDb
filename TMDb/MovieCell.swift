//
//  MovieCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 11/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    func setMovie(movie: Movie) {
        movieImageView.image = movie.poster
        movieNameLabel.text = movie.name
        movieYearLabel.text = movie.year
        movieRatingLabel.text = movie.rating
    }
}
