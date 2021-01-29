//
//  CategoryViewController.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/28/20.
//

import UIKit
import Floaty
import PopupDialog
import RealmSwift
class CategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ToDoEditDelegate, CountDownDelegate{

    var category: Category? {
        didSet {
            setupView()
        }
    }
    
    let cellId = "cellId"
    var selectedIndex = IndexPath()
    var isExpanded = false
    let realm = try! Realm()
    let floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.collectionView.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        let more = UIImage(named:"circle")?.withRenderingMode(.alwaysTemplate)
        more?.withTintColor(.gray)
        let moreButton = UIBarButtonItem(image: more, style: .plain, target: self, action: #selector(presentAlert))
        navigationItem.rightBarButtonItem = moreButton
        setupFloaty()
        // Do any additional setup after loading the view.
    }
    
    @objc func presentAlert() {
        let deleteAlert = UIAlertController(title: "Actions", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

            let unfollowAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                guard let cat = self.category else {return}
                do {
                    try self.realm.write {
                        self.realm.delete(cat)
                    }
                }
                catch {
                    print("error")
                }
                
                self.navigationController?.popViewController(animated: true)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            deleteAlert.addAction(unfollowAction)
            deleteAlert.addAction(cancelAction)
            self.present(deleteAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func toDoDelete(cell:ToDoCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else{return}
        
        var item = category?.items[indexPath.item]
        do {
            try realm.write {
                realm.delete(item!)
            }
        }
        catch {
            print("error")
        }
        selectedIndex = IndexPath()
        isExpanded = false
        self.collectionView.deleteItems(at: [indexPath])
        
        
    }
    func toDoStart(cell: ToDoCell) {
        var indexPath = self.collectionView.indexPath(for: cell)
        let vc = CountDownViewController()
        let current = cell.todo!.time
        vc.totalSeconds = current
        vc.cell = cell
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setupFloaty() {
       
        
        
        floaty.addItem("Add Task", icon: UIImage(named:"pencil")) { (item) in
            self.makeTask()
            self.floaty.close()
            
            
        }
       
        self.view.addSubview(floaty)
        floaty.paddingY = 30
    }
    
    
    func makeTask() {
        let pop = "Add Task"
        let custom = AddTaskViewViewController()
        let popup = PopupDialog(viewController: custom,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
       
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "ADD", height: 60) { [self] in
            guard let cat = self.category else {return}
            do {
               
                try self.realm.write {
                    let item = Item()
                    item.title = custom.taskTitle
                   
                    item.dueDate = custom.datePicker.date
                    item.time = custom.hours * 3600 + custom.minutes * 60
                    item.important = false
                    cat.items.append(item)
                    
                    
                }
            }catch {
                print("error")
            }
            self.collectionView.reloadData()
           
            
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
       
        self.present(popup, animated: true, completion: nil)
    }
    
    func setupView() {
        collectionView?.register(ToDoCell.self, forCellWithReuseIdentifier: cellId)
        self.title = category!.name
        self.view.backgroundColor = .red
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (category?.items.count)!
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ToDoCell
        
        cell.delegate = self
        if let cat = category {
            cell.todo = cat.items[indexPath.item]
        }
        
        if selectedIndex == indexPath {
           
            cell.timeDescription.alpha = 1
            cell.calendarIcon.alpha = 1
            cell.dateDescription.alpha = 1
            cell.clockIcon.alpha = 1
            cell.startButton.alpha = 1
        }
        else {
            cell.timeDescription.alpha = 0
            cell.calendarIcon.alpha = 0
            cell.dateDescription.alpha = 0
            cell.clockIcon.alpha = 0
            cell.startButton.alpha = 0
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var reloadIndex = IndexPath()
        if isExpanded && selectedIndex != indexPath {
            reloadIndex = selectedIndex
            selectedIndex = IndexPath()
        }
        else if isExpanded && selectedIndex == indexPath {
            reloadIndex = selectedIndex
            selectedIndex = IndexPath()
        }
        else if !isExpanded {
            reloadIndex = indexPath
            selectedIndex = indexPath
        }
        isExpanded = !isExpanded
        
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 0.8, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                      self.collectionView.reloadItems(at: [reloadIndex])
          
                    }, completion: { success in
                        print("success")
                })
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndex == indexPath{
            return CGSize(width: collectionView.frame.width * 0.8, height: 200)
                }else{
                    return CGSize(width: collectionView.frame.width * 0.8, height: 50)
                }
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
