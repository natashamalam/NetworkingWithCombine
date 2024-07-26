//
//  MovieCellViewModel.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import UIKit


class MovieCellViewModel {
    
    private let movie: Movie
    
    var titleString: String {
        return movie.title
    }
    
    var releaseYearString: String {
        return movie.year
    }
    
    // when it gets the image, it needs to tell the view to update
    var posterImage: UIImage?
    
    init(movie: Movie) {
        self.movie = movie
        
        // as soon as cell-vm is created, it needs to start fetching the image
        self.setPosterImage()
    }
    
    // this needs to fetch the image-data from network
    // and set the poster image property
    func setPosterImage() {
        let imageNameString = movie.poster
        self.posterImage = downloadedImage(named: imageNameString)
    }
    
    // download image
    func downloadedImage(named imageName: String) -> UIImage? { return nil }
    
}
