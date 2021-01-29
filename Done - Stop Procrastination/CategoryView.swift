//
//  CategoryView.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/23/20.
//

import UIKit
import RealmSwift

protocol CategoryViewDelegate {
    func goToCategory(category: Category)
}
class CategoryView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //id
    let cellId = "categoryCellId"
    var categories : Results<Category>?
    
    
    
    //view objects
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let cv = UICollectionView(frame:.zero, collectionViewLayout: layout)
        return cv
        
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Projects"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        setupView()
    }
    func setupView() {
        collectionView.backgroundColor = .clear
        
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.addSubview(todayLabel)
        todayLabel.anchor(top: collectionView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    var delegate: CategoryViewDelegate?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let categoryList = categories else {return}
        delegate?.goToCategory(category: categoryList[indexPath.item + 1])
    }
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories?.count ?? 1) - 1
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height)
    }


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        guard let categoryList = categories else {return myCell}
        myCell.titleLabel.text = categoryList[indexPath.item + 1].name
        return myCell
    }
}
