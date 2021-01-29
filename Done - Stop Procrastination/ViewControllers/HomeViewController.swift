//
//  ViewController.swift
//  Done - Stop Procrastination
//
//  Created by Joseph Yeh on 9/23/20.
//

import UIKit
import PopupDialog
import Floaty
import RealmSwift
class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ToDoEditDelegate, CategoryViewDelegate, ActionDelegate, UIGestureRecognizerDelegate, CountDownDelegate{
    func resetView() {
        collectionView.reloadData()
        print("reloaded")
    }
    
    
    func goToCategory(category: Category) {
        let layout = UICollectionViewFlowLayout()
        let vc = CategoryViewController(collectionViewLayout: layout)
       
        vc.category = category
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toDoDelete(cell:ToDoCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else{return}
       
        var section = todayItems
        if indexPath.section == 0 {
            section = todayItems
            var item = section[indexPath.item]
            realmDelete(item: item)
            todayItems.remove(at: indexPath.item)
            
        }
        else if indexPath.section == 1{
            section = thisWeekItems
            var item = section[indexPath.item]
            realmDelete(item: item)
            thisWeekItems.remove(at: indexPath.item)
        }
        else {
            section = nextWeekItems
            var item = section[indexPath.item]
            realmDelete(item: item)
            nextWeekItems.remove(at: indexPath.item)
        }
        selectedIndex = IndexPath()
        isExpanded = false
        DispatchQueue.main.async {
            print("aa")
            
            self.collectionView.deleteItems(at: [indexPath])
        }
        
        
        
        
        
        
       
        
       

        
        
       
        
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
    
    func markImportant(cell: UICollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else{return}
        var section = todayItems
        if indexPath.section == 0 {
            section = todayItems
            var item = section[indexPath.item]
            realmUpdateImportant(item: item)
            
            
        }
        else if indexPath.section == 1{
            section = thisWeekItems
            var item = section[indexPath.item]
            realmUpdateImportant(item: item)
           
        }
        else {
            section = nextWeekItems
            var item = section[indexPath.item]
            realmUpdateImportant(item: item)
            
        }
        
        loadItems()
        collectionView.reloadData()
        
    }
    
    
    func realmUpdateImportant(item: Item) {
        do {
            try realm.write {
                item.important = !item.important
            }
        }
        catch {
            print("error")
        }
    }
    
    
    func markDone(cell:ToDoCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else{return}
        var section = todayItems
        if indexPath.section == 0 {
            section = todayItems
            var item = section[indexPath.item]
            realmUpdateDone(item: item)
            
            
        }
        else if indexPath.section == 1{
            section = thisWeekItems
            var item = section[indexPath.item]
            realmUpdateDone(item: item)
           
        }
        else {
            section = nextWeekItems
            var item = section[indexPath.item]
            realmUpdateDone(item: item)
            
        }
        
        loadItems()
        collectionView.reloadData()
    }
    
    
    
    func realmUpdateDone(item: Item) {
        do {
            try realm.write {
                item.done = !item.done
            }
        }
        catch {
            print("error")
        }
    }
//    var actionButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor.Flat.red
//        button.layer.cornerRadius = 40
//
//        button.setTitle("add", for: .normal)
//        return button
//    }()
    
    
    
    //view objects
    var selectedIndex = IndexPath()
    var isExpanded = false
    
    //id
    let cellId = "cellId"
    let introId = "introId"
    let headerId = "headerId"
    let sectionHeaderId = "sectionId"
    
    
    
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var items = [Item]()
    var todayItems = [Item]()
    var thisWeekItems = [Item]()
    var nextWeekItems = [Item]()
    let floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo"
        collectionView?.backgroundColor = .clear
        collectionView?.register(ToDoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(IntroCell.self, forCellWithReuseIdentifier: introId)
        collectionView?.register(CategoryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(SectionTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
       
        self.view.backgroundColor = UIColor.rgb(red: 250, green: 251, blue: 255)
        
        setupNav()
        
        
        loadCategories()
        loadItems()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(!appDelegate.hasAlreadyLaunched){
             
                  //set hasAlreadyLaunched to false
                  appDelegate.sethasAlreadyLaunched()
        //display user agreement license
                 setupRealm()
            }
        setupFloaty()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadCategories()
        loadItems()
        print(selectedIndex)
        print(isExpanded)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    let actions = Actions()
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizer.State.began){
            return
        }

        let p = gestureRecognizer.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p) {
                    // get the cell at indexPath (the one you long pressed)
            actions.vc = self
            actions.cell = collectionView.cellForItem(at: indexPath) as! ToDoCell
            actions.showFilters()
            
            
            } else {
                
                print("couldn't find index path")
            }
    }
    
   
    func calcTime() {
        let day: Double = 60 * 60 * 24
        let currentDate = Date() // Thu 25 Apr 2019
        let futureDate = Date(timeInterval: 3 * day, since: currentDate) // Sun 28 Apr 2019
        if Calendar.current.isDateInThisWeek(futureDate) {
            // this will be executed if first day of week is Monday
        } else {
            // this will be executed if first day of week is Sunday
        }
    }
    func setupFloaty() {
       
        
        
        floaty.addItem("Add Task", icon: UIImage(named:"pencil")) { (item) in
            self.makeTask()
            self.floaty.close()
            
            
        }
        floaty.addItem("Add Project", icon: UIImage(named:"folder")) { (item) in
            self.makeCategory()
            self.floaty.close()
            
            
        }
        self.view.addSubview(floaty)
        floaty.paddingY = 30
    }
    func setupRealm() {
        let category = Category()
        category.name = "Lone"
        saveCategory(category: category)
    }
    // Create the dialog
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
    }
    var timeSections = ["Today"]
    
    
    func loadItems() {
        todayItems = [Item]()
        thisWeekItems = [Item]()
        nextWeekItems = [Item]()
        guard let categoryList = categories else {return}
        for category in categoryList {
            let result = category.items
            
            for item in result {
                sortItemsByDate(date: item.dueDate, item: item)
            }
        }
        
        
    }
    
    func sortItemsByDate(date: Date, item: Item) {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            if !timeSections.contains("Today") {
                timeSections.append("Today")
            }
            todayItems.append(item)
        }
        else if calendar.isDateInThisWeek(date) {
            if !timeSections.contains("This Week") {
                timeSections.append("This Week")
            }
           
            thisWeekItems.append(item)
        }
        else if calendar.isDateInNextWeek(date) {
            if !timeSections.contains("Next Week") {
                timeSections.append("Next Week")
            }
        
            nextWeekItems.append(item)
        }
        
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
        let buttonOne = CancelButton(title: "CANCEL", height: 50) {
            
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "ADD", height: 50) { [self] in
            guard let categoryList = self.categories else {return}
            do {
               
                try self.realm.write {
                    let item = Item()
                    item.title = custom.taskTitle
                   
                    item.dueDate = custom.datePicker.date
                    item.time = custom.hours * 3600 + custom.minutes * 60
                    item.important = false
                    categoryList[0].items.append(item)
                    sortItemsByDate(date: item.dueDate, item: item)
                    
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
    func makeCategory() {
        let pop = "Add Category"
        let custom = AddCategoryViewController()
        let popup = PopupDialog(viewController: custom,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
       
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "ADD", height: 60) {
            let category = Category()
            category.name = custom.categoryTitle
            self.saveCategory(category: category)
            
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
       
        self.present(popup, animated: true, completion: nil)
    }
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
                
            }
        }
            catch {
                print("error")
            }
        collectionView.reloadSections([0])
    }
    func setupNav() {
        self.navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 250, green: 251, blue: 255)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var array = ["do haha", "aaosdja"]
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return timeSections.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && todayItems.isEmpty && thisWeekItems.isEmpty && nextWeekItems.isEmpty {
           
            return todayItems.count

        }
        else if section == 0 {
           
            return todayItems.count
        }
        else if section == 1 {
            return thisWeekItems.count
        }
        else {
            return nextWeekItems.count
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 && todayItems.isEmpty && thisWeekItems.isEmpty && nextWeekItems.isEmpty {
            return CGSize(width: collectionView.frame.width * 0.8, height: 300)
        }
        if selectedIndex == indexPath{
            return CGSize(width: collectionView.frame.width * 0.8, height: 200)
                }else{
                    return CGSize(width: collectionView.frame.width * 0.8, height: 50)
                }
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
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ToDoCell
        cell.delegate = self
        
        if todayItems.isEmpty && thisWeekItems.isEmpty && nextWeekItems.isEmpty {
            print("//")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: introId, for: indexPath) as! IntroCell
            return cell
        }
        
        if indexPath.section == 0 {
            
            cell.todo = todayItems[indexPath.item]
        }else if indexPath.section == 1{
            cell.todo = thisWeekItems[indexPath.item]
        }
        else {
            cell.todo = nextWeekItems[indexPath.item]
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
    //header functions
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CategoryView
            header.categories = categories
            header.delegate = self
            header.collectionView.reloadData()
            return header
        }
        else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderId, for: indexPath) as! SectionTitleView
            header.titleLabel.text = timeSections[indexPath.section]
            return header
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width:view.frame.width, height: 230)
        }
        else {
            return CGSize(width:view.frame.width, height: 20)
        }
        
        
        
        
        
        
    }
    
    
    
}

