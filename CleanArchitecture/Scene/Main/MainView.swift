//
//  MainView.swift
//  AkfaSmart
//
//  Created by Temur on 30/01/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewRouter: MainViewRouter
    
   
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
               viewRouter.body
                    .frame(maxHeight: .infinity)
                 TabBarView(viewRouter: viewRouter, prominentItemImageName: "") {
                     
                 }
                 .frame(width: geometry.size.width, height: geometry.size.height/10)
//                 .background(Color("tabBarColor").shadow(radius: 2))
                 
            }
        }
        .onAppear(perform: {
//            if self.viewRouter.selectedPageId == MainPage.profile.rawValue {
//                self.viewRouter.route(selectedPageId: self.viewRouter.selectedPageId)
//            }
        })
//        .navigationBarHidden(true)
//            .statusBar(hidden: true)
            .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
         
    }
   
}
#Preview {
    MainView(viewRouter: .init(assembler: PreviewAssembler(), navigationController: UINavigationController()))
}
