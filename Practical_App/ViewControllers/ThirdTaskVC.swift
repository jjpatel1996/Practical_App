//
//  ThirdTaskViewController.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import UIKit

class ThirdTaskViewController: UIViewController {

    var userList = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var noResultLabel: UILabel!
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var searchController:UISearchController!
    
    var parentVC:GlobalTabbarViewController!
    
    var isDataFetching:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC = self.tabBarController as? GlobalTabbarViewController
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI(){
        if self.parentVC.userList.items.count > 0 {
            searchController.searchBar.text = parentVC.userList.searchBarText
        }else{
            searchController.searchBar.text = nil
        }
        reloadCollectionView()
    }
    
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
   private  func setup(){
        
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
      
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        showSearching(shouldShow: false)
    }
    
    private func showSearching(shouldShow:Bool){
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
    
    private func fetchUserList(inputText:String?,nextUserListUrl:String?){
        
        if inputText != nil {
            showSearching(shouldShow: true)
        }
        isDataFetching = true
        WebMethods.getUserList(inputText: inputText, nextPageUrlString: nextUserListUrl) { [weak self] (items, nextPageString) in
            //Assing items to array if fetching first time else append into array and update tableview
            guard let strongSelf = self  else { return }
            strongSelf.isDataFetching = false
            if inputText != nil {               //fetch new users
                strongSelf.parentVC.userList.items = items
                strongSelf.reloadCollectionView()
                strongSelf.showSearching(shouldShow: false)
            }else{                                     //fetch more users
                strongSelf.parentVC.userList.items.append(contentsOf: items)
                strongSelf.reloadCollectionView()
                //strongSelf.showCollectionViewSpinner(isShow: false)
            }
            self?.parentVC.userList.nextListLink = nextPageString
        }
    }

//    private func showCollectionViewSpinner(isShow:Bool){
//        if isShow {
//            let spinner = UIActivityIndicatorView(style: .gray)
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: userDetailsTableView.bounds.width, height: CGFloat(44))
//
//            userDetailsTableView.tableFooterView = spinner
//            userDetailsTableView.tableFooterView?.isHidden = false
//        }else{
//            userDetailsTableView.tableFooterView = UIView()
//        }
//    }
    
    
}
extension ThirdTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate , UICollectionViewDelegateFlowLayout  {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        parentVC.userList.reset()
        reloadCollectionView()
        
        let searchText = searchBar.text
        guard searchText != nil && searchText != "" else { return }
        parentVC.userList.searchBarText = searchText
        fetchUserList(inputText: searchText, nextUserListUrl: nil)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        parentVC.userList.searchBarText = nil
        parentVC.userList.reset()
        reloadCollectionView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if parentVC.userList.items.count == 0 {
            noResultLabel.isHidden = false
            collectionView.isHidden = true
        }else{
            noResultLabel.isHidden = true
            collectionView.isHidden = false
        }
        return parentVC.userList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCellID2", for: indexPath) as! UserCollectionViewCell
        cell.item = parentVC.userList.items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (parentVC.userList.items.count - 1)  && parentVC.userList.nextListLink != nil && !isDataFetching {
            //self.showCollectionViewSpinner(isShow: true)
            fetchUserList(inputText: nil, nextUserListUrl: parentVC.userList.nextListLink!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.33, height: self.view.frame.width*0.35)
    }
    
    //this method is for space between two rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    //this method is for space between two cells which is in horizontally
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
}
