//
//  TaskDetailUIViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import Foundation
import UIKit

enum PageState {case create, update}
class TaskDetailUIViewController: UIViewController{
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var button: CircleUIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var pageState:PageState = .create
    override func viewDidLoad() {
        datePicker.overrideUserInterfaceStyle = .dark
        updateUI()
    }
    
    func updateUI(){
        
        if(pageState == .update){
            button.setTitle("Update", for: .normal)
            titleLabel.text = "Task Details"
            deleteButton.isHidden = false
        }
        
    }
}
