//
//  TableViewRow.swift
//  SampleSideSwipeMenu
//
//  Created by Eri Fujiwara on 2021/01/27.
//  Copyright © 2021 fjwrer_1004. All rights reserved.
//

import SwiftUI

struct TableViewRow: View {
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 15) {
                Text("Title Label")
                    .font(.callout)
    //            TextField("place holder", text: viewmodel.$binding.name)
                Text("caption............")
                    .font(.caption)
            }
        }
    }
}

struct TableViewRow_Previews: PreviewProvider {
    static var previews: some View {
        TableViewRow()
    }
}
