//
//  MovieDetailViewModel.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import Foundation
import Combine


enum ContentError: Error {
    case invalidAccess
}


enum NetworkError: Error {
    case badRequest
    case invalidURL
}

class MoviesViewModel {
    
    // when cellVM is populated, we need to reload the table
    // but how?
    var cellVMs: [MovieCellViewModel]
    
    var cancellables: [AnyCancellable] = [AnyCancellable]()
    
    init() {
        self.cellVMs = [MovieCellViewModel]()
        
        do {
            let publisher = try self.fetchContent()
            publisher.sink { completion in
                switch completion {
                case .finished:
                    print("Should update UI now")
                case .failure(let error):
                    print("fetch failed due to \(error)")
                }
            } receiveValue: { movieResponse in
                let movies = movieResponse.search
                self.cellVMs = movies.map { movie in
                    return MovieCellViewModel(movie: movie)
                }
            }.store(in: &cancellables)
            
        } catch {
            // dummy data when fetch failed
            let cellVMOne = MovieCellViewModel(movie: Movie(title: "John Hicks", year: "1988", imdbID: "12322", poster: "some_value"))
            let cellVMTwo = MovieCellViewModel(movie: Movie(title: "Game of Throne", year: "1980", imdbID: "12922", poster: "some_value"))
            let cellVMThree = MovieCellViewModel(movie: Movie(title: "Goergia and Giny", year: "1908", imdbID: "14322", poster: "some_value"))
            self.cellVMs = [cellVMOne, cellVMTwo, cellVMThree]
        }
    }
    
    private func fetchContent() throws -> AnyPublisher<MovieResponse, Error>{
        guard let url = URL(string: "http://www.omdbapi.com/?s=batman&apikey=42d96f0d") else {
            throw NetworkError.invalidURL
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpsResponse = response as? HTTPURLResponse,
                      httpsResponse.statusCode == 200 else {
                    throw NetworkError.badRequest
                }
                return data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func numberOfContent() -> Int {
        return cellVMs.count
    }
    
    func cellVM(at index: Int) throws -> MovieCellViewModel {
        guard index >= 0,
              index < cellVMs.count else {
            throw ContentError.invalidAccess
        }
        
        return cellVMs[index]
    }
    
}
