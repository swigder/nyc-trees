//
//  ContentView.swift
//  nyc-trees-redux
//
//  Created by Suri Wigder on 10/20/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import SwiftUI

struct TreeDetailView: View {
    @Binding var tree: Tree
    
    var body: some View {
        VStack {
            CircleImage(image: tree.image)
                .offset(y: -130)
                .padding(.bottom, -130)

            
            VStack(alignment: .leading) {
                HStack {                    Text(tree.commonName.firstCapitalized)
                        .font(.title)
                    Spacer()
                    Text("\(tree.diameter) inches")
                }
                HStack {
                    Text(tree.latinName.firstCapitalized)
                        .font(.subheadline)
                    Spacer()
                    Text(tree.address)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

#if DEBUG

struct TreeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TreeDetailView(tree: Binding.constant(hardcodedTrees[0]))
    }
}

#endif
