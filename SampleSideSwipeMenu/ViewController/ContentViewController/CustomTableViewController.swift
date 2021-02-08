//
//  CustomTableViewController.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/14.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

class CustomTableViewController: UITableViewController {
    
    var color: UIColor?
    var index: Int?
    
    convenience init(color: UIColor, index: Int) {
        self.init()
        self.color = color
        self.index = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = self.color {
            self.view.backgroundColor = color
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCellTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CustomCellTableViewCell.self))
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100000
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CustomCellTableViewCell.self), for: indexPath) as? CustomCellTableViewCell else { fatalError() }
        
        if let color = self.color {
            cell.contentView.backgroundColor = color
        }
        cell.setCell()
        cell.delegate = self
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 750
        
    }
}

//MARK: - CustomCellTableViewCellDelegate

extension CustomTableViewController: CustomCellTableViewCellDelegate {
    // Expanding teable view cell delegate
    func didChangeText(text: String?, cell: CustomCellTableViewCell) {
        cell.textView?.sizeToFit()
        cell.textField?.sizeToFit()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
