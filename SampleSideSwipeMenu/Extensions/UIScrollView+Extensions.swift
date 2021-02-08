//
//  UIScrollView+Extensions.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/05.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    /// 現在のページのインデックス
    var currentPageIndex: Int {
        let scrollViewWidth = self.frame.size.width
        guard scrollViewWidth != 0 else { return 0 }
        return Int(round(self.contentOffset.x / scrollViewWidth))
    }
    
}
