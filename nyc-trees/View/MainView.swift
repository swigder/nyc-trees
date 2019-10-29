//
//  MainView.swift
//  nyc-trees-redux
//
//  Created by Suri Wigder on 10/20/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var treeData = TreeData()
        
    var body: some View {
        VStack {
            MapView(coordinate: $locationManager.currentLocation, treeData: treeData)
                .edgesIgnoringSafeArea(.top)
            
            TreeDetailView(tree: $treeData.selectedTree)
                .frame(height: 200)
        }
    }
}

class TreeData: ObservableObject {
    @Published var selectedTree: Tree = hardcodedTrees[0]
    var trees: [Int: Tree] = [:]
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
