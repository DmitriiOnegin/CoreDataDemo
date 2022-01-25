//
//  DataManager.swift
//  CoreDataDemo
//
//  Created by Dmitrii Onegin on 25.01.2022.
//

import UIKit
import CoreData

enum NetworkError: Error {
    case invalidURL
    case noData
    case dontSaveData
}

class DataManager {
    static var shared = DataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var taskList: [Task] = []
    
    private init() {}
    
    func fetchData(completion: @escaping(Result<[Task], NetworkError>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
           print("Faild to fetch data", error)
            completion(.failure(.noData))
        }
    }
    
    func save(_ taskName: String, taskList: [Task], completion: @escaping(Result<[Task], NetworkError>) -> Void) {
        var newTaskList = taskList
        let task = Task(context: context)
        task.name = taskName
        newTaskList.append(task)
        
        do {
            try context.save()
            completion(.success(newTaskList))
        } catch let error {
            print(error)
            completion(.failure(.dontSaveData))
        }
    }
    
    
    
    
    
}
