//
//  CountDownViewController.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/27/20.
//

import UIKit
import WaveAnimationView
import RealmSwift

protocol CountDownDelegate {
    func toDoDelete(cell: ToDoCell)
}
class CountDownViewController: UIViewController {

    
    var time = 100.0
    var wave = WaveAnimationView()

    var countDown = 0
    
    var hours: Int?
    var minutes: Int?
    var seconds: Int?
    var cell:ToDoCell?
    var delegate:CountDownDelegate?
    let realm = try! Realm()
    var totalSeconds: Int? {
        didSet {
            countDown = totalSeconds!
            hours = totalSeconds!/3600
            minutes = (totalSeconds!%3600)/60
            seconds = (totalSeconds!%3600)%60
            setupTimerView()
        }
    }
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1 hr and 50 mins"
        label.textColor = .black
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        wave = WaveAnimationView(frame: self.view.frame, color: UIColor.Flat.red)
        wave.frontColor = UIColor.Flat.red.withAlphaComponent(1)
        wave.backColor = UIColor.Flat.red.withAlphaComponent(0.5)
        self.view.addSubview(wave)
        
        wave.setProgress(1)
        wave.startAnimation()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupTimerView() {
        timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(runProgress), userInfo: nil, repeats: true)
        view.addSubview(timerLabel)
        timerLabel.text = "\(hours!) hrs : \(minutes!) mins : \(seconds!) seconds"
        timerLabel.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    var count = 0
    @objc func runProgress() {
       print("//")
        
        print(countDown)
        hours = countDown/3600
        minutes = (countDown%3600)/60
        seconds = (countDown%3600)%60
        timerLabel.text = "\(hours!) hrs : \(minutes!) mins : \(seconds!) seconds"
        if countDown == 0 {
            timer.invalidate()
            delegate?.toDoDelete(cell: cell!)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
        countDown -= 10
        wave.setProgress(Float(countDown)/Float(totalSeconds!))
        
    }
    
    
    func realmDelete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        }
        catch {
            print("error")
        }
        self.navigationController?.popViewController(animated: true)

    }

    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
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
