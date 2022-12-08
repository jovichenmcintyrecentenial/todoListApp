//
//  TodoTableViewCell.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import UIKit

//delegate use to tie in to main controller to have a centerial function for edit button pressed and when switch is toggled
public protocol TodoItemCellDelegate:NSObjectProtocol {
    func editPressed(_ uibutton:UIButton)

}
class TodoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var todoTItle: UILabel!
    weak var delegate: TodoItemCellDelegate?

    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var centerMargin: NSLayoutConstraint!
    @IBOutlet weak var overdueView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func onEditPressed(_ sender: Any) {
        //trigger delegate function
        delegate?.editPressed(sender as! UIButton)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
