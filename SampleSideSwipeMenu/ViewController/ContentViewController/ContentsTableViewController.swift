//
//  ContentsTableViewController.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/05.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

/// 下部ビューのcontentViewにあたる部分
/// このクラスで実装していいのはdatasourceにあたる内容やらレイアウトのみ
/// 実際のアクションはdelegate実装先のviewControllerで実装
class ContentsTableViewController: UITableViewController {
    
    static let CellIdentifier = "CellIdentifier"
    var color: UIColor!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
//        Logger.log("ContentsTableViewController: index:\(self.index)")
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ContentTableViewCell.self))
        tableView.estimatedRowHeight = 100000
        tableView.rowHeight = UITableView.automaticDimension

        self.tableView.backgroundColor = color
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ContentTableViewCell.self), for: indexPath) as? ContentTableViewCell else { fatalError() }
        cell.setCellUI()
        cell.contentTableViewCellDelegate = self
        cell.layoutIfNeeded()
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100000
    }
}


//MARK: - ContentTableViewCellDelegate

extension ContentsTableViewController: ContentTableViewCellDelegate {
    func didChangeText(text: String?, cell: ContentTableViewCell) {
        cell.descriptionTextView.sizeToFit()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
}
