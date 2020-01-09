//
//  TableViewDemoController.swift
//  Demo
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import Foundation
import UIKit
import POSInfiniteScroll

final class TableViewDemoController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var items: [String] = Array.randomElements
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInfiniteScroll()
        addPullToRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.beginPullToRefresh()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.page = 0
                self.items = Array.randomElements
                self.tableView.reloadData()
                self.tableView.finishPullToRefresh()
            }
        }
    }
    
    private func addInfiniteScroll() {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .red
        tableView.infiniteScrollSpinnerView = spinner
//        tableView.infiniteScrollTriggerOffset = 500
        
        tableView.addInfiniteScroll { [weak self] tableView in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.page += 1
                self?.items += Array.randomElements
                tableView.reloadData()
                tableView.finishInfiniteScroll()
            }
        }
        
        tableView.shouldRemoveInfiniteScrollHandler = { [weak self] in
            return self?.page == 3
        }
    }
    
    private func addPullToRefresh() {
        tableView.addPullToRefresh { [weak self] tableView in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.page = 0
                self?.items = Array.randomElements
                tableView.reloadData()
                tableView.finishPullToRefresh()
                self?.addInfiniteScroll()
            }
        }
    }
}

extension TableViewDemoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
