//
//  CustomIconPagingCell.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/12.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment



struct CustomIconItem: PagingItem, Hashable, Comparable {
  
  let image: UIImage?
  let index: Int
    let color: UIColor
    let button: UIButton?
  
  static func <(lhs: CustomIconItem, rhs: CustomIconItem) -> Bool {
    return lhs.index < rhs.index
  }
    
}


class CustomIconPagingCell: PagingCell {
  
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    fileprivate lazy var bgView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    // 角丸の設定
    contentView.layer.cornerRadius = 6
    contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    contentView.clipsToBounds = true
    contentView.addSubview(bgView)
    contentView.addSubview(button)
    // collectionViewのセルのレイアウト設定
    //TODO: - ここでラベルとviewの制約を入れる
    contentView.constrainToEdges(bgView)
    contentView.constrainToEdges(button, constant: 10)

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        let item = pagingItem as! CustomIconItem
        bgView.backgroundColor = item.color
        if let button = item.button  {
            self.button = button
        }
        button.backgroundColor = .gray
        button.imageView?.image = item.image
        // TODO: - これをvc側で実装させる
//        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
    }
    
    // 動作としては、読み込みして再度同じ画面に遷移する　その際に画面の作り直しをしている
    @objc func addItem() {
        print("addItem")
        Logger.log("")
    }
  
}
