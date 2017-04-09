//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Namrata Mehta on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import SevenSwitch

@objc protocol  FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:  [String : AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate,  SortCellDelegate, DealCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int: Bool]()
    
    var distances: [String:Int]!
    var distancesKeys: [String]!
    
    var currentDistance = ("Auto", -1)
    
    var selectedSort = 0
    var isDealSelected = false
    
    var selectedDistance = "Best Match"
    var selectedDistanceIndex = 0
    var shouldDisplayAllDistances = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        categories = yelpCategories()
        distances = self.yelpDistances()
        
        distancesKeys = Array(self.distances.keys)
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(section)
        if section == 0 {
            return 1
        } else if section == 1 {
            return shouldDisplayAllDistances ? (distances.count+1) : 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return categories.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell", for: indexPath) as! DealCell
            cell.delegate = self
            //isDealSelected = cell.dealSwitch.isOn()
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            var dist = String()
            if indexPath.row == 0 {
                dist = selectedDistance
            } else {
                dist = distancesKeys[indexPath.row - 1]
            }
            cell.distanceLabel.text = dist
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                shouldDisplayAllDistances = !shouldDisplayAllDistances
                selectedDistance = "Auto"
                if !shouldDisplayAllDistances {
                    selectedDistanceIndex = indexPath.row
                }
                tableView.reloadData()
                return
            }
            
            if shouldDisplayAllDistances {
                let cell = tableView.cellForRow(at: indexPath) as! DistanceCell
                selectedDistanceIndex = indexPath.row
                selectedDistance = cell.distanceLabel.text!
            }
            
            shouldDisplayAllDistances = !shouldDisplayAllDistances
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else if section == 1 {
            return "Distance"
        }
        else if section == 2 {
            return "Sort By"
        }
        else if section == 3 {
            return "Category"
        }
        return nil
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        
        // Deals
        filters["deals_filter"] = isDealSelected as AnyObject?
        // Sort
        filters["sort"] = selectedSort as AnyObject?
        // Distance
        filters["radius_filter"] = distances[selectedDistance] as AnyObject?
        
        // Categories
        if selectedCategories.count > 0 {
            filters["category_filter"] = selectedCategories as AnyObject?
        }
        
        print("On search clicked \(filters)")
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        switchStates[(indexPath?.row)!] = value
    }
    
    
    func sortCell(sortCell: SortCell, didChangeValue value: Int) {
        selectedSort = value
    }
    
    func dealCell(dealCell: DealCell, didChangeValue value: Bool) {
        print("deallCell value is \(isDealSelected)")
        isDealSelected = value
    }
    
    
    func yelpDistances() -> [String: Int] {
        return [
            " 0.3 Miles": 483,
            " 1 Miles": 1609,
            " 5 Miles": 8047,
            " 20 Miles": 32187
        ]
    }
    
    func yelpCategories() -> [[String:String]] {
        return   [["name" : "Afghan", "code": "afghani"],
                  ["name" : "African", "code": "african"],
                  ["name" : "American, New", "code": "newamerican"],
                  ["name" : "American, Traditional", "code": "tradamerican"],
                  ["name" : "Arabian", "code": "arabian"],
                  ["name" : "Argentine", "code": "argentine"],
                  ["name" : "Armenian", "code": "armenian"],
                  ["name" : "Asian Fusion", "code": "asianfusion"],
                  ["name" : "Asturian", "code": "asturian"],
                  ["name" : "Australian", "code": "australian"],
                  ["name" : "Austrian", "code": "austrian"],
                  ["name" : "Baguettes", "code": "baguettes"],
                  ["name" : "Bangladeshi", "code": "bangladeshi"],
                  ["name" : "Barbeque", "code": "bbq"],
                  ["name" : "Basque", "code": "basque"],
                  ["name" : "Bavarian", "code": "bavarian"],
                  ["name" : "Beer Garden", "code": "beergarden"],
                  ["name" : "Beer Hall", "code": "beerhall"],
                  ["name" : "Beisl", "code": "beisl"],
                  ["name" : "Belgian", "code": "belgian"],
                  ["name" : "Bistros", "code": "bistros"],
                  ["name" : "Black Sea", "code": "blacksea"],
                  ["name" : "Brasseries", "code": "brasseries"],
                  ["name" : "Brazilian", "code": "brazilian"],
                  ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                  ["name" : "British", "code": "british"],
                  ["name" : "Buffets", "code": "buffets"],
                  ["name" : "Bulgarian", "code": "bulgarian"],
                  ["name" : "Burgers", "code": "burgers"],
                  ["name" : "Burmese", "code": "burmese"],
                  ["name" : "Cafes", "code": "cafes"],
                  ["name" : "Cafeteria", "code": "cafeteria"],
                  ["name" : "Cajun/Creole", "code": "cajun"],
                  ["name" : "Cambodian", "code": "cambodian"],
                  ["name" : "Canadian", "code": "New)"],
                  ["name" : "Canteen", "code": "canteen"],
                  ["name" : "Caribbean", "code": "caribbean"],
                  ["name" : "Catalan", "code": "catalan"],
                  ["name" : "Chech", "code": "chech"],
                  ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                  ["name" : "Chicken Shop", "code": "chickenshop"],
                  ["name" : "Chicken Wings", "code": "chicken_wings"],
                  ["name" : "Chilean", "code": "chilean"],
                  ["name" : "Chinese", "code": "chinese"],
                  ["name" : "Comfort Food", "code": "comfortfood"],
                  ["name" : "Corsican", "code": "corsican"],
                  ["name" : "Creperies", "code": "creperies"],
                  ["name" : "Cuban", "code": "cuban"],
                  ["name" : "Curry Sausage", "code": "currysausage"],
                  ["name" : "Cypriot", "code": "cypriot"],
                  ["name" : "Czech", "code": "czech"],
                  ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                  ["name" : "Danish", "code": "danish"],
                  ["name" : "Delis", "code": "delis"],
                  ["name" : "Diners", "code": "diners"],
                  ["name" : "Dumplings", "code": "dumplings"],
                  ["name" : "Eastern European", "code": "eastern_european"],
                  ["name" : "Ethiopian", "code": "ethiopian"],
                  ["name" : "Fast Food", "code": "hotdogs"],
                  ["name" : "Filipino", "code": "filipino"],
                  ["name" : "Fish & Chips", "code": "fishnchips"],
                  ["name" : "Fondue", "code": "fondue"],
                  ["name" : "Food Court", "code": "food_court"],
                  ["name" : "Food Stands", "code": "foodstands"],
                  ["name" : "French", "code": "french"],
                  ["name" : "French Southwest", "code": "sud_ouest"],
                  ["name" : "Galician", "code": "galician"],
                  ["name" : "Gastropubs", "code": "gastropubs"],
                  ["name" : "Georgian", "code": "georgian"],
                  ["name" : "German", "code": "german"],
                  ["name" : "Giblets", "code": "giblets"],
                  ["name" : "Gluten-Free", "code": "gluten_free"],
                  ["name" : "Greek", "code": "greek"],
                  ["name" : "Halal", "code": "halal"],
                  ["name" : "Hawaiian", "code": "hawaiian"],
                  ["name" : "Heuriger", "code": "heuriger"],
                  ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                  ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                  ["name" : "Hot Dogs", "code": "hotdog"],
                  ["name" : "Hot Pot", "code": "hotpot"],
                  ["name" : "Hungarian", "code": "hungarian"],
                  ["name" : "Iberian", "code": "iberian"],
                  ["name" : "Indian", "code": "indpak"],
                  ["name" : "Indonesian", "code": "indonesian"],
                  ["name" : "International", "code": "international"],
                  ["name" : "Irish", "code": "irish"],
                  ["name" : "Island Pub", "code": "island_pub"],
                  ["name" : "Israeli", "code": "israeli"],
                  ["name" : "Italian", "code": "italian"],
                  ["name" : "Japanese", "code": "japanese"],
                  ["name" : "Jewish", "code": "jewish"],
                  ["name" : "Kebab", "code": "kebab"],
                  ["name" : "Korean", "code": "korean"],
                  ["name" : "Kosher", "code": "kosher"],
                  ["name" : "Kurdish", "code": "kurdish"],
                  ["name" : "Laos", "code": "laos"],
                  ["name" : "Laotian", "code": "laotian"],
                  ["name" : "Latin American", "code": "latin"],
                  ["name" : "Live/Raw Food", "code": "raw_food"],
                  ["name" : "Lyonnais", "code": "lyonnais"],
                  ["name" : "Malaysian", "code": "malaysian"],
                  ["name" : "Meatballs", "code": "meatballs"],
                  ["name" : "Mediterranean", "code": "mediterranean"],
                  ["name" : "Mexican", "code": "mexican"],
                  ["name" : "Middle Eastern", "code": "mideastern"],
                  ["name" : "Milk Bars", "code": "milkbars"],
                  ["name" : "Modern Australian", "code": "modern_australian"],
                  ["name" : "Modern European", "code": "modern_european"],
                  ["name" : "Mongolian", "code": "mongolian"],
                  ["name" : "Moroccan", "code": "moroccan"],
                  ["name" : "New Zealand", "code": "newzealand"],
                  ["name" : "Night Food", "code": "nightfood"],
                  ["name" : "Norcinerie", "code": "norcinerie"],
                  ["name" : "Open Sandwiches", "code": "opensandwiches"],
                  ["name" : "Oriental", "code": "oriental"],
                  ["name" : "Pakistani", "code": "pakistani"],
                  ["name" : "Parent Cafes", "code": "eltern_cafes"],
                  ["name" : "Parma", "code": "parma"],
                  ["name" : "Persian/Iranian", "code": "persian"],
                  ["name" : "Peruvian", "code": "peruvian"],
                  ["name" : "Pita", "code": "pita"],
                  ["name" : "Pizza", "code": "pizza"],
                  ["name" : "Polish", "code": "polish"],
                  ["name" : "Portuguese", "code": "portuguese"],
                  ["name" : "Potatoes", "code": "potatoes"],
                  ["name" : "Poutineries", "code": "poutineries"],
                  ["name" : "Pub Food", "code": "pubfood"],
                  ["name" : "Rice", "code": "riceshop"],
                  ["name" : "Romanian", "code": "romanian"],
                  ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                  ["name" : "Rumanian", "code": "rumanian"],
                  ["name" : "Russian", "code": "russian"],
                  ["name" : "Salad", "code": "salad"],
                  ["name" : "Sandwiches", "code": "sandwiches"],
                  ["name" : "Scandinavian", "code": "scandinavian"],
                  ["name" : "Scottish", "code": "scottish"],
                  ["name" : "Seafood", "code": "seafood"],
                  ["name" : "Serbo Croatian", "code": "serbocroatian"],
                  ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                  ["name" : "Singaporean", "code": "singaporean"],
                  ["name" : "Slovakian", "code": "slovakian"],
                  ["name" : "Soul Food", "code": "soulfood"],
                  ["name" : "Soup", "code": "soup"],
                  ["name" : "Southern", "code": "southern"],
                  ["name" : "Spanish", "code": "spanish"],
                  ["name" : "Steakhouses", "code": "steak"],
                  ["name" : "Sushi Bars", "code": "sushi"],
                  ["name" : "Swabian", "code": "swabian"],
                  ["name" : "Swedish", "code": "swedish"],
                  ["name" : "Swiss Food", "code": "swissfood"],
                  ["name" : "Tabernas", "code": "tabernas"],
                  ["name" : "Taiwanese", "code": "taiwanese"],
                  ["name" : "Tapas Bars", "code": "tapas"],
                  ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                  ["name" : "Tex-Mex", "code": "tex-mex"],
                  ["name" : "Thai", "code": "thai"],
                  ["name" : "Traditional Norwegian", "code": "norwegian"],
                  ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                  ["name" : "Trattorie", "code": "trattorie"],
                  ["name" : "Turkish", "code": "turkish"],
                  ["name" : "Ukrainian", "code": "ukrainian"],
                  ["name" : "Uzbek", "code": "uzbek"],
                  ["name" : "Vegan", "code": "vegan"],
                  ["name" : "Vegetarian", "code": "vegetarian"],
                  ["name" : "Venison", "code": "venison"],
                  ["name" : "Vietnamese", "code": "vietnamese"],
                  ["name" : "Wok", "code": "wok"],
                  ["name" : "Wraps", "code": "wraps"],
                  ["name" : "Yugoslav", "code": "yugoslav"]]
    }

}
