//
//  TodoTableViewCell.swift
//  Todo List
//
//  Created by Jovi on 13/11/2022.
//

import UIKit
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

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func onEditPressed(_ sender: Any) {
        delegate?.editPressed(sender as! UIButton)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}