//
//  CustomPagingCell.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/08.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment

/// タブ部分のセル設定
class CustomPagingCell: PagingCell {
    
    /// 背景にするview
    fileprivate lazy var titleView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 角丸の設定
        contentView.layer.cornerRadius = 6
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        contentView.addSubview(titleView)
        contentView.addSubview(titleLabel)
        // collectionViewのセルのレイアウト設定
        //TODO: - ここでラベルとviewの制約を入れる
        contentView.constrainToEdges(titleView)
        contentView.constrainToEdges(titleLabel, constant: 10)
    }

    required init?(coder: NSCoder) {
        fatalError("fatalError:")
    }

    /// タブ部分の設定
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        let item =  pagingItem as! CustomPaginItem
        titleLabel.text = item.title
        titleView.backgroundColor = item.color
    }
    
    private func addViewConstraint() {
        
    }
}


// MARK: - PagingItem(タブのプロトコル)

struct CustomPaginItem: PagingItem, Hashable, Comparable {
  let index: Int
  let title: String
  let color: UIColor
  
  static func < (lhs: CustomPaginItem, rhs: CustomPaginItem) -> Bool {
    return lhs.index < rhs.index
  }
}
