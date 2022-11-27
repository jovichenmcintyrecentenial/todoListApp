//
//  ViewController.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import UIKit
import NotificationBannerSwift
import RealmSwift

public protocol DimissedDelegate:NSObjectProtocol {
    func onDismissed(_ sender:Any?)
}
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,TodoItemCellDelegate, DimissedDelegate {


    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    var listOfTask = TodoTask.getAllTodos()
    var selectedIndex = -1
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTask.count
    }
    
    func onDismissed(_ sender: Any?) {
        listOfTask = TodoTask.getAllTodos()
        tableView.reloadData()
    }
    
    func updateHeader(){
        
        let currentDate = Date.now
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MMM dd, YYYY"
        currentDateLabel.text = dateformat.string(from: currentDate)
        dateformat.dateFormat = "EEEE"
        currentDayLabel.text = dateformat.string(from: currentDate)

        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: currentDate)
        
        if (hours < 12) {
            greetingsLabel.text = "Good Morning"
        } else if (hours < 18) {
            greetingsLabel.text = "Good Afternoon"
        } else {
            greetingsLabel.text  = "Good Evening"
        }

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todoTask = listOfTask[indexPath.row]
        //get cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.editButton.tag = indexPath.row
        cell.switchView.tag = indexPath.row

        cell.todoTItle.attributedText = NSMutableAttributedString(string: todoTask.name)
        cell.switchView.isOn = todoTask.isCompleted
        cell.overdueView.isHidden = true
        cell.dateLabel.isHidden = true
        cell.centerMargin.constant = 0
        cell.editImage.image = cell.editImage.image!.withRenderingMode(.alwaysTemplate)
        cell.editImage.tintColor = UIColor(red: 238.0/255, green: 130/255, blue: 91.0/255,alpha: 1.0)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(attributedString: cell.todoTItle.attributedText!)
        if(todoTask.isCompleted){
           
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray.withAlphaComponent(0.8), range: NSRange(location: 0, length: attributeString.length))
            cell.editImage.image = cell.editImage.image!.withRenderingMode(.alwaysTemplate)
            cell.editImage.tintColor = UIColor.gray
        }
        else{

            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
        }
        
        cell.todoTItle.attributedText = attributeString

        
        if(todoTask.dueDate != nil ){
            
            if(todoTask.dueDate! < Date.now && !todoTask.isCompleted){
                cell.overdueView.isHidden = false
                cell.centerMargin.constant = -8



            }
            else if(todoTask.hasDueDate){
                cell.dateLabel.isHidden = false

                let dateformat = DateFormatter()
                dateformat.dateFormat = "MMMM dd, YYYY"
                cell.dateLabel.text = dateformat.string(from: todoTask.dueDate!)
                cell.centerMargin.constant = -8
                


            }
        }
        

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
    
    func onSwitchChanged(_ uiswitch: UISwitch) {
        
        selectedIndex = uiswitch.tag
        let realm = try! Realm()
        try! realm.write {
            listOfTask[selectedIndex].isCompleted = uiswitch.isOn
        }
        listOfTask = TodoTask.getAllTodos()
        tableView.reloadData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let taskDetailsViewController = segue.destination as! TaskDetailUIViewController
        taskDetailsViewController.delegate = self
        
        if(sender is PageState){
            taskDetailsViewController.todoTask = listOfTask[selectedIndex]
            taskDetailsViewController.pageState = sender as! PageState
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateHeader()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

