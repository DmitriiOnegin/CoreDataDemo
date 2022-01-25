//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by brubru on 24.01.2022.
//

import UIKit


class TaskListViewController: UITableViewController {
   
    
    private let cellID = "task"
    private var taskList: [Task] = []
    private let dataManager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
 
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearence.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func fetchData() {
        dataManager.fetchData { result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showAlert(with title: String, and message: String, indexPath: IndexPath? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            if let indexPath = indexPath {
                self.refresh(indexPath, taskName: task)
                
            } else {
            self.save(task)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        dataManager.save(taskName, taskList: taskList) { result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error)
            }
        }
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
    }
    
    private func delete(_ indexPath: IndexPath) {
        dataManager.delete(indexPath.row, taskList: taskList) { result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error)
            }
        }
       self.tableView.reloadData()
    }
    
    private func refresh(_ indexPath: IndexPath, taskName: String) {
        dataManager.refresh(indexPath.row, taskList: taskList, taskName: taskName) { result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error)
            }
        }
       self.tableView.reloadData()
    }
    
    private func changeTask(indexPath: IndexPath) {
        showAlert(with: "dsada", and: "sdfsd", indexPath: indexPath)
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changeTask(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            delete(indexPath)
        }
    }
    
}
