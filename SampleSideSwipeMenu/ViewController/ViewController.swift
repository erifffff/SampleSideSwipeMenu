//
//  ViewController.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer_1004 on 2020/09/28.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import UIKit
import Parchment

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        slideMenuScrollView.delegate = self
//        slideContentScrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 保存された背景色を適応
        self.view.backgroundColor = AppUserDefault.backgroundColor
    }
    @IBAction func buttonTapped(_ sender: Any) {
        
//        let vc = SelfSizingViewController(nibName: nil, bundle: nil)
        let vc = SampleViewController(nibName: nil, bundle: nil)
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismiss))
        //
        navigationController.navigationItem.rightBarButtonItem = backButton
        
        self.present(navigationController, animated: true)
        
    }
    
    @IBAction func changeColorButtonTapped(_ sender: Any) {
        if #available(iOS 14.0, *) {
            showColorPicker()
        }else{
            // iOS14以下のカラーパレット
        }
    }
    
    @available(iOS 14.0, *)
    private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    
        /* Parchmentのメモ
     
        presentedViewController:UIViewController(表示されているVC)
            ∟PagingViewController(タブ/contentView合わさった大元の部品)
                ∟PagingView（タブとcontentView合わさった１ページ）
                    ∟PagingCell/PagingItem:collectionView:UICollectionView (メニュータブにあたるもの。これをPagingViewControllerに対して登録)
                        ∟contentVC:pageView:UIViewController(コンテンツVC部分)
         
         /// 遷移時に遷移先のページャーできるVCを表示する場合、基本は以下。
         let firstVC = UIViewController()
         let secondVC = UIViewController()
         let pagerViewController = PagingViewController(viewControllers: [firstVC, secondVC])

         /// ページャーされるcontentVC部分のdatasource設定は以下(tableViewのdatasorceみたいなもの)
         /// init時に表示のため内容を設定させる部分。
         extension ViewController: PagingViewContrllerDataSource {
            // ページャーされるcontentVCの数
            func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
                 return 10
             }
            // ページャーされるcontentVCの設定(cellForRowAtみたいなもの？)
            // ここでカスタムtableViewControllerにtodoデータとインデックスを渡すイメージ
             func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
                 return ChildViewController(index: index)
             }
            // ページャーのタブ部分の設定(タブ部分のcellForRowAt的な？)
             func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
                 return PagingTitleItem(title: "View \(index)", index: index)
             }
        }
         /// このdatasourceDelegateを実装し、ページャーされるVCの選択をする。
         pagingViewController.datasource = self
         pagingViewController.select(index: 0, animated: true) // animatedなしもある
           // ちょっとよくわからん 多分すでに用意されたタブアイテムからそのページを選択する的な・・？
                if let first = pagingViewController.items.first {
                    pagingViewController.select(pagingItem: first)
                }
         
         /// pagingViewControllerのcontentVC部分のリロード
         pagingViewController.reloadData()
         /// pagingViewControllerのタブ部分のリロード
         pagingViewController.reloadMenu()
         
         /// pagingViewControllerを操作するときのdelegate: PagingViewControllerDelegate
         // めくってる最中
         func pagingViewController(
             _: PagingViewController,
             isScrollingFromItem currentPagingItem: PagingItem,
             toItem upcomingPagingItem: PagingItem?,
             startingViewController: UIViewController,
             destinationViewController: UIViewController?,
             progress: CGFloat)
         // めくり始めたとき
         func pagingViewController(
             _: PagingViewController,
             willScrollToItem pagingItem: PagingItem,
             startingViewController: UIViewController,
             destinationViewController: UIViewController)
         // めくり終わったとき
         func pagingViewController(
             _ pagingViewController: PagingViewController,
             didScrollToItem pagingItem: PagingItem,
             startingViewController: UIViewController?,
             destinationViewController: UIViewController,
             transitionSuccessful: Bool)
        // タブ選択したとき
         func pagingViewController(
             _ pagingViewController: PagingViewController,
             didSelectItem pagingItem: PagingItem)
 
        /// タブ部分のサイズ設定をするdelegate: PagingViewControllerSizeDelegate
         func pagingViewController(
             _: PagingViewController,
             widthForPagingItem pagingItem: PagingItem,
             isSelected: Bool) -> CGFloat
     
        /// タブ部分のカスタム
        /// タブ部分をカスタムをするには、PagingCellのサブクラスを作成し、PagingItemとして登録する
        pagingViewController.register(CalenderPagingCell.self, for: CalenderPagingItem.self)
        // タブのサイズ設定　selfSizingなどある
        pagingViewController.menuItemSize = .fixed(width40, height:40)
        ただし、sizeDelegateを実装している場合、widthは無視される？
 
    */

    @objc private func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


@available(iOS 14.0, *)
extension ViewController: UIColorPickerViewControllerDelegate {
    
    // 選択した色にpicker閉じた際設定
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            let selectedColor = viewController.selectedColor
            self.view.backgroundColor = selectedColor
            AppUserDefault.backgroundColor = selectedColor
        }
        
        //  Called on every color selection done in the picker.
    // pickerで色を選択した時に設定
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            let selectedColor = viewController.selectedColor
            self.view.backgroundColor = viewController.selectedColor
            AppUserDefault.backgroundColor = selectedColor
            
        }
}
