//
//  ViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import UIKit

public protocol DimissedDelegate:NSObjectProtocol {
    func onDismissed(_ sender:Any?)
}
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,TodoItemCellDelegate, DimissedDelegate {
    
    var listOfTask = TodoTask.getAllTodos()
    var selectedIndex = -1
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTask.count
    }
    
    func onDismissed(_ sender: Any?) {
        listOfTask = TodoTask.getAllTodos()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todoTask = listOfTask[indexPath.row]
        //get cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.editButton.tag = indexPath.row
        cell.todoTItle.text = todoTask.name
        

        return cell
    }
    
    // row height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func editPressed(_ uibutton: UIButton) {
        selectedIndex = uibutton.tag
        performSegue(withIdentifier: "editTodo", sender: PageState.update)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(sender is PageState){
            let taskDetailsViewController = segue.destination as! TaskDetailUIViewController
            taskDetailsViewController.todoTask = listOfTask[selectedIndex]
            taskDetailsViewController.pageState = sender as! PageState
            taskDetailsViewController.delegate = self
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

