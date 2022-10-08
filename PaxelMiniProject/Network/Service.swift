//
//  Service.swift
//  PaxelMiniProject
//
//  Created by Renzo Alvaroshan on 08/10/22.
//

import Foundation
import Alamofire

struct Constant {
    static let baseURL = "https://api.github.com/search/repositories?q="
}

class Service {
    
    static let shared = Service()
    
    func getRepositories(query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let url = "\(Constant.baseURL)\(query)"
        
        let request = AF.request(url)
        
        request
            .validate()
            .responseDecodable(of: RepositoryResponse.self) { response in
                switch response.result {
                case .success(let results):
                    let repositories = results.repositories
                    completion(.success(repositories))
                case .failure(let error):
                    print(error)
                }
            }
    }
}
