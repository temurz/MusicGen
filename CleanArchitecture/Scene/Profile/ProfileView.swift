//
//  ProfileView.swift
//  CleanArchitecture
//
//  Created by Temur on 11/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseAuth
struct ProfileRowModel {
    let id: Int
    let name: String
}
struct ProfileView: View {
    
    private let selectRowTrigger = PassthroughSubject<Int,Never>()
    private let cancelBag = CancelBag()
    @ObservedObject var output: ProfileViewModel.Output
    var items = [
        ProfileRowModel(id: 0, name: "Login"),
        ProfileRowModel(id: 1, name: "Terms of use"),
        ProfileRowModel(id: 2, name: "Privacy policy"),
        ProfileRowModel(id: 3, name: "Share"),
        ProfileRowModel(id: 4, name: "Logout")
    ]
    var body: some View {
        VStack {
            if let user = Auth.auth().currentUser {
                HStack {
                    if let url = UserDefaults.standard.value(forKey: "imageURL") as? String {
                        AsyncImage(url: URL(string: url)!) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 48, height: 48)
                        .cornerRadius(24)
                    }else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .cornerRadius(24)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text(user.displayName ?? "")
                        Text(user.email ?? "")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .padding()
                }
                .padding(.horizontal)
                List {
                    ForEach(items, id: \.id) { item in
                        if item.id != 0 {
                            HStack {
                                if item.id == 4 {
                                    Text(item.name)
                                    .foregroundStyle(Color.red)
                                }else {
                                    Text(item.name)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .padding()
                            }
                            .onTapGesture {
                                selectRowTrigger.send(item.id)
                            }
                        }
                    }
                    
                    .background(.clear)
                }
                .listStyle(.plain)
                .background(.clear)
            }else {
                List {
                    ForEach(items, id: \.id) { item in
                        if item.id != 4 {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .padding()
                            }
                            .onTapGesture {
                                selectRowTrigger.send(item.id)
                            }
                        }
                        
                        
                    }
                    .listRowBackground(Color.clear)
                    .background(.clear)
                }
                .listStyle(.plain)
            }
            Spacer()
            Text(output.change)
                .foregroundStyle(.clear)
                .background(.clear)
            Text("MusicGen 1.0.1")
                .padding()
        }
        .navigationTitle("Profile")
    }
    
    init(viewModel: ProfileViewModel) {
        let input = ProfileViewModel.Input(selectRowTrigger: selectRowTrigger.asDriver())
        self.output = viewModel.transform(input, cancelBag: cancelBag)
    }
}
