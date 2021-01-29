//
//  actionSlide.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 10/16/20.
//

import UIKit
import RealmSwift

protocol ActionSlideDelegate {
    func deleteItem()
    func markImportant()
    func startTask()
    func checkTask()
}

class ActionSlide: UIView {
    
    
    
  
    var deleteButton: UIButton = {
        let button = UIButton()
    
        button.layer.cornerRadius = 20
        let clock = UIImage(systemName:"trash")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(clock, for: .normal)
        button.backgroundColor = UIColor.Flat.red
        button.tintColor = .white
        button.addTarget(self, action:#selector(deleteItem), for: .touchUpInside)
        return button
    }()
    
    
    var checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.Flat.blue
        button.layer.cornerRadius = 20
        let pencil = UIImage(systemName:"checkmark")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(pencil, for: .normal)
        button.addTarget(self, action:#selector(checkTask), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    var startButton: UIButton = {
         let button = UIButton()
        button.backgroundColor = UIColor.gray
        let bolt = UIImage(systemName:"hourglass")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(bolt, for: .normal)
        
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action:#selector(startTask), for: .touchUpInside)
        
        return button
    }()
    
    var markButton: UIButton = {
         let button = UIButton()
        button.backgroundColor = UIColor.Flat.yellow
        let bolt = UIImage(systemName:"bolt")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(bolt, for: .normal)
        
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action:#selector(markImportant), for: .touchUpInside)
        
        return button
    }()
    
    let realm = try! Realm()
    var delegate: ActionSlideDelegate?
    var item: Item? {
        didSet {
            print(item!)
            
        }
    }
    
    @objc func deleteItem() {
        delegate?.deleteItem()
        
    }
    @objc func markImportant() {
        delegate?.markImportant()
        
    }
    @objc func startTask() {
        delegate?.startTask()
    }
    
    @objc func checkTask() {
        delegate?.checkTask()
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        self.backgroundColor = .white
        setupButtonStack()
       
        
        
    }
    
    func setupButtonStack() {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, checkButton, markButton, startButton])
        stackView.axis = .horizontal
        stackView.spacing = 60
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: -20, paddingRight: -20, width: 0, height: 0)
        
    }
    func setupView() {
        
    }
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


