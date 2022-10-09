//
//  ViewController.swift
//  PaxelMiniProject
//
//  Created by Renzo Alvaroshan on 06/10/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = RepoViewModel()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var repoSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private lazy var repoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.identifier)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor(named: "buttonColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureSearchBar()
        configureTableView()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Selectors
    
    @objc func doSomething() {
        guard let text = repoSearchBar.text else { return }
        viewModel.fetchRepositories(query: text)
        refreshControl.endRefreshing()
    }
    
    @objc func searchTapped() {
        guard let text = repoSearchBar.text else { return }
        viewModel.fetchRepositories(query: text)
        self.repoSearchBar.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func configureSearchBar() {
        view.addSubview(repoSearchBar)
        repoSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(80)
        }
        
        repoSearchBar.delegate = self
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(repoSearchBar)
            make.leading.equalTo(repoSearchBar.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    private func configureTableView() {
        title = "Paxel Mini Project"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(repoTableView)
        repoTableView.snp.makeConstraints { make in
            make.top.equalTo(repoSearchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        repoTableView.dataSource = self
        repoTableView.delegate = self
        
        repoTableView.refreshControl = refreshControl
        
        repoTableView.rowHeight = UITableView.automaticDimension
        repoTableView.estimatedRowHeight = 120
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.fetchRepositories(query: text)
        self.repoSearchBar.endEditing(true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath) as? RepoCell else { return UITableViewCell() }
        
        let repositories = viewModel.repositories
        let repo = repositories[indexPath.row]
        cell.configure(with: repo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repositories = viewModel.repositories
        let repo = repositories[indexPath.row]
        
        if let url = URL(string: repo.owner.htmlURL) {
            UIApplication.shared.open(url)
        }
    }
}

extension ViewController: RepoViewDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.repoTableView.reloadData()
        }
    }
    
    func displayLoading() {
        repoTableView.tableFooterView = spinner
        spinner.startAnimating()
        repoTableView.reloadData()
    }

    func hideLoading() {
        spinner.stopAnimating()
        repoTableView.reloadData()
    }
}
