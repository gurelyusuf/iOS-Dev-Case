//
//  MainViewController.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 70
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    @Published private(set) var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setTableView()
        setupRefreshControl()
        setBindings()
        
        navigationItem.title = "Users"
    }
}

// MARK: - UI Setup
extension MainViewController {
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loadingSpinner)

        NSLayoutConstraint.activate([
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Spinner Constraints
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setTableView() {
        tableView.isHidden = true
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        // Call the view model to fetch fresh data
        viewModel.getUsers()
    }

    private func updateTableView() {
        tableView.isHidden = false
        tableView.reloadData()
    }

    private func setBindings() {
        viewModel.updateResult
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("OK: done")
                case .failure(let error):
                    print("Received error: \(error.rawValue)")
                    self.refreshControl.endRefreshing()
                }
            } receiveValue: { [weak self] updated in
                self?.loadingSpinner.stopAnimating()
                self?.loadingSpinner.isHidden = true
                self?.refreshControl.endRefreshing()

                if updated {
                    self?.updateTableView()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - TableView Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.users[indexPath.row])
        
        cell.selectionStyle = .none
        cell.backgroundColor = .systemBackground
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.systemGray6
        }
        
        return cell
    }
}

// MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailViewController()
        detailsViewController.configure(with: DetailViewModel(user: viewModel.users[indexPath.row].user))
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
