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
    case noResult
    
}

enum ContentError: Error {
    case invalidAccess
}

class MovieListViewModel: ObservableObject {
    
    @Published var dataFetchCompleted: DataFetchStatus = .noResult
    
    var cellVMs: [MovieCellViewModel]
    
    var cancellables: Set<AnyCancellable> = []
    
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var searchTextClearSubject = PassthroughSubject<String, Never>()
    
    private let httpClient: HTTPClient
    
    @Published var noContentLabel: String = ""
    
    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
        self.cellVMs = [MovieCellViewModel]()
        self.subscribeToSearchSubject()
        self.subscribeToSearchTextClearSubject()
    }
    
    private func subscribeToSearchSubject() {
        searchTextSubject.receive(on: DispatchQueue.main)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.loadMovies(from: searchText)
                self?.noContentLabel = self?.cellVMs.count == 0 ? "No Content" : ""
            }.store(in: &cancellables)
    }
    
    private func subscribeToSearchTextClearSubject() {
        searchTextClearSubject.receive(on: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.loadMovies(from: searchText)
                self?.noContentLabel = ""
            }.store(in: &cancellables)
    }

    func search(with text: String) {
        searchTextSubject.send(text)
    }
    
    func clearText() {
        searchTextClearSubject.send("")
    }
    
    func loadMovies(from search: String) {
        do {
            self.cellVMs = []
            let publisher = httpClient.fetchMovies(search: search)
            
            publisher.sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Should update UI now")
                    if let cellVms = self?.cellVMs, cellVms.count > 0 {
                        self?.dataFetchCompleted = .succeded
                    } else {
                        self?.dataFetchCompleted = .noResult
                    }
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
