//
//  SelfSizingViewController.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/05.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment

/*
 - LargeTitleをもして作る
 
   SelfSizingPagingView:
    ページングするVCのviewにあたるカスタムPagingView
   SelfSizingPagingViewController:
    ページングするVC のviewを作成したカスタムPagingViewに上書きした、ページングする仕組みのある、
    基盤となるVC
   SelfSizingViewController:
    ↑のVCをのせた、表示されるVC 初期表示をこのVCにすれば良い
 
 
 メモ
 ImagesのExampleでは
 UnsplashViewController - 表示されるVC（前VCから遷移する時、これを生成し遷移）
 ImagePagingCell - タブ部分にあたる カスタムするならこれでPagingCellにするべき
 ImageCollectionViewCell - 下部に表示されるcontentViewにあたるもの
 ImagesViewController - たぶとcontentViewを合わせたもの PagingVCそのもの
 
 
 
 */


struct SelfSizingItem: PagingItem, Hashable, Comparable {
  let index: Int
  let title: String
  let color: UIColor
  
  static func < (lhs: SelfSizingItem, rhs: SelfSizingItem) -> Bool {
    return lhs.index < rhs.index
  }
}



/// ページングするViewControllerをスクロールさせるための上書き
class SelfSizingPagingView: PagingView {
    
    override func setupConstraints() {
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
}

/// ページングさせる基盤のPagingViewController
class SelfSizingPagingViewController: PagingViewController {
    
    //
//    var items = [Item]()
//    var currentItems = [Item]()
    
    override func loadView() {
        // PagingViewControllerのview自体を↑で作成したカスタムのPageViewで上書き
        // ExampleのImageパターンで、ImagePagingCellでcornerRadiusしてるからここかも
        view = SelfSizingPagingView(options: options,
                                    collectionView: collectionView,
                                    pageView: pageViewController.view)
    }
    
}

extension SelfSizingViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
//            currentItems = items
            
            return
        }
    }

}

/// 元になる個体のUIViewController
class SelfSizingViewController: UIViewController {

    // 上部のタイトル部分（検索バーの予定）
    private let hideScrollView = UIScrollView()
    // ページングの基盤となるVC
    private let pagingViewController = SelfSizingPagingViewController()
//    private let menuItemSize = CGSize(width: 160, height: 40)
    private let colorArray: [UIColor] = [UIColor.gray, UIColor.green, UIColor.cyan, UIColor.blue]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(type(of: self))")
        Logger.log("viewDidLoad: \(type(of: self))")
        
        // navigationControllerではなく検索バーを置くことってできるのか
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .blue
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().barTintColor = .blue
            UINavigationBar.appearance().isTranslucent = false
        }
        
        pagingViewController.register(CustomPagingCell.self, for: SelfSizingItem.self)
//        pagingViewController.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
//        pagingViewController.menuItemSize = .fixed(width: menuItemSize.width, height: menuItemSize.height)
        pagingViewController.menuItemSpacing = 6
//        pagingViewController.menuBackgroundColor = .lightGray
        pagingViewController.textColor = .orange
        pagingViewController.selectedTextColor = .red
        pagingViewController.borderOptions = .hidden
        pagingViewController.indicatorColor = .gray
        
        // 上部の隠れるタイトル部分の設定
        let searchBar = UISearchBar()
        searchBar.delegate = self
            
        // ここにUISearchBarを追加する
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
        
        pagingViewController.delegate = self
        pagingViewController.dataSource = self
        
        // ページングするVCの下部の設定
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
        NSLayoutConstraint.activate([
            pagingViewController.collectionView.heightAnchor.constraint(equalToConstant: pagingViewController.options.menuItemSize.height),
            pagingViewController.collectionView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            pagingViewController.collectionView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            pagingViewController.collectionView.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
        ])
        // tableViewのセルの対策
        extendedLayoutIncludesOpaqueBars = true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 選択されてるtableView部分
        guard let viewController = pagingViewController.pageViewController.selectedViewController as? ContentsTableViewController else { return }
        // tableViewがスクロールされる時、タイトル部分から下のタブ部分＋tableView部分とサイズを合わせる？
        hideScrollView.contentSize = viewController.tableView.contentSize
        hideScrollView.contentInset = viewController.tableView.contentInset
        hideScrollView.contentOffset = viewController.tableView.contentOffset
        
        viewController.tableView.delegate = self
        
    }
    
}


// MARK: - PagingViewControllerDataSource

