//
//  AddCategoryViewController.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/27/20.
//

import UIKit

class AddCategoryViewController: UIViewController {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Category"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    var addTaskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Add Category"
        tf.layer.borderWidth = 0.3
        tf.addTarget(self, action:#selector(handleChange) , for: .editingChanged)
        return tf
    }()
    
    
    var categoryTitle = ""
    @objc func handleChange() {
        guard let categoryName = addTaskTextField.text else {
            return
        }
        categoryTitle = categoryName
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleLabel)
        
        titleLabel.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        // Do any additional setup after loading the view.
        self.view.addSubview(addTaskTextField)
        addTaskTextField.anchor(top: titleLabel.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 50)
        
        
        
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
