import Foundation

let header = """
\t==========================================
\t                TO-DO LIST
\t==========================================
"""

let optionMessage = """
            \t[1] ADD TASK(S)
            \t[2] LIST TASKS
            \t[3] LIST TASKS BY CATEGORY
            \t[4] COMPLETE TASK
            \t[5] DELETE TASK
            \t[6] EXIT
        \tSelect Choice (1~6) :
"""

enum TaskStatus: String {
    case pending = "Pending"
    case complete = "Complete"
}

func clear(){ print("\u{001B}[2J\u{001B}[;H") }

var taskCategories: [String: [(name: String, status: TaskStatus)]] = [:]

// add
let addTask: ([String], String) -> Void = { names, category in
    guard !names.isEmpty else {
        print("\tNo task name provided.")
        return
    }

    for name in names {
        print("\tAre you sure you want to add '\(name)' to the todo list? (y/n) : ", terminator: "")
        if let confirmation = readLine(), confirmation.lowercased() == "y" {

            let newTask = (name, TaskStatus.pending)
            if var tasksInCategory = taskCategories[category] {
                tasksInCategory.append(newTask)
                taskCategories[category] = tasksInCategory
            } else {
                taskCategories[category] = [newTask]
            }
        } else {
            print("\tTask addition canceled.")
        }
        print("\tTask '\(name)' added to the '\(category)' category.")
    }
}

// list
let listCategories: () -> Void = {
    if taskCategories.isEmpty {
        print("\tNo categories in the todo list.")
    } else {
        print("\tCategories:")
        for category in taskCategories.keys {
            print("\t\t- \(category)")
        }
    }
}

let listTasks: () -> Void = {
    if taskCategories.isEmpty {
        print("\tNo tasks in the todo list.")
    } else {
        // print("Todo List:")
        for (category, tasks) in taskCategories {
            print("\t\(category):")
            for (index, task) in tasks.enumerated() {
                let status = task.status == .complete ? "[✓]" : "[ ]"
                print("\t  \(index + 1). \(status)  \(task.name)")
            }
        }
    }
}

func listTasksByCategory (category : String) {
    clear(); print(header)
     if let tasksInCategory = taskCategories[category] {
        if tasksInCategory.isEmpty {
            print("\tNo tasks in the '\(category)' category.")
        } else {
            print("\tTasks in the '\(category)' category:")
            for (index, task) in tasksInCategory.enumerated() {
                let status = task.status == .complete ? "[✓]" : "[ ]"
                print("\t  \(index + 1). \(status)  \(task.name)")
            }
        }
    } else {
        print("\tCategory '\(category)' does not exist.")
    }
}

// remove
let removeTask: (Int, String) -> Void = { taskIndex, category in
    guard let tasksInCategory = taskCategories[category], taskIndex > 0, taskIndex <= tasksInCategory.count else {
        print("\tInvalid task number or category.")
        return
    }

    let removedTask = taskCategories[category]!.remove(at: taskIndex - 1)
    print("\tTask '\(removedTask.name)' removed from the '\(category)' category.")
}

// mask as complete
let completeTask: (Int, String) -> Void = { taskIndex, category in
    guard let tasksInCategory = taskCategories[category], taskIndex > 0, taskIndex <= tasksInCategory.count else {
        print("\tInvalid task number or category.")
        return
    }

    let selectedTask = taskCategories[category]![taskIndex - 1]
    if selectedTask.status == .pending {
        taskCategories[category]![taskIndex - 1].status = .complete
        print("\tTask '\(selectedTask.name)' marked as complete in the '\(category)' category.")
    } else {
        print("\tTask '\(selectedTask.name)' is already complete in the '\(category)' category.")
    }
}

func backToMenu()->Void{
    print("\t==========================================")
    while true {
        print("\tType 'return' to go back to the main menu : ", terminator: "")
        if let userInput = readLine(), userInput.lowercased() == "return" {
            clear()
            return
        } else {
            print("\tInvalid input. Please type 'return' to go back to the main menu.")
        }
    }
}

// Main
// clear()
while true {
    print(header)
     print(optionMessage, terminator: " ")

    if let choice = readLine(), let option = Int(choice) {
        switch option {
        case 1:
            clear()
            print(header)
            print("\t\tADD TASK(S)")
            print("\tEnter task category : ", terminator: "")
            if let taskCategory = readLine() {
                print("\tEnter task name(s), separated by commas : ", terminator: "")
                if let taskNames = readLine() {
                    let names = taskNames.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    addTask(names, taskCategory)
                }
            } else {
                print("\tInvalid input. Please enter a task category.")
            }
            backToMenu()
        case 2:
            clear()
            print(header)
            listTasks()
            backToMenu()
        case 3:
            clear(); print(header)
            listCategories()
            print("\tEnter the category you want to list tasks for : ", terminator: "")
            if let category = readLine() {
                listTasksByCategory(category: category)
            } else {
                print("\tInvalid input. Please enter a category.")
            }
            backToMenu()
        case 4:
            clear(); print(header)
            listTasks()
            print("\tEnter the category of the task : ", terminator: "")
            if let taskCategory = readLine() {
                print("\tEnter the number of the task you want to mark as complete : ", terminator: "")
                if let input = readLine(), let taskIndex = Int(input) {
                    completeTask(taskIndex, taskCategory)
                } else {
                    print("\tInvalid input. Please enter a task category.")
                }
            } else {
                print("\tInvalid input. Please enter a valid task number.")
            }
            backToMenu()
        case 5:
            clear(); print(header)
            listTasks()
            print("\tEnter the category of the task : ", terminator: "")
            if let taskCategory = readLine() {
                print("\tEnter the number of the task you want to remove : ", terminator: "")
                if let input = readLine(), let taskIndex = Int(input) {
                    removeTask(taskIndex, taskCategory)
                } else {
                    print("\tInvalid input. Please enter a task category.")
                }
            } else {
                print("\tInvalid input. Please enter a valid task number.")
            }
            backToMenu()
        case 6:
            exit(0)
        default:
            print("\tInvalid choice. Please enter a number between 1 and 6.")
        }
    } else {
        print("\tInvalid input. Please enter a number.")
    }
}
