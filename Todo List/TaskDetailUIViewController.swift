//
//  TaskDetailUIViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import Foundation
import UIKit
import RealmSwift

enum PageState {case create, update}
class TaskDetailUIViewController: UIViewController{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hasDueDateSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var button: CircleUIButton!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var todoTask:TodoTask? = nil
    
    var pageState:PageState = .create
    override func viewDidLoad() {
        datePicker.overrideUserInterfaceStyle = .dark
        updateUI()
    }
    
    @IBAction func onButtonPressed(_ sender: Any) {
        
        var todo = TodoTask(name:"")
        
        if(todoTask == nil){
            todo = todoTask!
           
            todo.note = taskNote.text
            todo.isCompleted = isCompletedSwitch.isOn
            
            if(hasDueDateSwitch.isOn){
                todo.hasDueDate = hasDueDateSwitch.isOn
                todo.dueDate = datePicker.date
            }
            todo.create()
        }
        else{
            
            let realm = try! Realm()
            try! realm.write {
                todoTask!.note = taskNote.text
                todoTask!.isCompleted = isCompletedSwitch.isOn
                
                todoTask!.hasDueDate = hasDueDateSwitch.isOn

                if(hasDueDateSwitch.isOn){
                    todoTask!.dueDate = datePicker.date
                }
            }
        }
        
        dismiss(animated: true, completion: nil)

    }
    func updateUI(){
        
        if(pageState == .update){
            button.setTitle("Update", for: .normal)
            titleLabel.text = "Task Details"
            deleteButton.isHidden = false
        }
        
        if(todoTask != nil){
            titleLabel.text = todoTask?.name ?? ""
            taskNote.text = todoTask?.note ?? ""
            
            hasDueDateSwitch.isOn = todoTask?.hasDueDate ?? false
            isCompletedSwitch.isOn = todoTask?.isCompleted ?? false


        }
        
    }
}
