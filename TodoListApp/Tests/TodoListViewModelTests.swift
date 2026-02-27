import XCTest
import Combine
@testable import TodoListApp

final class TodoListViewModelTests: XCTestCase {
    
    private var viewModel: TodoListViewModel!
    private let testKey = "savedTodos"
    
    override func setUp() {
        super.setUp()
        // 清除UserDefaults中的测试数据
        UserDefaults.standard.removeObject(forKey: testKey)
        viewModel = TodoListViewModel()
    }
    
    override func tearDown() {
        // 测试后清除数据
        UserDefaults.standard.removeObject(forKey: testKey)
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.todos.isEmpty)
        XCTAssertTrue(viewModel.overdueTodos.isEmpty)
        XCTAssertTrue(viewModel.upcomingTodos.isEmpty)
        XCTAssertTrue(viewModel.completedTodos.isEmpty)
        XCTAssertTrue(viewModel.noDueDateTodos.isEmpty)
    }
    
    func testAddTodo() {
        viewModel.addTodo(title: "新待办")
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.noDueDateTodos.count, 1)
    }
    
    func testAddTodoWithDueDate() {
        let futureDate = Date().addingTimeInterval(3600)
        viewModel.addTodo(title: "带截止日期的待办", dueDate: futureDate)
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.upcomingTodos.count, 1)
    }
    
    func testAddTodoWithPastDueDate() {
        let pastDate = Date().addingTimeInterval(-3600)
        viewModel.addTodo(title: "逾期待办", dueDate: pastDate)
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.overdueTodos.count, 1)
    }
    
    func testToggleTodo() {
        viewModel.addTodo(title: "待办")
        let todo = viewModel.todos.first!
        
        XCTAssertFalse(todo.isCompleted)
        XCTAssertEqual(viewModel.noDueDateTodos.count, 1)
        
        viewModel.toggleTodo(todo)
        
        XCTAssertEqual(viewModel.completedTodos.count, 1)
        XCTAssertTrue(viewModel.noDueDateTodos.isEmpty)
    }
    
    func testDeleteTodo() {
        viewModel.addTodo(title: "待办1")
        viewModel.addTodo(title: "待办2")
        let todoToDelete = viewModel.todos.first!
        
        viewModel.deleteTodo(todoToDelete)
        
        XCTAssertEqual(viewModel.todos.count, 1)
    }
    
    func testDeleteTodosFromOverdueGroup() {
        let pastDate = Date().addingTimeInterval(-3600)
        viewModel.addTodo(title: "逾期待办", dueDate: pastDate)
        viewModel.addTodo(title: "逾期待办2", dueDate: pastDate)
        
        XCTAssertEqual(viewModel.overdueTodos.count, 2)
        
        viewModel.deleteTodos(at: IndexSet(integer: 0), from: .overdue)
        
        XCTAssertEqual(viewModel.overdueTodos.count, 1)
    }
    
    func testGroupingLogic() {
        let pastDate = Date().addingTimeInterval(-3600)
        let futureDate = Date().addingTimeInterval(3600)
        
        viewModel.addTodo(title: "逾期待办", dueDate: pastDate)
        viewModel.addTodo(title: "即将到期", dueDate: futureDate)
        viewModel.addTodo(title: "无截止日期")
        
        let todo = viewModel.todos.first(where: { $0.title == "即将到期" })!
        viewModel.toggleTodo(todo)
        
        XCTAssertEqual(viewModel.overdueTodos.count, 1)
        XCTAssertEqual(viewModel.upcomingTodos.count, 0)
        XCTAssertEqual(viewModel.completedTodos.count, 1)
        XCTAssertEqual(viewModel.noDueDateTodos.count, 1)
    }
}
