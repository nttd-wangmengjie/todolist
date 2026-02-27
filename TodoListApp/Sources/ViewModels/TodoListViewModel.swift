import Foundation
import Combine

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var overdueTodos: [TodoItem] = []
    @Published var upcomingTodos: [TodoItem] = []
    @Published var completedTodos: [TodoItem] = []
    @Published var noDueDateTodos: [TodoItem] = []
    
    private let todoStore = TodoStore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        todoStore.$todos
            .sink { [weak self] todos in
                self?.todos = todos
                self?.updateGroupedTodos(todos)
            }
            .store(in: &cancellables)
    }
    
    private func updateGroupedTodos(_ todos: [TodoItem]) {
        let overdue = todos.filter { $0.isOverdue }
        let completed = todos.filter { $0.isCompleted && !$0.isOverdue }
        let upcoming = todos.filter { !$0.isCompleted && !$0.isOverdue && $0.dueDate != nil }
        let noDueDate = todos.filter { $0.dueDate == nil && !$0.isCompleted && !$0.isOverdue }
        
        self.overdueTodos = overdue
        self.completedTodos = completed
        self.upcomingTodos = upcoming
        self.noDueDateTodos = noDueDate
    }
    
    func addTodo(title: String, dueDate: Date? = nil) {
        todoStore.addTodo(title: title, dueDate: dueDate)
    }
    
    func toggleTodo(_ todo: TodoItem) {
        todoStore.toggleTodo(todo)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todoStore.deleteTodo(todo)
    }
    
    func deleteTodos(at offsets: IndexSet, from group: TodoGroup) {
        let todosToDelete: [TodoItem]
        switch group {
        case .overdue:
            todosToDelete = offsets.map { overdueTodos[$0] }
        case .upcoming:
            todosToDelete = offsets.map { upcomingTodos[$0] }
        case .completed:
            todosToDelete = offsets.map { completedTodos[$0] }
        case .noDueDate:
            todosToDelete = offsets.map { noDueDateTodos[$0] }
        }
        
        for todo in todosToDelete {
            todoStore.deleteTodo(todo)
        }
    }
    
    func moveTodos(from source: IndexSet, to destination: Int) {
        todoStore.moveTodos(from: source, to: destination)
    }
}

enum TodoGroup: String, CaseIterable {
    case overdue = "逾期"
    case upcoming = "即将到期"
    case completed = "已完成"
    case noDueDate = "无截止日期"
}
