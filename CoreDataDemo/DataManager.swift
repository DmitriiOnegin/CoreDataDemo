//
//  DataManager.swift
//  CoreDataDemo
//
//  Created by Dmitrii Onegin on 25.01.2022.
//

import UIKit
import CoreData

enum DataError: Error {
    case noData
    case dontSaveData
    case dontRefreshData
    case dontDeleteData
}

class DataManager {
    static var shared = DataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func fetchData(completion: @escaping(Result<[Task], DataError>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
           print("Faild to fetch data", error)
            completion(.failure(.noData))
        }
    }
    
    func save(_ taskName: String, taskList: [Task], completion: @escaping(Result<[Task], DataError>) -> Void) {
        var newTaskList = taskList
        let task = Task(context: context)
        task.name = taskName
        
        do {
            try context.save()
            newTaskList.append(task)
            completion(.success(newTaskList))
        } catch let error {
            print(error)
            completion(.failure(.dontSaveData))
        }
    }
    
    func delete(_ index: Int, taskList: [Task], completion: @escaping(Result<[Task], DataError>) -> Void) {
        var newTaskList = taskList
        let task = taskList[index]
        context.delete(task)
       
        do {
            try context.save()
            newTaskList.remove(at: index)
            completion(.success(newTaskList))
        } catch let error {
            print(error)
            completion(.failure(.dontDeleteData))
        }
    }
    
    func refresh(_ index: Int, taskList: [Task], taskName: String, completion: @escaping(Result<[Task], DataError>) -> Void) {
        let newTaskList = taskList
        let task = taskList[index]
        task.name = taskName
        context.refresh(task, mergeChanges: true)
       
        do {
            try context.save()
            newTaskList[index].name = taskName
            completion(.success(newTaskList))
        } catch let error {
            print(error)
            completion(.failure(.dontRefreshData))
        }
    }
    
    
    
    
    
}
