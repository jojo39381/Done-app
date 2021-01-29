//
//  ToDoCell.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/23/20.
//

import UIKit



protocol ToDoEditDelegate {
    func toDoDelete(cell:ToDoCell)
    func toDoStart(cell:ToDoCell)
}
extension ToDoEditDelegate {
    func toDoDelete(cell:ToDoCell) {
        
    }
    func toDoStart(cell:ToDoCell) {
        
    }
}
class ToDoCell: UICollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Do Homework"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    var timeDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    var dateDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    var checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.Flat.red.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.Flat.red
        button.setTitle("Start", for: .normal)
        
        button.layer.cornerRadius = 10
        return button
    }()
    var calendarIcon: UIImageView = {
        let image = UIImage(named:"calendar")?.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: image)
        iv.tintColor = .black
        return iv
    }()
    var clockIcon: UIImageView = {
        let image = UIImage(named:"clock")?.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: image)
        iv.tintColor = .black
        return iv
    }()
    
    var delegate: ToDoEditDelegate?
    var todo: Item? {
        didSet {
            
            var dueDate = todo!.dueDate
        
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
            var dueDateText = dateFormatter.string(from: todo!.dueDate)
            dateDescription.text = dueDateText
            let strokeEffect: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.black,
              ]
            var timeAllowed = todo!.time
            let hour = timeAllowed/3600
            let minutes = (timeAllowed%3600)/60
            timeDescription.text = "\(hour) hrs and \(minutes) mins"
            
            
            print(todo!.important)
            if todo!.important {
                self.layer.shadowColor = UIColor.Flat.red.withAlphaComponent(0.5).cgColor
            }
            else {
                self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor 
            }
            
            
            if todo!.done {
                self.checkButton.backgroundColor = UIColor.Flat.red
                var attributedString = NSAttributedString(string: todo!.title, attributes: strokeEffect)
                self.titleLabel.attributedText = attributedString
            }
            else {
                self.checkButton.backgroundColor = UIColor.clear
                var attributedString = NSAttributedString(string: todo!.title, attributes: nil)
                self.titleLabel.attributedText = attributedString
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    
    func setupView() {
        
      
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.makeShadow()
        self.addSubview(checkButton)
        checkButton.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        checkButton.addTarget(self, action: #selector(todoChecked(_:)), for: .touchUpInside)
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: checkButton.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.addSubview(calendarIcon)
        calendarIcon.alpha = 0
        calendarIcon.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        self.addSubview(dateDescription)
        dateDescription.alpha = 0
        dateDescription.anchor(top: titleLabel.bottomAnchor, left: calendarIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.addConstraints([NSLayoutConstraint(item: dateDescription, attribute: .centerY, relatedBy: .equal, toItem: calendarIcon, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addSubview(clockIcon)
        clockIcon.alpha = 0
        clockIcon.anchor(top: calendarIcon.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        self.addSubview(timeDescription)
        timeDescription.alpha = 0
        timeDescription.anchor(top: calendarIcon.bottomAnchor, left: clockIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.addConstraints([NSLayoutConstraint(item: timeDescription, attribute: .centerY, relatedBy: .equal, toItem: clockIcon, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addSubview(startButton)
        
        startButton.anchor(top: clockIcon.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: -10, paddingRight: -20, width: 0, height: 0)
        startButton.alpha = 0
        startButton.addTarget(self, action: #selector(startTask(_:)), for: .touchUpInside)
        
    }
    

    
    @objc func startTask(_ sender: UIButton) {
        delegate?.toDoStart(cell: self)
        print("haha")
        
    }
    
    @objc func todoChecked(_ sender: UIButton) {
        delegate?.toDoDelete(cell:self)
    }
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    func animate() {
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
}
