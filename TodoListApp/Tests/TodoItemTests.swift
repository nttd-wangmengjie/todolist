import XCTest
@testable import TodoListApp

final class TodoItemTests: XCTestCase {
    
    func testTodoItemCreation() {
        let todo = TodoItem(title: "测试待办")
        
        XCTAssertEqual(todo.title, "测试待办")
        XCTAssertFalse(todo.isCompleted)
        XCTAssertNil(todo.dueDate)
        XCTAssertNotNil(todo.id)
    }
    
    func testTodoItemWithDueDate() {
        let dueDate = Date()
        let todo = TodoItem(title: "测试待办", dueDate: dueDate)
        
        XCTAssertEqual(todo.title, "测试待办")
        XCTAssertEqual(todo.dueDate, dueDate)
    }
    
    func testTodoItemIsOverdue() {
        let pastDate = Date().addingTimeInterval(-3600) // 1小时前
        let todo = TodoItem(title: "逾期待办", dueDate: pastDate)
        
        XCTAssertTrue(todo.isOverdue)
    }
    
    func testTodoItemNotOverdueWhenCompleted() {
        let pastDate = Date().addingTimeInterval(-3600)
        let todo = TodoItem(title: "已完成待办", isCompleted: true, dueDate: pastDate)
        
        XCTAssertFalse(todo.isOverdue)
    }
    
    func testTodoItemNotOverdueWhenFutureDueDate() {
        let futureDate = Date().addingTimeInterval(3600) // 1小时后
        let todo = TodoItem(title: "未来待办", dueDate: futureDate)
        
        XCTAssertFalse(todo.isOverdue)
    }
    
    func testTodoItemNotOverdueWhenNoDueDate() {
        let todo = TodoItem(title: "无截止日期")
        
        XCTAssertFalse(todo.isOverdue)
    }
    
    func testTodoItemCodable() throws {
        let todo = TodoItem(title: "可编码待办", isCompleted: true, dueDate: Date())
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(todo)
        
        let decoder = JSONDecoder()
        let decodedTodo = try decoder.decode(TodoItem.self, from: data)
        
        XCTAssertEqual(todo.id, decodedTodo.id)
        XCTAssertEqual(todo.title, decodedTodo.title)
        XCTAssertEqual(todo.isCompleted, decodedTodo.isCompleted)
        XCTAssertEqual(todo.dueDate, decodedTodo.dueDate)
    }
    
    func testTodoItemEquality() {
        let id = UUID()
        let todo1 = TodoItem(id: id, title: "测试", isCompleted: false)
        let todo2 = TodoItem(id: id, title: "测试", isCompleted: false)
        
        XCTAssertEqual(todo1, todo2)
    }
}
