//
//  TaskDetailUIViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import Foundation
import UIKit
import RealmSwift
import NotificationBannerSwift

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
    
    //show alert before delete
    //show alert before update
    //validate fields
    //display current day and date in header
    //create action to complete or uncomplete task
    //display overdue icon if task over due
    //display date on each cell
    //display date in date picker
    //add cancel button when updating
    //add switches to cell
    
    func isDataValid() -> Bool {
        
        var error:String? = nil
        
        if(titleTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            error = "Please enter a name for your task"
        }
        
        if(error != nil){
            let banner = NotificationBanner(title: title, subtitle: error!, style: .danger)
            banner.show()
            return false
        }
        
        return true
    }
    
    @IBAction func onButtonPressed(_ sender: Any) {
        
    
        let todo = TodoTask(name:"")
        
        if(todoTask == nil && isDataValid()){
           
            todo.note = taskNote.text
            todo.isCompleted = isCompletedSwitch.isOn
            todo.name = titleTextField.text!

            if(hasDueDateSwitch.isOn){
                todo.hasDueDate = hasDueDateSwitch.isOn
                todo.dueDate = datePicker.date
            }
            todo.create()
            doDismiss()
        }
        else{
            
            if(pageState == .update  && isDataValid()){
                let alert = UIAlertController(title: "Update todo task", message: "Are you sure you want to update his todo?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    let realm = try! Realm()
                    try! realm.write {
                        self.todoTask!.note = self.taskNote.text
                        self.todoTask!.isCompleted = self.isCompletedSwitch.isOn
                        self.todoTask!.name = self.titleTextField.text!
                        self.todoTask!.hasDueDate = self.hasDueDateSwitch.isOn

                        if(self.hasDueDateSwitch.isOn){
                            self.todoTask!.dueDate = self.datePicker.date
                        }
                    }
                    self.doDismiss()
                    self.doDismiss()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
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
            if(todoTask?.dueDate != nil){
                datePicker.date = todoTask!.dueDate!
            }
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
        let alert = UIAlertController(title: "Delete task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.todoTask?.delete()
            self.doDismiss()
            self.doDismiss()
          
        }))

        self.present(alert, animated: true, completion: nil)



    }
    
}
