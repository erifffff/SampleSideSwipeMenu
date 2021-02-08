//
//  AddButtonPagingCell.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/14.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment

struct AddButtonItem: PagingItem, Hashable, Comparable {
    let button: UIButton?
    let index: Int
    init(button: UIButton, index: Int) {
        self.button = button
        self.index = index
    }
    static func <(lhs: AddButtonItem, rhs: AddButtonItem) -> Bool {
        return lhs.index < rhs.index
    }
}


// MARK: - PagingCell

class AddButtonPagingCell: PagingCell {
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
//        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
//        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        button.trailingAnchor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
