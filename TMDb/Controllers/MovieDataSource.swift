//
//  MovieArray.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 18/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import Foundation
import UIKit

class MovieDataSource {
    
    var movies: [Movie] = []
    
    func fetch(_ page: Int, on queue: DispatchQueue = .main, completionHandler: @escaping () -> Void) {
        
        let newQueue = DispatchQueue(label: "com.bgmunteanu.TMDb.backgroundThread", qos: DispatchQoS(qosClass: .background, relativePriority: 1))
        
        newQueue.async {
            self.getMovies(page: page, completionBlock: { result in
                switch result {
                case .success(let movieList):
                    self.createMovie(movieList: movieList, page: page)
                    queue.async {
                        completionHandler()
                    }
                case .failure(let error):
                    print(error)
                }
            })
            
        }
    }
    
    private func getMovies(page: Int, completionBlock: @escaping (Result<MovieList, Error>) -> Void)  {
        
        let urlComponents = { () -> URLComponents in
            var url = URLComponents()
            
            url.scheme = "https"
            url.path = "api.themoviedb.org/3/discover/movie"
            url.queryItems = [
                URLQueryItem(name: "api_key", value: self.getApiKey()),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
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
    
    private func createMovie(movieList: MovieList, page: Int) {
        
        var tempMovies: [Movie] = []
        
        for movie in movieList.movieList {
            let id = movie.movieId
            let year = movie.movieYear
            let movieTitle = movie.movieTitle
            let rating = movie.movieRating
            let imageLink = movie.imageLink
            tempMovies.append(Movie(id: id, name: movieTitle, year: year, rating: rating, imageLink: imageLink))
        }
        
        movies += tempMovies
    }
    
    func fetchImage(from movie: Movie, onCompletion: @escaping () -> Void) {
        
        let session = URLSession.shared
        
        let url = URL(string: movie.imageLink)
        
        if (!movie.hasPoster)
            
        {
            let downloadTask = session.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url!)
                    movie.poster = UIImage(data: data)!
                    movie.hasPoster = true
                    DispatchQueue.main.async {
                        onCompletion()
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
                
            }
            
            downloadTask.resume()
        }
    }
    
    private func sorted(by: (Movie, Movie) -> Bool) {
        movies.sort(by: by)
    }
    
    func filter(by term: String) {
        movies = movies.filter({ movie -> Bool in
            movie.name.lowercased().contains(term.lowercased())
        })
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
