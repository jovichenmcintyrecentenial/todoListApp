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
class TaskDetailUIViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hasDueDateSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var button: CircleUIButton!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    
    var todoTask:TodoTask? = nil
    var todoTaskCopy:TodoTask? = nil

    var todoTaskOriginal:TodoTask? = nil
    var delegate:DimissedDelegate? = nil
    
    var pageState:PageState = .create
    
    override func viewDidLoad() {
        if(todoTask == nil){
            nameTextField.becomeFirstResponder()
            viewContainer.isHidden = true
        }
        nameTextField.delegate = self
        datePicker.overrideUserInterfaceStyle = .dark
        updateUI()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.text!.count >= 2){
            viewContainer.isHidden = false
        }
        return true
    }
    
    @IBAction func onCancel(_ sender: Any) {
        if(!isUnedited()){
            let alert = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to leave without saving your changes?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)

        }
        else{
            self.dismiss(animated: true)
        }
    }
    
    func isDataValid() -> Bool {
        
        var error:String? = nil
        
        if(nameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            error = "Please enter a name for your task"
        }
        
        if(error != nil){
            let banner = NotificationBanner(title: title, subtitle: error!, style: .danger)
            banner.show()
            return false
        }
        
        return true
    }
    
    
    private func updateDateUI() {
        if(!hasDueDateSwitch.isOn){
            datePicker.isEnabled = false
        }
        else{
            datePicker.isEnabled = true
        }
    }
    
    private func isUnedited()->Bool{
        if let todoTask = self.todoTask {
            if(todoTask.name != nameTextField.text ||
               todoTask.note != taskNote.text ||
               todoTask.hasDueDate != hasDueDateSwitch.isOn ||
               todoTask.dueDate != datePicker.date ||
               todoTask.isCompleted != isCompletedSwitch.isOn
           ){
                return false
            }
        }
        
        return true
    }
    
    @IBAction func onToggleHasDate(_ sender: UISwitch) {
        updateDateUI()
    }
    
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        
    
        let todo = TodoTask(name:"")
        
        if(todoTask == nil && isDataValid()){
           
            todo.note = taskNote.text
            todo.isCompleted = isCompletedSwitch.isOn
            todo.name = nameTextField.text!

            if(hasDueDateSwitch.isOn){
                todo.hasDueDate = hasDueDateSwitch.isOn
                todo.dueDate = datePicker.date
            }
            todo.create()
            doDismiss()
        }
        else{
            
            if(pageState == .update  && isDataValid()){
                let alert = UIAlertController(title: "Update todo task", message: "Are you sure you want to update your todo task detail?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    let realm = try! Realm()
                    try! realm.write {
                        self.todoTask!.note = self.taskNote.text
                        self.todoTask!.isCompleted = self.isCompletedSwitch.isOn
                        self.todoTask!.name = self.nameTextField.text!
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
            nameLabel.text = "Task Details"
            deleteButton.isHidden = false
        }
        
        if(todoTask != nil){
            taskNote.text = todoTask?.note ?? ""
            nameTextField.text = todoTask?.name ?? ""
            if(todoTask?.dueDate != nil){
                datePicker.date = todoTask!.dueDate!
            }
            hasDueDateSwitch.isOn = todoTask?.hasDueDate ?? false
            isCompletedSwitch.isOn = todoTask?.isCompleted ?? false


        }
        updateDateUI()

        
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
