//
//  ViewController.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DZNEmptyDataSet

class PostListViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet private weak var tableViewPostList     : UITableView!
    @IBOutlet private weak var viewFooter            : UIView!
    @IBOutlet private weak var activityIndicatorView : UIActivityIndicatorView!
    
    //MARK:- Variables
    private var postArray          : [PostModel]        = []
    private var pageCount          : Int                = -1
    private var isPageCompleted    : Bool!              = false
    private var isAPIGettingCalled : Bool               = false
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(PostListViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private var selectedPostCounts: Int = 0 {
        didSet{
            self.setNavigationTitle()
        }
    }
    
    //MARK:- Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    //MARK:- View Methods
    private func prepareView() {
        self.callPostAPI()
        self.tableViewPostList.addSubview(refreshControl)
        tableViewPostList.tableFooterView = UIView()
    }
    
    //MARK:- Web Service Methods
    private func callPostAPI() {
        isAPIGettingCalled = true
        APIManager.shared.callRequest(Router.getPostLists(pageCount+1), onSuccess: { (response) in
            self.isAPIGettingCalled = false
            self.refreshControl.endRefreshing()
            if response.success{
                self.viewFooter.isHidden = false
                self.postArray.append(contentsOf: (response.data?.arrayValue.map({ PostModel.init(parameter: $0) }))!)
                self.selectedPostCounts = self.postArray.filter({ $0.isPostSelected }).count
                self.tableViewPostList.reloadData()
                
                if self.postArray.count == 0 {
                    self.showEmptyView()
                } else {
                    self.hideEmptyView()
                }
                
            }else{
                self.showEmptyView()
            }
        }) { (error) in
            self.isAPIGettingCalled = false
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.viewFooter.isHidden = true
        }
    }
    
    //MARK:- Custom methods
    func showEmptyView() {
        self.tableViewPostList.emptyDataSetSource   = self
        self.tableViewPostList.emptyDataSetDelegate   = self
        self.tableViewPostList.reloadData()
    }
    
    func hideEmptyView() {
        //For hide empty view
        self.tableViewPostList.emptyDataSetSource   = nil
        self.tableViewPostList.emptyDataSetDelegate   = nil
        
        self.tableViewPostList.reloadEmptyDataSet()
        self.tableViewPostList.reloadData()
    }
    
    private func setNavigationTitle()  {
        let arrFilter = self.postArray.filter { (post) -> Bool in
            return post.isPostSelected
        }
        if arrFilter.count == 0 {
            self.title = "Number of selected posts: 0"
        } else {
            self.title = arrFilter.count > 1 ? "Number of selected posts: " + "\(arrFilter.count)" : "Number of selected post: " + "\(arrFilter.count)"
        }
    }
    
    // MARK:- Refresh Control Methods
    @objc private func refresh(_ refreshControl:UIRefreshControl){
        self.pageCount = -1
        self.callPostAPI()
    }
}

//MARK: - Table View Delegate And Datasource Methods
extension PostListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewPostList.dequeueReusableCell(withIdentifier: ListTableViewCell.cell, for: indexPath) as! ListTableViewCell
        
        cell.post = self.postArray[indexPath.row]
        
        if indexPath.row == self.postArray.count - 1 && !self.isPageCompleted {
            pageCount = pageCount + 1
            activityIndicatorView.startAnimating()
            self.callPostAPI()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.postArray[indexPath.row]
        post.isPostSelected = !post.isPostSelected
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.setNavigationTitle()
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isPageCompleted == true || postArray.count == 0 {
            return UIView()
        }
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isPageCompleted == true || postArray.count == 0 {
            return 0.0001
        }
        return 70.0
    }
}

extension PostListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyMsg = "No data retrieved."
        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0)]
        let myAttrString = NSAttributedString(string: emptyMsg, attributes: myAttribute)
        return myAttrString
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

}
