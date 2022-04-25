//
//  ViewController.swift
//  message-manager-uikit
//
//  Created by mainuser on 25.04.2022.
//

import UIKit

class MessagesController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private var viewModel = MessagesControllerViewModel()
    
    // MARK: - UI
    
    private let tableView = UITableView()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.delegate = self
        viewModel.fetchMessages()
    }
    
    // MARK: - HELPERS
    
    func configureUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        title = "Messages"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func createLoadFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
    
}

// MARK: - UITableViewDataSource

extension MessagesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel?.text = viewModel.messages[indexPath.row]
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
}

// MARK: - UITableViewDelegate

extension MessagesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastMessageIndex = viewModel.messages.count - 1
        
        if indexPath.row == lastMessageIndex {
            if !viewModel.hasFinished {
                self.tableView.tableFooterView = createLoadFooter()
                viewModel.fetchMessages()
            }
        }
    }
}


// MARK: - MessagesControllerViewModelDelegate

extension MessagesController: MessagesControllerViewModelDelegate {
    func updateMessagesController() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
        }
    }
}

