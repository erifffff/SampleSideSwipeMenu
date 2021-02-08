//
//  SampleViewController.swift
//  SampleSideSwipeMenu
//
//  Created by Eri Fujiwara on 2021/01/26.
//  Copyright © 2021 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment

class SampleViewController: UIViewController {

    // 上部のタイトル部分（検索バーの予定）
    private let hideScrollView = UIScrollView()
    // ページングの基盤となるVC
    private let pagingViewController = SamplePagingViewController()
    //
    private let sampleColorArray = [UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.blue]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: - navigationControllerではなく検索バーを置くことってできるのか
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .gray
        // navigationController領域
        self.title = "Sample App"
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]

            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().isTranslucent = false
        }
        // カスタムタブの登録
        pagingViewController.register(CustomPagingCell.self, for: CustomPaginItem.self)
        pagingViewController.register(CustomIconPagingCell.self, for: CustomIconItem.self)
        // タブのサイズ
        pagingViewController.menuItemSize = .selfSizing(estimatedWidth: 200, height: 60)
        // インジケータの設定
        pagingViewController.indicatorColor = .clear
        pagingViewController.borderOptions = .hidden
        // タブの文字色
        pagingViewController.selectedTextColor = .white
        pagingViewController.textColor = .gray
        pagingViewController.view.backgroundColor = .gray
        
        
        // 上部の隠れるタイトル部分の設定
        view.addSubview(hideScrollView)
        hideScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hideScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hideScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hideScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hideScrollView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        
        // 画面下部にpagingViewControllerを追加
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        // pagingViewDelegate, Datasource
        pagingViewController.delegate = self
        pagingViewController.dataSource = self
        // ページングビューのそのもののautolayout
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([        pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                             pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                             pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                             pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
])
        // タブ部分の設定
        navigationController.view.addSubview(pagingViewController.collectionView)
        //
        pagingViewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.collectionView.layer.cornerRadius = 5
        NSLayoutConstraint.activate([
            pagingViewController.collectionView.heightAnchor.constraint(equalToConstant: pagingViewController.options.menuItemSize.height),
            pagingViewController.collectionView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            pagingViewController.collectionView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            pagingViewController.collectionView.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
        ])
       
        
        // TODO: これがあるとableViewが動かなくなる
        // セルの再利用対策がなってない
        // tableViewのセルの対策
//        extendedLayoutIncludesOpaqueBars = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 選択されてるtableView部分
        guard let viewController = pagingViewController.pageViewController.selectedViewController as? CustomTableViewController else { return }
        // tableViewがスクロールされる時、タイトル部分から下のタブ部分＋tableView部分とサイズを合わせる？
        hideScrollView.contentInset = viewController.tableView.contentInset
        hideScrollView.contentOffset = viewController.tableView.contentOffset
        hideScrollView.contentSize = viewController.tableView.contentSize
        
        viewController.tableView.delegate = self

    }

}


extension SampleViewController: PagingViewControllerDataSource {
    
    /// タブ部分の設定
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let title = appendingStr(str: "タブ index:\(index)", index: index)
        let color = sampleColorArray[index]
        
        let lastIndex = sampleColorArray.count - 1
        if index == lastIndex {
            // TODO:
            let button = UIButton()
            button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
            let item = CustomIconItem(image: nil, index: index, color: color, button: button)
            return item
        }
        return CustomPaginItem(index: index, title: title, color: color)
    }
    
    @objc func addItem() {
        print("adddddd")
    }
    
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let color = sampleColorArray[index]
        let tableViewController = CustomTableViewController()
        tableViewController.color = color
        tableViewController.index = index
        tableViewController.tableView.delegate = self
        // セルがnavigationBarにかぶらないようにする設定
        let insets = UIEdgeInsets(top: pagingViewController.options.menuItemSize.height, left: 0, bottom: 0, right: 0)
        tableViewController.tableView.scrollIndicatorInsets = insets
        tableViewController.tableView.contentInset = insets

        return tableViewController
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 4
    }
    
    
    private func appendingStr(str: String, index: Int) -> String {
        var title = ""
        for i in 0 ... index {
            title += str
        }
        return title
    }
    
    
}


extension SampleViewController: PagingViewControllerDelegate {

    /// 横スクロールで次ページへ遷移したときの処理
    func pagingViewController(_: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        print("pagingViewController: willScroll")
        Logger.log("pagingViewController: willScroll")
        // 現在表示されてるページ？
        guard let startingViewController = startingViewController as? CustomTableViewController else { return }
        // 別ページにスクロールされた時、表示されていたtableViewのdelegateを破棄
        startingViewController.tableView.delegate = nil
    }
    
    ///
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        print("pagingViewController: didScrollToItem")
        print("transitionSuccessful: \(transitionSuccessful)")
        Logger.log("pagingViewController: didScrollToItem")
        Logger.log("transitionSuccessful: \(transitionSuccessful)")
        guard let destinationViewController = destinationViewController as? CustomTableViewController else { return }
        guard let startingViewController = startingViewController as? CustomTableViewController else { return }
        // 遷移成功時遷移先のtableViewのdelegateを実装
        if transitionSuccessful {
            destinationViewController.tableView.delegate = self
            // 表示されたtableViewのcontentSizeに合わせる
            hideScrollView.contentSize = destinationViewController.tableView.contentSize
            hideScrollView.contentOffset = destinationViewController.tableView.contentOffset
            hideScrollView.contentInset = destinationViewController.tableView.contentInset
            // ページ追加ダイアログだす
        }else{
            startingViewController.tableView.delegate = self
        }
        // returnする意味わからん、、
        return
    }
    
    // 存在するメソッドなのかわからん。。
//    func pagingViewController(
//      _ pagingViewController: PagingViewController,
//        didSelectItem pagingItem: PagingItem){
//
//
//    }
    
}


////MARK: - PagingViewControllerSizeDelegate
///// タブ部分のサイズを調整するためのDelegate実装
//extension SampleViewController: PagingViewControllerSizeDelegate {
//    func pagingViewController(_ pagingViewController: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
//        guard let item = pagingItem as? CustomPaginItem else { return 0 }
//        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.options.menuItemSize.height)
//        let attributes = [NSAttributedString.Key.font: pagingViewController.options.font]
//        let rect = item.title.boundingRect(with: size,
//                                           options: .usesLineFragmentOrigin,
//                                           attributes: attributes,
//                                           context: nil)
//        // TODO: このままだとタブの部分のレイアウトが崩れる
//        let width = ceil(rect.width) + insets.left + insets.right
//
//        if isSelected {
//          return width * 1.5
//        } else {
//          return width
//        }
//      }
//
//}

//MARK: - UITableViewDelegate
/// 表示されているtableViewに対するアクションを有効にするためのDelegate実装
/// DataSourceは値が設定された状態で表示されるのでこっちで実装する必要なし
extension SampleViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableViewが引っ張られた時にサイズを更新？
            self.hideScrollView.contentOffset = scrollView.contentOffset
            self.hideScrollView.panGestureRecognizer.state = scrollView.panGestureRecognizer.state
    }
    
}
