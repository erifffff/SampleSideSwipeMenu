//
//  PagingView.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/05.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit

public protocol PagingViewDelegate: class {
    func pagingView(_ pagingView: SlidePagingView, didChangePageAt index: Int)
    func pagingView(_ pagingView: SlidePagingView, didTapPageAt index: Int)
}

/// 横スライドビュー
public class SlidePagingView: UIView {

    public weak var delegate: PagingViewDelegate?
    // TODO: viewではなくtextFieldに変更する
    public var views: [UIView] = [] {
        willSet {
            views.forEach { $0.removeFromSuperview() }
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        didSet {
            views.forEach { view in
                view.translatesAutoresizingMaskIntoConstraints = false

                let pageFrameView = UIView()
                pageFrameView.translatesAutoresizingMaskIntoConstraints = false
                pageFrameView.addSubview(view)
                stackView.addArrangedSubview(pageFrameView)

                view.leadingAnchor.constraint(equalTo: pageFrameView.leadingAnchor, constant: spacing / 2).isActive = true
                view.trailingAnchor.constraint(equalTo: pageFrameView.trailingAnchor, constant: -spacing / 2).isActive = true
                view.topAnchor.constraint(equalTo: pageFrameView.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: pageFrameView.bottomAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -spacing * 2 * 2).isActive = true
                view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

                setNeedsLayout()
            }
            if currentPageIndex >= views.count {
                scrollTo(index: 0, animated: false)
            }
        }
    }

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var spacing: CGFloat = 16

    var currentPageIndex: Int {
        let scrollViewWidth = scrollView.frame.size.width
        guard scrollViewWidth != 0 else { return 0 }
        return Int(round(scrollView.contentOffset.x / scrollViewWidth))
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }

    private func initCommon() {
        translatesAutoresizingMaskIntoConstraints = false
        initScrollView()
        initStackView()
    }

    private func initScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing / 2 * 3).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing / 2 * 3).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped)))
    }

    @objc func scrollViewTapped() {
        delegate?.pagingView(self, didTapPageAt: currentPageIndex)
    }

    private func initStackView() {
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0

        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let pageWidth = scrollView.bounds.width
        let width = pageWidth * CGFloat(views.count)
        let height = frame.height
        scrollView.contentSize = CGSize(width: width, height: height)
    }

    public func scrollTo(index: Int, animated: Bool) {
        var rect = scrollView.frame
        rect.origin.x = rect.width * CGFloat(index)
        rect.origin.y = 0
        scrollView.scrollRectToVisible(rect, animated: animated)
    }

}

extension SlidePagingView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.pagingView(self, didChangePageAt: currentPageIndex)
    }
}
