//
//  MovieDetailViewModel.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import Foundation
import Combine

enum DataFetchStatus {
    case succeded
    case failed
    case notDone
}

enum ContentError: Error {
    case invalidAccess
}

class MovieListViewModel: ObservableObject {
    
    @Published var dataFetchCompleted: DataFetchStatus = .notDone
    var cellVMs: [MovieCellViewModel]
    
    var cancellables: Set<AnyCancellable> = []
    
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
        self.cellVMs = [MovieCellViewModel]()
    }
    
    func loadMovies(search: String) {
        do {
            let publisher = httpClient.fetchMovies(search: search)
            
            publisher.sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Should update UI now")
                    self?.cellVMs.forEach { cellVM in
                        print(cellVM.titleString)
                    }
                    self?.dataFetchCompleted = .succeded
                case .failure(let error):
                    print("fetch failed due to \(error)")
                    self?.dataFetchCompleted = .failed
                }
            } receiveValue: { movies in
                self.cellVMs = movies.map { movie in
                    return MovieCellViewModel(movie: movie)
                }
            }.store(in: &cancellables)
        }
    }
    
    private func loadDummyData() {
        // load dummy data when fetch failed
        let cellVMOne = MovieCellViewModel(movie: Movie(title: "John Hicks", year: "1988", imdbID: "12322", poster: "some_value"))
        let cellVMTwo = MovieCellViewModel(movie: Movie(title: "Game of Throne", year: "1980", imdbID: "12922", poster: "some_value"))
        let cellVMThree = MovieCellViewModel(movie: Movie(title: "Goergia and Giny", year: "1908", imdbID: "14322", poster: "some_value"))
        self.cellVMs = [cellVMOne, cellVMTwo, cellVMThree]
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
