//
//  SectionTitleView.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/24/20.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "asdasd"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupView()
    }
    func setupView() {
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}
