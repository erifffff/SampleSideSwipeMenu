//
//  CustomCellTableViewCell.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/14.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

protocol CustomCellTableViewCellDelegate {
    func didChangeText(text: String?, cell: CustomCellTableViewCell)
}

class CustomCellTableViewCell: UITableViewCell {
    
    var textField: UITextField?
    var textView: UITextView?
    var delegate: CustomCellTableViewCellDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell() {
        //TODO: - セルの再利用対策になってないので見直す
        if self.textView != nil {
            self.textView?.removeFromSuperview()
            self.textField?.removeFromSuperview()
        }
        
        self.textField = UITextField()
        self.textView = UITextView()
                
        textField?.delegate = self
        textView?.delegate = self

        textField?.minimumFontSize = 8
        textField?.placeholder = "Sample Word.."
        textField?.borderStyle = .none
        textField?.adjustsFontSizeToFitWidth = true
        textField?.font = UIFont.systemFont(ofSize: 18)
        textField?.backgroundColor = .clear
        
        textView?.isScrollEnabled = false
        textView?.isEditable = true
        textView?.font = UIFont.systemFont(ofSize: 18)
        textView?.backgroundColor = .clear
        textView?.text = "sample.."
        self.contentView.addSubview(textField!)
        self.contentView.addSubview(textView!)
        
        // textField autolayout
        textField?.translatesAutoresizingMaskIntoConstraints = false
        textField?.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        textField?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        textField?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        textField?.bottomAnchor.constraint(equalTo: textView!.topAnchor, constant: -5).isActive = true
        
        // FIX ME: - 改行時textFieldに一瞬かぶるのは改善できないのか
        // textView autolayout
        textView?.translatesAutoresizingMaskIntoConstraints = false
        textView?.topAnchor.constraint(equalTo: textField!.bottomAnchor, constant: 5).isActive = true
        textView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        textView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        textView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

    }
}

// MARK: - UITextViewDelegate

    extension CustomCellTableViewCell: UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            delegate?.didChangeText(text: textView.text, cell: self)
        }
    }

// MARK: - UITextFieldDelegate

extension CustomCellTableViewCell: UITextFieldDelegate {
    
}
