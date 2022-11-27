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
   @Persisted var dueDate: Date
   @Persisted var note: String
   convenience init(name: String) {
       self.init()
       self.name = name
   }
    
    
   func create(){
       let realm = try! Realm()
       try! realm.write {
           realm.add(self)
       }
    }
    
    func update(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: .modified)
        }
    }
    
    func delete(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    static func getAllTodos()->Results<TodoTask>{
        let realm = try! Realm()
        return realm.objects(TodoTask.self)
    }
}
