//
//  ToDoView.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/25/20.
//

import UIKit

class ToDoView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ToDoCell
        myCell.animate()
        return myCell
    }
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isExpanded[indexPath.item]{
            return CGSize(width: collectionView.frame.width * 0.8, height: 200)
                }else{
                    return CGSize(width: collectionView.frame.width * 0.8, height: 50)
                }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExpanded[indexPath.item] = !isExpanded[indexPath.item]
        
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 0.8, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                      self.collectionView.reloadItems(at: [indexPath])
                    }, completion: { success in
                        print("success")
                })
    }

        
      
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //cell id
    let cellId = "cellId"
    var collectionView: UICollectionView = {
       
      
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        
        
        cv.backgroundColor = .clear
        return cv
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    var isExpanded = [Bool]()
    override init(frame: CGRect) {
        super.init(frame:frame)
        isExpanded = Array(repeating: false, count:2)

        setupView()
    }
    func setupView() {
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.addSubview(collectionView)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ToDoCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }

}
