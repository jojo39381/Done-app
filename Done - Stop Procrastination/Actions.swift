//
//  Actions.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 10/16/20.
//

import UIKit

protocol ActionDelegate {
    func resetView()
}
class Actions: NSObject, ActionSlideDelegate {
    func deleteItem() {
        
        vc!.toDoDelete(cell: cell!)
        handleDismiss()
    }
    func markImportant() {
        vc!.markImportant(cell: cell!)
        handleDismiss()
    }
    func startTask() {
        vc!.toDoStart(cell: cell!)
        handleDismiss()
    }
    func checkTask() {
        vc!.markDone(cell:cell!)
        handleDismiss()
    }
    
    
    let blackView = UIView()
    var delegate: ActionDelegate?
    let actionSlide = ActionSlide()
    var vc: HomeViewController?
    var cell: ToDoCell?
    func showFilters() {
        if let window = UIApplication.shared.keyWindow {
            
            self.blackView.backgroundColor = UIColor(white:0, alpha: 0.5)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            
            
            self.blackView.addGestureRecognizer(tapGesture)
            blackView.isUserInteractionEnabled = true
            window.addSubview(blackView)
            
            window.addSubview(actionSlide)
            actionSlide.delegate = self
            
            
            let height: CGFloat = 80
            let y = window.frame.height - height
            actionSlide.frame = CGRect(x:0, y:window.frame.height, width:window.frame.width, height:height)
            self.blackView.frame = window.frame
            self.blackView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.actionSlide.frame = CGRect(x:0, y:y, width:self.actionSlide.frame.width, height:self.actionSlide.frame.height)
            }, completion: nil)
            
            
            
            
        }
    }
    @objc func handleDismiss() {
        print("pressed")
        delegate?.resetView()
        
        UIView.animate(withDuration: 0.2) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.actionSlide.frame = CGRect(x:0, y:window.frame.height, width:self.actionSlide.frame.width,
                                                   height:self.actionSlide.frame.height)
            }
        }
        
        
    }
}
