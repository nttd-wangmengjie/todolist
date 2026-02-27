import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.todos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checklist")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("暂无待办事项")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("点击右上角 + 添加新的待办")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        // 逾期事项
                        if !viewModel.overdueTodos.isEmpty {
                            Section("逾期") {
                                ForEach(viewModel.overdueTodos) { todo in
                                    TodoRowView(todo: todo) {
                                        viewModel.toggleTodo(todo)
                                    }
                                }
                                .onDelete { offsets in
                                    viewModel.deleteTodos(at: offsets, from: .overdue)
                                }
                            }
                        }
                        
                        // 即将到期
                        if !viewModel.upcomingTodos.isEmpty {
                            Section("即将到期") {
                                ForEach(viewModel.upcomingTodos) { todo in
                                    TodoRowView(todo: todo) {
                                        viewModel.toggleTodo(todo)
                                    }
                                }
                                .onDelete { offsets in
                                    viewModel.deleteTodos(at: offsets, from: .upcoming)
                                }
                            }
                        }
                        
                        // 无截止日期
                        if !viewModel.noDueDateTodos.isEmpty {
                            Section("无截止日期") {
                                ForEach(viewModel.noDueDateTodos) { todo in
                                    TodoRowView(todo: todo) {
                                        viewModel.toggleTodo(todo)
                                    }
                                }
                                .onDelete { offsets in
                                    viewModel.deleteTodos(at: offsets, from: .noDueDate)
                                }
                            }
                        }
                        
                        // 已完成
                        if !viewModel.completedTodos.isEmpty {
                            Section("已完成") {
                                ForEach(viewModel.completedTodos) { todo in
                                    TodoRowView(todo: todo) {
                                        viewModel.toggleTodo(todo)
                                    }
                                }
                                .onDelete { offsets in
                                    viewModel.deleteTodos(at: offsets, from: .completed)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("待办事项")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTodo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView { title, dueDate in
                    viewModel.addTodo(title: title, dueDate: dueDate)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
