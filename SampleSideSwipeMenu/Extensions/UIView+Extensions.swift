//
//  UIView+Extensions.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/09.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit


// MARK: - extension UIView(viewの制約)

extension UIView {
    // TODO: - 制約メソッド直す　これだと専用になってしまうので。
    func constrainToEdges(_ subview: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) {
    
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: multiplier,
      constant: constant)
    
    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: multiplier,
      constant: -constant)
    
    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: multiplier,
      constant: constant)
    
    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: multiplier,
      constant: -constant)
    
    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint])
  }
  
}
