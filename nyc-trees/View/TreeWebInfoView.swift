//
//  TreeWebInfoView.swift
//  nyc-trees-redux
//
//  Created by Suri Wigder on 10/28/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import SwiftUI
import SafariServices

struct TreeWebInfoView: UIViewControllerRepresentable {

    @Binding var tree: Tree

    func makeUIViewController(context: UIViewControllerRepresentableContext<TreeWebInfoView>) -> SFSafariViewController {
        let url = URL(string: "https://en.wikipedia.org/wiki/\(tree.latinName.wikipediaPage)")!
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<TreeWebInfoView>) {

    }
}


#if DEBUG

struct TreeWebInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TreeWebInfoView(tree: Binding.constant(hardcodedTrees[0]))
    }
}
#endif
