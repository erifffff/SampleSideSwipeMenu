//
//  TableViewList.swift
//  SampleSideSwipeMenu
//
//  Created by Eri Fujiwara on 2021/01/27.
//  Copyright © 2021 fjwrer_1004. All rights reserved.
//

import SwiftUI

struct TableViewList: View {
//    @EnvironmentObject var list: []
    var body: some View {
        NavigationView {
            // メモある分だけ展開
            // ない場合は１行目placeholder
            // 直接入力可能にする
            List {
                TableViewRow()
                TableViewRow()
                // TableViewRowに展開する
//                ForEach(param) { content in
//
//                }
            }
        }
    }
}

struct TableViewList_Previews: PreviewProvider {
    static var previews: some View {
        TableViewList()
    }
}
