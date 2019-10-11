//
//  MovieListScreen.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 11/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var loaderView: UIView!
    
    var fetchingMore = false {
        didSet {
            movieTableView.tableFooterView = fetchingMore ? loaderView : nil
        }
    }
    
    var numberOfScrollUpdates = 0
    var movieDataSource = MovieDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        self.navigationItem.title = "Movies"
        self.navigationItem.searchController = searchController
        
        fetchMovieBatch()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore && numberOfScrollUpdates <= 5 {
                fetchMovieBatch()
            }
        }
    }
    
    private func fetchMovieBatch() {
        fetchingMore = true
        numberOfScrollUpdates += 1
        
        movieDataSource.fetch(numberOfScrollUpdates) {
            self.fetchingMore = false
            self.movieTableView.reloadData()
            
            for movie in self.movieDataSource.movies {
                self.movieDataSource.fetchImage(from: movie, onCompletion: {
                    self.movieTableView.reloadData()
                })
            }
            
        }
        
        
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            movieTableView.reloadData()
            return
        }
        
        if (searchText.count > 0) {
            movieDataSource.filter(by: searchText)
            movieTableView.reloadData()
        } else {
            movieTableView.reloadData()
        }
        
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieDataSource.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movieDataSource.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.setMovie(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "MovieViewController") as! MovieViewController
        viewController.movie = movieDataSource.movies[indexPath.row]
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        download image + cleanup
        //        self.movieDataSource.fetchImage(from: movieDataSource.movies[indexPath.row], onCompletion: {
        //            self.movieTableView.reloadData()
        //        })
    }
    
}
