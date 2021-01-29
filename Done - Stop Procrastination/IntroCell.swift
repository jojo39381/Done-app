//
//  IntroCell.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 10/19/20.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"codebase")
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        self.addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 300)
    }
    
    func setupView() {
        
    }
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}
