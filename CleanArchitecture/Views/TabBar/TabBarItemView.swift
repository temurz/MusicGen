//
//  TabBarItemView.swift
//  AkfaSmart
//
//  Created by Temur on 01/02/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import SwiftUI

struct TabBarItemView<Router>: View where Router: ViewRouter{
  
    @StateObject var viewRouter: Router
  
  let tabBarItem: TabBarItem
  let defaultColor: Color
  let selectedColor: Color
  let width, height: CGFloat
  
  let font : Font
  
  private var displayColor: Color {
    selected ? selectedColor : defaultColor
  }
  
  private var selected: Bool {
      viewRouter.selectedPageId == tabBarItem.id
  }
    
    var body: some View {
        VStack {
//            Spacer()
            Group {
                Image(systemName: tabBarItem.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(displayColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                Text(tabBarItem.title)
                    .font(font)
                    .foregroundColor(displayColor)
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.route(selectedPageId: tabBarItem.id)
            }
    }
}
