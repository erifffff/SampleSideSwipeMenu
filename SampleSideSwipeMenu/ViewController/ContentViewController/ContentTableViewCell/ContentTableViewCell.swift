//
//  ContentTableViewCell.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/05.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

/// textViewの高さに合わせるための処理と入力内容をTODOに保存するための処理をdelegateとして
/// 実装する側で値を取得・保存してもらう
protocol ContentTableViewCellDelegate: class {
    func didChangeText(text: String?, cell: ContentTableViewCell)
}


class ContentTableViewCell: UITableViewCell {

    var color: UIColor?
    /// タイトル
    var textField: UITextField = UITextField() {
        willSet {
            textField.removeFromSuperview()
        }
    }
    /// 内容
    var descriptionTextView: UITextView!
    
    /// delegate
    weak var contentTableViewCellDelegate: ContentTableViewCellDelegate?
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.contentView.backgroundColor = color
//        // textViewの設定
//        descriptionTextView.isScrollEnabled = false
//        descriptionTextView.isEditable = true
//        descriptionTextView.delegate = self
//        self.contentView.addSubview(descriptionTextView)
//        // textviewのautolayout
//        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        descriptionTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        descriptionTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
//        descriptionTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCellUI() {
        // セルの再利用対策？
        self.descriptionTextView = UITextView()
        self.contentView.backgroundColor = color
        // textViewの設定
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = true
        descriptionTextView.delegate = self
        descriptionTextView.inputAccessoryView = doneToolBar()
        self.contentView.addSubview(descriptionTextView)
        // textviewのautolayout
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true

    }
    
    private func doneToolBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endInput))]
        return toolbar

    }
    
    @objc func endInput() {
        self.descriptionTextView.resignFirstResponder()
    }


}


// MARK: - UITextViewDelegate

extension ContentTableViewCell: UITextViewDelegate {

    // 入力中の処理
    
    func textViewDidChange(_ textView: UITextView) {
        contentTableViewCellDelegate?.didChangeText(text: textView.text, cell: self)
    }
    
}

//extension ContentTableViewCell: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