extension SelfSizingViewController: PagingViewControllerDataSource {
    
    /// タブの数の設定　初期表示で取得 +1（追加用タブ）
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 4
    }
    
    /// contentsViewにあたる部分の設定
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        // indexに紐づく色を取得
        let color = colorArray[index]
        
        
        let tableViewController = ContentsTableViewController()
        
        let insets = UIEdgeInsets(top: pagingViewController.options.menuItemSize.height,
                                  left: 0, bottom: 0, right: 0)
        tableViewController.tableView.scrollIndicatorInsets = insets
        tableViewController.tableView.contentInset = insets
        return tableViewController
    }
    
    /// たぶの設定
    /// 最後のindexタブだけ＋ボタンつける
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let titleList = ["Car", "Morter", "Plane", "Bus", "Train", "Ships", "Walk", "Cycling"]
        let str = "index"
        let title = appedStr(index, str: str)
        let tabMenu = PagingIndexItem(index: index, title: "Tab index")
        return tabMenu
    }
    
    private func appedStr(_ index: Int, str: String) -> String {
        var title = ""
        for _ in 0 ... index {
            title.append(str)
        }
        return title
        }
}


// MARK: - PagingViewControllerDelegate

extension SelfSizingViewController: PagingViewControllerDelegate {
    
    func pagingViewController(
        _: PagingViewController,
        isScrollingFromItem currentPagingItem: PagingItem,
        toItem upcomingPagingItem: PagingItem?,
        startingViewController: UIViewController,
        destinationViewController: UIViewController?,
        progress: CGFloat) {
        print("pagingViewController: isScrollingFromItem")
        Logger.log("pagingViewController: isScrollingFromItem")

    }

    
    
    /// 横スクロールで次ページへ遷移したときの処理
    func pagingViewController(_: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        print("pagingViewController: willScroll")
        Logger.log("pagingViewController: willScroll")
        // 現在表示されるページ？
        guard let startingViewController = startingViewController as? ContentsTableViewController else { return }
        // 別ページにスクロールされた時、表示されていたtableViewのdelegateを破棄
        startingViewController.tableView.delegate = nil
    }

    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        print("pagingViewController: didScrollToItem")
        print("transitionSuccessful: \(transitionSuccessful)")
        Logger.log("pagingViewController: didScrollToItem")
        Logger.log("transitionSuccessful: \(transitionSuccessful)")
        guard let destinationViewController = destinationViewController as? ContentsTableViewController else { return }
        guard let startingViewController = startingViewController as? ContentsTableViewController else { return }
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
    
    func pagingViewController(
        _ pagingViewController: PagingViewController,
        didSelectItem pagingItem: PagingItem) {
        print("pagingViewController: didSelectItem")
        Logger.log("pagingViewController: didSelectItem")
        
    }

    
    
//    func pagingViewController(_: PagingViewController, isScrollingFromItem currentPagingItem: PagingItem, toItem upcomingPagingItem: PagingItem?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
//      guard let destinationViewController = destinationViewController as? ContentsTableViewController else { return }
//      guard let startingViewController = startingViewController as? ContentsTableViewController else { return }

        
        //      // Tween between the current menu offset and the menu offset of
//      // the destination view controller.
//      let from = calculateMenuHeight(for: startingViewController.collectionView)
//      let to = calculateMenuHeight(for: destinationViewController.collectionView)
//      let height = ((to - from) * abs(progress)) + from
//      updateMenu(height: height)
//    }
    
}


extension SelfSizingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableViewが引っ張られた時にサイズを更新？
        hideScrollView.contentOffset = scrollView.contentOffset
        hideScrollView.panGestureRecognizer.state = scrollView.panGestureRecognizer.state
    }
    
}


// MARK: - PagingViewControllerSizeDelegate

//extension SelfSizingViewController: PagingViewControllerSizeDelegate {
//    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
//        guard let item = pagingItem as? SelfSizingItem else { return 0 }
//        let insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        // これ何のサイズ？
//        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.options.menuItemSize.height)
//        let attributes = [NSAttributedString.Key.font: pagingViewController.options.font]
//
//        let rect = item.title.boundingRect(with: size,
//                                           options: .usesLineFragmentOrigin,
//                                           attributes: attributes,
//                                           context: nil)
//
//        let width = ceil(rect.width) + insets.left + insets.right
//
//        if isSelected {
//          return width * 1.5
//        } else {
//          return width
//        }
//
//
//    }
//
//
//}
