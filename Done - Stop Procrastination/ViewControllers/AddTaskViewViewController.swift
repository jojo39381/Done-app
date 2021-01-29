//
//  AddTaskViewViewController.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/26/20.
//

import UIKit
import PopupDialog
import SwiftyPickerPopover
@available(iOS 13.4, *)
class AddTaskViewViewController: UIViewController, UITextFieldDelegate {


    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Task"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    var addTaskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Add Task"
        tf.layer.borderWidth = 0.3
        tf.addTarget(self, action:#selector(handleChange) , for: .editingChanged)
        tf.textColor = .black
        tf.isEnabled = true
        tf.tag = 0
        return tf
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        let calendar = UIImage(systemName:"calendar")?.withRenderingMode(.alwaysTemplate)
        button.setBackgroundImage(calendar, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "Oct 15"
    
        return label
    }()
    
    var clockButton: UIButton = {
        let button = UIButton()
        let clock = UIImage(systemName:"clock")?.withRenderingMode(.alwaysTemplate)
        
        button.setBackgroundImage(clock, for: .normal)
        button.tintColor = .black
        return button
        
        
       
    }()
    
    var clockLabel: UILabel = {
        let label = UILabel()
        label.text = "1 hr and 40 mins"
      
        
        return label
    }()
    var taskTitle = ""
    var hours = 0
    var minutes = 0
    @objc func handleChange(_ sender: UITextField) {
        guard let taskName = addTaskTextField.text else {
            return
        }
        guard let inputHours = hourTextField.text else {
            return
        }
        guard let inputMinutes = minutesTextField.text else {
            return
        }
        if sender.tag == 0 {
            taskTitle = taskName
        }
        else if sender.tag == 1 && inputHours != ""{
            hours = Int(inputHours)!
        }
        else if sender.tag == 2 && inputMinutes != ""{
            minutes += Int(inputMinutes)!
        }
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
        
    }
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let hourTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .line
        tf.keyboardType = .numberPad
        tf.tag = 1
        tf.addTarget(self, action:#selector(handleChange) , for: .editingChanged)
       
        tf.layer.borderWidth = 0.3
        return tf
    }()
    
    let hrLabel: UILabel = {
        let label = UILabel()
        
        label.text = "hrs"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.text = "mins"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let minutesTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .line
        tf.keyboardType = .numberPad
        tf.tag = 2
        tf.addTarget(self, action:#selector(handleChange) , for: .editingChanged)
       
        tf.layer.borderWidth = 0.3
        return tf
    }()
    func setupView() {
        self.view.addSubview(titleLabel)
        titleLabel.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        // Do any additional setup after loading the view.
        self.view.addSubview(addTaskTextField)
        addTaskTextField.anchor(top: titleLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 50)
        
        self.view.addSubview(calendarButton)
        calendarButton.anchor(top: addTaskTextField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
      
        
    
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date // setting mode to timer so user can only pick time as you want
        datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        self.view.addSubview(datePicker)
        
        datePicker.anchor(top: addTaskTextField.bottomAnchor, left: calendarButton.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        view.addConstraints([NSLayoutConstraint(item: calendarButton, attribute: .centerY, relatedBy: .equal, toItem: datePicker, attribute: .centerY, multiplier: 1, constant: 0)])
        self.view.addSubview(clockButton)
        clockButton.anchor(top: calendarButton.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: -20, paddingRight: 0, width: 30, height: 30)
        
       
       
        self.view.addSubview(clockLabel)
        self.view.addSubview(hrLabel)
        self.view.addSubview(hourTextField)
        self.view.addSubview(minutesTextField)
        self.view.addSubview(minLabel)
        hourTextField.anchor(top: calendarButton.bottomAnchor, left: clockButton.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: -20, paddingRight: 0, width: 40, height: 0)
        hrLabel.anchor(top: calendarButton.bottomAnchor, left: hourTextField.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: -20, paddingRight: 0, width: 0, height: 0)
        minutesTextField.anchor(top: calendarButton.bottomAnchor, left: hrLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: -20, paddingRight: 0, width: 40, height: 0)
        minLabel.anchor(top: calendarButton.bottomAnchor, left: minutesTextField.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: -20, paddingRight: 0, width: 0, height: 0)
        
        view.addConstraints([NSLayoutConstraint(item: hrLabel, attribute: .centerY, relatedBy: .equal, toItem: hourTextField, attribute: .centerY, multiplier: 1, constant: 0)])
        view.addConstraints([NSLayoutConstraint(item: minLabel, attribute: .centerY, relatedBy: .equal, toItem: minutesTextField, attribute: .centerY, multiplier: 1, constant: 0)])
        
        self.title = "Add Task"
        addTaskTextField.delegate = self
        hourTextField.delegate = self
        minutesTextField.delegate = self
    }


    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag != 0 {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
