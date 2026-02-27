import XCTest
@testable import TodoListApp

final class TodoStoreTests: XCTestCase {
    
    private var store: TodoStore!
    private let testKey = "savedTodos"
    
    override func setUp() {
        super.setUp()
        // 清除UserDefaults中的测试数据
        UserDefaults.standard.removeObject(forKey: testKey)
        store = TodoStore()
    }
    
    override func tearDown() {
        // 测试后清除数据
        UserDefaults.standard.removeObject(forKey: testKey)
        super.tearDown()
    }
    
    func testAddTodo() {
        store.addTodo(title: "新待办")
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.title, "新待办")
        XCTAssertFalse(store.todos.first?.isCompleted ?? true)
    }
    
    func testAddTodoWithDueDate() {
        let dueDate = Date()
        store.addTodo(title: "带截止日期的待办", dueDate: dueDate)
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.title, "带截止日期的待办")
        XCTAssertEqual(store.todos.first?.dueDate, dueDate)
    }
    
    func testAddMultipleTodos() {
        store.addTodo(title: "待办1")
        store.addTodo(title: "待办2")
        store.addTodo(title: "待办3")
        
        XCTAssertEqual(store.todos.count, 3)
        // 新添加的待办应该在最前面
        XCTAssertEqual(store.todos.first?.title, "待办3")
    }
    
    func testToggleTodo() {
        store.addTodo(title: "待办")
        let todo = store.todos.first!
        
        XCTAssertFalse(todo.isCompleted)
        
        store.toggleTodo(todo)
        XCTAssertTrue(store.todos.first?.isCompleted ?? false)
        
        store.toggleTodo(store.todos.first!)
        XCTAssertFalse(store.todos.first?.isCompleted ?? true)
    }
    
    func testDeleteTodo() {
        store.addTodo(title: "待办1")
        store.addTodo(title: "待办2")
        let todoToDelete = store.todos.first!
        
        store.deleteTodo(todoToDelete)
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.title, "待办1")
    }
    
    func testDeleteTodos() {
        store.addTodo(title: "待办1")
        store.addTodo(title: "待办2")
        store.addTodo(title: "待办3")
        
        store.deleteTodos(at: IndexSet(integer: 0))
        
        XCTAssertEqual(store.todos.count, 2)
    }
    
    func testMoveTodos() {
        store.addTodo(title: "待办1")
        store.addTodo(title: "待办2")
        store.addTodo(title: "待办3")
        
        // 将第一个移动到最后
        store.moveTodos(from: IndexSet(integer: 0), to: 3)
        
        XCTAssertEqual(store.todos.first?.title, "待办2")
    }
    
    func testPersistence() {
        store.addTodo(title: "持久化待办")
        
        // 创建新的store实例来验证数据是否持久化
        let newStore = TodoStore()
        
        XCTAssertEqual(newStore.todos.count, 1)
        XCTAssertEqual(newStore.todos.first?.title, "持久化待办")
    }
    
    func testEmptyStore() {
        XCTAssertTrue(store.todos.isEmpty)
    }
}
