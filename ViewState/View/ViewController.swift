//
//  ViewController.swift
//  ViewState
//
//  Created by junichi.shimada on 2020/06/12.
//  Copyright © 2020 junichi.shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var usecase: UserUseCase!
    private var viewData: [User] = []
    private var viewStore: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.inject()
        
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

        self.refreshControl.beginRefreshing()
        self.fetch()
    }

    func fetch() {
        usecase.fetch()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        for view in viewStore {
            view.removeFromSuperview()
        }
        viewStore = []
        self.fetch()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewData[indexPath.row].name
        return cell
    }
}

extension ViewController: ViewProcotol {
    func inject() {
        usecase = UserUseCase()
        usecase.viewOutput = self
    }
    
    func update(state: State) {
        switch state {
        case .idle:
            break
        case .loading:
            viewData = []
            tableView.reloadData()
        case .loaded(let viewData):
            self.viewData = viewData
            tableView.reloadData()
            self.refreshControl.endRefreshing()
        case .nodata:
            let view = self.nodataView()
            viewStore.append(view)
            tableView.addSubview(view)
            self.refreshControl.endRefreshing()
        case .error:
            let view = self.errorView()
            viewStore.append(view)
            tableView.addSubview(view)
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupView(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.textColor = .gray
        label.frame = self.view.frame
        label.center = self.view.center
        label.textAlignment = .center
        return label
    }
    
    func nodataView() -> UIView {
        return self.setupView(text: "No Data")
    }
    
    func errorView() -> UIView {
        return self.setupView(text: "Network Error")
    }
}
