//
//  CategoryCell.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/23/20.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Landing Page"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    func setupView() {
        self.backgroundColor = UIColor.Flat.red
        self.layer.cornerRadius = 15
        self.makeShadow()
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}
