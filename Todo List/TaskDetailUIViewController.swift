//
//  TaskDetailUIViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import Foundation
import UIKit


class TaskDetailUIViewController: UIViewController{
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        datePicker.overrideUserInterfaceStyle = .dark
    }
}
