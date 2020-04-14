//
//  OverviewCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class OverviewCell: UITableViewCell, MovieListing {
    
    @IBOutlet weak var overviewText: UILabel!
    
    var movie: ExtendedMovie! {
        didSet {
            assignText()
        }
    }
    
    func assignText() {
        overviewText.text = movie.text
    }
    
}
