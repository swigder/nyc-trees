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
    
    @GestureState var isLongPressed = false

    @State var expandedDetail = false
    @State var expandedSize: CGFloat = 0
        
    var body: some View {
        let longPressAndDrag = LongPressGesture()
            .updating($isLongPressed) { value, state, transition in
                state = value
        }.simultaneously(with: DragGesture()
            .onChanged {
                self.expandedDetail = $0.translation.height < -50
            }
            .onEnded { _ in
            }
        )

        return VStack {
            MapView(coordinate: $locationManager.currentLocation, treeData: treeData)
                .edgesIgnoringSafeArea(.top)
            
            TreeDetailView(tree: $treeData.selectedTree)
                .frame(height: 200)
                .gesture(longPressAndDrag)
        }.sheet(isPresented: self.$expandedDetail) {
            TreeWebInfoView(tree: self.$treeData.selectedTree)
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
