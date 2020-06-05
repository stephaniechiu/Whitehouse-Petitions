//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Stephanie on 12/17/19.
//  Copyright © 2019 Stephanie Chiu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
     var petitions = [Petition]()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    //Runs on background thread
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
                urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=3"
        } else {
               //will only show the most 100 popular petitions
                urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
            
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data) //called in background
            }
        }
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
//Show error message if unable to parse JSON file. UIAlert needs to appear on main thread
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

//Parsing data from JSON file
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            //tableView will reload on main thread when load finishes
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

//Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func creditsBtn(_ sender: Any) {
        let creditsAlert = UIAlertController(title: "Credits", message: "These petitions were brought to you by the We The People API of the Whitehouse", preferredStyle: .alert)
        let creditsAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        creditsAlert.addAction(creditsAction)
        present(creditsAlert, animated: true, completion: nil)
    }
}
