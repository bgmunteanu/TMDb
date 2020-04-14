//
//  BetterMovieViewController.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    var movie: Movie!
    var shortDescriptionText = String()
    var overviewText = String()
    var yearAndDurationLabel = String()
    var similarMovies: [Movie] = []
    
    let movieDataSource = MovieDataSource()
    
    @IBOutlet weak var movieTableView: UITableView! {
        didSet {
            registerCells()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.separatorStyle = .none
        
        fetchMovieData { (extendedResults) in
            self.shortDescriptionText = extendedResults.tagline
            self.overviewText = extendedResults.overview
            self.yearAndDurationLabel = "\(self.extendMovie(self.movie).year) - \(String(describing: extendedResults.runtime)) min"
        }
        
        getSimilarMovies(movieId: self.movie.id, completionBlock: { result in
          
            switch result {
            case .success(let movieList):
                self.createSimilarMovies(movieList: movieList)
                
                
                
                
                
                
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func registerCells() {
        movieTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        movieTableView.register(UINib(nibName: "YearDurationLabelCell", bundle: nil), forCellReuseIdentifier: "YearDurationLabelCell")
        movieTableView.register(UINib(nibName: "TitleShortDescriptionCell", bundle: nil), forCellReuseIdentifier: "TitleShortDescriptionCell")
        movieTableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
        movieTableView.register(UINib(nibName: "SimilarMoviesLabelCell", bundle: nil), forCellReuseIdentifier: "SimilarMoviesLabelCell")
        movieTableView.register(UINib(nibName: "SimilarMovieCell", bundle: nil), forCellReuseIdentifier: "SimilarMovieCell")
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
    
    func getSimilarMovies(movieId: Int, completionBlock: @escaping (Result<MovieList, Error>) -> Void)  {
        
        let urlComponents = { () -> URLComponents in
            var url = URLComponents()
            
            url.scheme = "https"
            url.path = "api.themoviedb.org/3/movie/\(movieId)/similar"
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
                completionBlock(Result.failure(error))
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let searchResults = try jsonDecoder.decode(Results.self, from: data!)

                
                
                let movieList = MovieList(movieList: searchResults.results.map({ currentMovie -> MovieListMember in
                    return MovieListMember(movieId: currentMovie.id, movieTitle: currentMovie.original_title, movieYear: String(currentMovie.release_date.prefix(4)), movieRating: String(currentMovie.vote_average), imageLink: "https://image.tmdb.org/t/p/original\(String(describing: currentMovie.poster_path!))")
                }))
                
                completionBlock(Result.success(movieList))
            } catch {
                completionBlock(Result.failure(error))
            }
            
        })
        
        task.resume()
        
    }
    
    func createSimilarMovies(movieList: MovieList) {
        
        for i in 0..<min(5, movieList.movieList.count) {
            let movie = movieList.movieList[i]
            let id = movie.movieId
            let year = movie.movieYear
            let movieTitle = movie.movieTitle
            let rating = movie.movieRating
            let imageLink = movie.imageLink
            
            
            
            let similarMovie = Movie(id: id, name: movieTitle, year: year, rating: rating, imageLink: imageLink)
            
            similarMovies.append(similarMovie)
        
        
            
            self.movieDataSource.fetchImage(from: similarMovie, onCompletion: {
                
                print("alo")
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    
                    self.movieTableView.reloadData()
                }
                
            })
            
        }
        
        
    }
    
    func getApiKey() -> String {
        var apiKey = ""
        
        if let filepath = Bundle.main.path(forResource: "apiKey", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                apiKey = String(contents.prefix(32))
            } catch {
            }
        }
        return apiKey
        
        
    }
    
    func extendMovie(_ movie: Movie) -> ExtendedMovie {
        let extendedMovie = ExtendedMovie(id: movie.id, poster: movie.poster, name: movie.title, year: movie.year, rating: movie.rating, imageLink: movie.imageLink)
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
    
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let extendedMovie = extendMovie(movie)
        extendedMovie.shortDescription = shortDescriptionText
        extendedMovie.text = overviewText
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                if var cell = cell as? MovieListing {
                    cell.movie = extendedMovie
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "YearDurationLabelCell", for: indexPath)
                if var cell = cell as? MovieListing {
                    cell.movie = extendedMovie
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleShortDescriptionCell", for: indexPath)
                if var cell = cell as? MovieListing {
                    cell.movie = extendedMovie
                }
                return cell
            case 3:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath)
                if var cell = cell as? MovieListing {
                    cell.movie = extendedMovie
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMoviesLabelCell", for: indexPath)
                if var cell = cell as? MovieListing {
                    cell.movie = extendedMovie
                }
                return cell
            default:
                return UITableViewCell()}
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMovieCell", for: indexPath) as! SimilarMovieCell
            
            let similarMovie = self.similarMovies[indexPath.row]
            
            cell.setSimilarMovie(posterImage: similarMovie.poster, movieTitle: similarMovie.title, movieDescription: similarMovie.year, movieRating: similarMovie.rating)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return similarMovies.count
        }
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return 600
            case 1:
                return 20
            case 2:
                return 88
            case 3:
                return customHeight(text: overviewText, font: UIFont.systemFont(ofSize: 17), width: self.view.frame.width) + CGFloat(integerLiteral: 55)
            case 4:
                return 45
            default:
                return 0
            }
        default:
            return 120
        }
    }
    
}


