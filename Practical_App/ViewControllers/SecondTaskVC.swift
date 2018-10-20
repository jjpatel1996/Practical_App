//
//  ViewController.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import UIKit

class SecondTaskViewController: UIViewController {

    @IBOutlet weak var userDetailsTableView:UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!

    var searchController:UISearchController!
    
    var parentVC:GlobalTabbarViewController!
    
    var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC = self.tabBarController as? GlobalTabbarViewController
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    func setup(){
        
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.titleView = searchController.searchBar

        userDetailsTableView.tableFooterView = UIView()
        userDetailsTableView.dataSource = self
        userDetailsTableView.estimatedRowHeight = 96
        userDetailsTableView.rowHeight = UITableView.automaticDimension
        userDetailsTableView.delegate = self
        userDetailsTableView.isHidden = true
        shouldShowSearchingView(shouldShow: false)
    }
 
    private func updateUI(){
        if self.parentVC.userList.items.count > 0 {
            searchController.searchBar.text = parentVC.userList.searchBarText
        }else{
            searchController.searchBar.text = nil
        }
        reloadTableView()
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.userDetailsTableView.reloadData()
        }
    }
    

    private func shouldShowSearchingView(shouldShow:Bool){
        DispatchQueue.main.async {
            if shouldShow {
                self.searchLabel.isHidden = false
                self.searchingIndicator.startAnimating()
                self.searchingIndicator.isHidden = false
                self.noResultLabel.isHidden = true
            }else{
                self.searchLabel.isHidden = true
                self.searchingIndicator.stopAnimating()
                self.searchingIndicator.isHidden = true
                self.noResultLabel.isHidden = false
            }
        }
    }
    
    private func showSpinner(isShow:Bool){
        if isShow {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: userDetailsTableView.bounds.width, height: CGFloat(44))
            
            userDetailsTableView.tableFooterView = spinner
            userDetailsTableView.tableFooterView?.isHidden = false
        }else{
            userDetailsTableView.tableFooterView = UIView()
        }
    }
    
    private func fetchUserList(inputText:String?,nextUserListUrl:String?){
        
        if inputText != nil {
            shouldShowSearchingView(shouldShow: true)
        }
        isFetching = true
        WebMethods.getUserList(inputText: inputText, nextPageUrlString: nextUserListUrl) { [weak self] (items, nextPageString) in
            //Assing items to array if fetching first time else append into array and update tableview
            guard let strongSelf = self  else { return }
            strongSelf.isFetching = false
            print("Counts ------------------------------- \(items.count)" )
            if inputText != nil {               //fetch new users
               strongSelf.parentVC.userList.items = items
               strongSelf.reloadTableView()
               strongSelf.shouldShowSearchingView(shouldShow: false)
            }else{                                     //fetch more users
                strongSelf.parentVC.userList.items.append(contentsOf: items)
                strongSelf.reloadTableView()
                strongSelf.showSpinner(isShow: false)
            }
            self?.parentVC.userList.nextListLink = nextPageString
        }
    }
    
}
extension SecondTaskViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        parentVC.userList.reset() // Needed? 
        reloadTableView()
        
        let searchText = searchBar.text
        guard searchText != nil && searchText != "" else { return }
        parentVC.userList.searchBarText = searchText
        fetchUserList(inputText: searchText, nextUserListUrl: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        parentVC.userList.searchBarText = nil
        parentVC.userList.reset()
        reloadTableView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if parentVC.userList.items.count == 0 {
            noResultLabel.isHidden = false
            userDetailsTableView.isHidden = true
        }else{
            noResultLabel.isHidden = true
            userDetailsTableView.isHidden = false
        }
        return parentVC.userList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellID", for: indexPath) as! GithubUserTableViewCell
        cell.item = parentVC.userList.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (parentVC.userList.items.count - 1)  && parentVC.userList.nextListLink != nil && !isFetching{
            self.showSpinner(isShow: true)
            fetchUserList(inputText: nil, nextUserListUrl: parentVC.userList.nextListLink!)
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 96
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            parentVC.userList.items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
            tableView.endUpdates()
        }
    }
}
