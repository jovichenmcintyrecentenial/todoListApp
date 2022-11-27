//
//  Todo.swift
//  Todo List
//
//  Created by Jovi on 24/11/2022.
//

import Foundation
import RealmSwift

class TodoTask: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var isCompleted: Bool
   @Persisted var hasDueDate: Bool
   @Persisted var dueDate: Date?
   @Persisted var note: String
   convenience init(name: String) {
       self.init()
       self.name = name
   }
    
   //function use to save this or self obj to realm database
   func create(){
       let realm = try! Realm()
       try! realm.write {
           realm.add(self)
       }
    }
    
    //function update obj in realm database
    func update(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: .modified)
        }
    }
    
    //function use to delete obj from realm database
    func delete(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    //static function use to access data for list for todoTasks from realm database
    static func getAllTodos()->Results<TodoTask>{
        let realm = try! Realm()
        return realm.objects(TodoTask.self)
    }
}
