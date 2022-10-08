//
//  RepoViewModel.swift
//  PaxelMiniProject
//
//  Created by Renzo Alvaroshan on 08/10/22.
//

import Foundation

protocol RepoViewDelegate: AnyObject {
    func reloadView()
    func displayLoading()
    func hideLoading()
}

class RepoViewModel {
    
    // MARK: - Properties
    
    weak var delegate: RepoViewDelegate?
    
    var repositories: [Repository] = []
    
    // MARK: - Helpers
    
    func fetchRepositories(query: String) {
        delegate?.displayLoading()
        Service.shared.getRepositories(query: query) { result in
            switch result {
            case .success(let repositories):
                self.repositories = repositories
                self.delegate?.reloadView()
                self.delegate?.hideLoading()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
