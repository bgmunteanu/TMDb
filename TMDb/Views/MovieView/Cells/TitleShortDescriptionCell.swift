//
//  TitleShortDescriptionCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class TitleShortDescriptionCell: UITableViewCell, MovieListing {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    
    var movie: ExtendedMovie! {
        didSet {
            assignTitleAndShortDescription()
        }
    }
    
    func assignTitleAndShortDescription() {
        movieTitle.text = movie.title
        shortDescription.text = movie.shortDescription
    }
    
}
