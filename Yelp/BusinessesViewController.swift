//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    var offset = 0;
    var termSearch = "Thai"
    var filters = [String: AnyObject]()
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollView?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        filters["category_filter"] = nil
        filters["sort"] = YelpSortMode.bestMatched.rawValue as AnyObject
        filters["deals_filter"] = 0 as AnyObject
        filters["radius_filter"] = 4000 as AnyObject
        filters["offset"] = 0 as AnyObject
        filters["term"] = termSearch as AnyObject
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        tableView.addSubview(refreshControl)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
        loadingMoreView = InfiniteScrollView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        
        
        print("viewDidLoad \(termSearch)")
        
        Business.searchWithTerm(filter: filters,term: termSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("inside the segue without override")
        
        if segue.identifier == "filterSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            
            filtersViewController.delegate = self

        } else if segue.identifier == "mapSegue" {
            print(segue.identifier)
                        
        } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.business = businesses[(indexPath?.row)!]
        }

        
        
     }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]){
        
        print("BVFilters \(filters)")
        print("BVtermSearch \(termSearch)")
        
        Business.searchWithTerm(filter: filters,
                                term: termSearch) {
                                    (businesses: [Business]?, error: Error?) -> Void in
                                    self.businesses = businesses
                                    self.tableView.reloadData()
        }
    }
}



// For the Search bar
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offset = 0
        termSearch = searchBar.text!
        filters["term"] = searchBar.text! as AnyObject?
        filters["offset"] = offset as AnyObject
        
        searchBar.resignFirstResponder()
        Business.searchWithTerm(filter: filters, term: termSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            } else {
                print("No data for the filtered search")
            }
        })
    }
}

// For the Scrolling
extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        offset += 10
        filters["offset"] = offset as AnyObject
        
        Business.searchWithTerm(filter: self.filters,
                                term: termSearch) {
                                    (businesses: [Business]?, error: Error?) -> Void in
                                    self.isMoreDataLoading = false
                                    self.loadingMoreView!.stopAnimating()
                                    self.businesses! += businesses!
                                    self.tableView.reloadData()
        }
    }
}








