//
//  SettingsView.swift
//  CleanArchitecture
//
//  Created by Temur on 10/06/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import SwiftUI
import CoreData
struct HistoryView: View {
    @State private var items = [Row]()
    var body: some View {
        VStack {
            List(items, id: \.id) {row in
                Text(row.prompt ?? "")
            }
            
        }
        .navigationTitle("History")
        .onAppear {
            fetchDataFromLocal()
        }
    }
    
    private func fetchDataFromLocal() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let items = try context.fetch(Row.fetchRequest()) as? [Row]
            self.items = items ?? []
        } catch {
            print("error-Fetching data")
        }
    }
}

#Preview {
    HistoryView()
}
