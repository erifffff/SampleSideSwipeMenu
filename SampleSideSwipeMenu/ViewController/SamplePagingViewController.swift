//
//  SamplePagingViewController.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/09.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment


/// ページングするViewControllerをスクロールさせるための上書き
/// UICollectionViewとUIViewを合わせた１ページ
class SamplePagingView: PagingView {
    
    override func setupConstraints() {
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 表示されるview部分のautolayoutを表示されるvcのview部分と合わせる
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

/// ページングさせる基盤のPagingViewController
class SamplePagingViewController: PagingViewController {
    
    override func loadView() {
        // PagingViewControllerのview自体を↑カスタムのPageViewで上書き
        view = SamplePagingView(options: options,
                                collectionView: collectionView,
                                pageView: pageViewController.view)
    }
}

