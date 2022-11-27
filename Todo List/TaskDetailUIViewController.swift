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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var todoTask:TodoTask? = nil
    var delegate:DimissedDelegate? = nil
    
    var pageState:PageState = .create
    override func viewDidLoad() {
        datePicker.overrideUserInterfaceStyle = .dark
        updateUI()
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        
        let todo = TodoTask(name:"")
        
        if(todoTask == nil){
           
            todo.note = taskNote.text
            todo.isCompleted = isCompletedSwitch.isOn
            todoTask!.name = titleTextField.text!

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
                todoTask!.name = titleTextField.text!
                todoTask!.hasDueDate = hasDueDateSwitch.isOn

                if(hasDueDateSwitch.isOn){
                    todoTask!.dueDate = datePicker.date
                }
            }
        }
        
        doDismiss()

    }
    func updateUI(){
        
        if(pageState == .update){
            button.setTitle("Update", for: .normal)
            titleLabel.text = "Task Details"
            deleteButton.isHidden = false
        }
        
        if(todoTask != nil){
            taskNote.text = todoTask?.note ?? ""
            titleTextField.text = todoTask?.name ?? ""
            
            hasDueDateSwitch.isOn = todoTask?.hasDueDate ?? false
            isCompletedSwitch.isOn = todoTask?.isCompleted ?? false


        }
        
    }
    
    deinit{
        delegate = nil
    }
    
    private func doDismiss(){
        dismiss(animated: true, completion: { [self] in
            if(self.delegate != nil){
                self.delegate?.onDismissed(nil)
            }
        })
    }
    
    @IBAction func onDeleted(_ sender: Any) {
        todoTask?.delete()
        doDismiss()
    }
    
}
