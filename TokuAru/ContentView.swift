//
//  ContentView.swift
//  TokuAru
//
//  Created by 阿部大輔 on 2023/11/08.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // 端末の状態を読み取る
    @Environment(\.managedObjectContext) private var viewContext
    
    // DBから情報を取得（取得パスや順番を指定）
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    // 取得した結果を格納
    private var items: FetchedResults<Item>
    
    // Viewとして定義
    var body: some View {
        
        // 画面遷移の実装･･･①
        NavigationView {
            // 各コンテンツをリスト形式で表示･･･②
            List {
                // データコレクションを渡す
                ForEach(items) { item in
                    // プッシュ遷移を実装
                    NavigationLink {
                        // リンクを踏んだ時、遷移する画面で表示するテキスト
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        // リンクに表示するラベルテキスト
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                // リストを削除する処理を実装･･･③
                .onDelete(perform: deleteItems)
            }// ②
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        } // ①
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // リストを削除する処理･･･③
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
