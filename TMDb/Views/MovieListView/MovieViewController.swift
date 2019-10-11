//
//  MovieViewController.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 26/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var yearAndDurationLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var shortDescriptionText: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var overviewTextView: UIView!
    @IBOutlet weak var overviewText: UILabel!
    var movie: Movie!
    @IBOutlet var movieView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let extendedMovie = extendMovie(movie: movie)
        posterImage.image = extendedMovie.poster
        movieTitle.text = extendedMovie.name
        shortDescriptionText.text = extendedMovie.shortDescription
        
        let overviewTextHeight: CGFloat = self.customHeight(text: self.overviewText.text, font: UIFont.systemFont(ofSize: 17), width: self.view.frame.width)
        self.overviewTextView.frame.size.height = overviewTextHeight
        
        overviewText.text = extendedMovie.text
        
        fetchMovieData { (extendedResults) in
            self.shortDescriptionText.text = extendedResults.tagline
            self.overviewText.text = extendedResults.overview
            self.yearAndDurationLabel.text = "\(self.extendMovie(movie: self.movie).year) - \(String(describing: extendedResults.runtime)) min"
        }
        
    }
    
    func fetchMovieData(completionBlock: @escaping (ExtendedResults) -> Void) {
        
        let urlComponents = { () -> URLComponents in
            var url = URLComponents()
            
            url.scheme = "https"
            url.path = "api.themoviedb.org/3/movie/\(String(self.movie.id))?"
            url.queryItems = [
                URLQueryItem(name: "api_key", value: self.getApiKey()),
                URLQueryItem(name: "language", value: "en-US")
            ]
            
            return url
        }
        
        let session = URLSession.shared
        guard let url = urlComponents().url else {
            print("The url does not work")
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let searchResults = try jsonDecoder.decode(ExtendedResults.self, from: data!)
                
                DispatchQueue.main.async {
                    completionBlock(searchResults)
                }
                
                
            } catch {
                print(error.localizedDescription)
                
            }
            
        })
        
        task.resume()

    }
    
    func extendMovie(movie: Movie) -> ExtendedMovie {
        let extendedMovie = ExtendedMovie(id: movie.id, poster: movie.poster, name: movie.name, year: movie.year, rating: movie.rating, imageLink: movie.imageLink)
        return extendedMovie
    }
    
    func customHeight(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        
        var currentHeight: CGFloat!
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        
        return currentHeight
    }
    
    func getApiKey() -> String {
        var apiKey = ""
        
        if let filepath = Bundle.main.path(forResource: "apiKey", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                apiKey = String(contents.prefix(32))
                print(filepath)
                print(contents)
            } catch {
            }
        }
        return apiKey
        
        
    }
}
