//
//  SettingsViewController.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

protocol SettingsDelegate{
    func settings(_ settings: SettingsViewController, didUpdateCards cardsName: String)
    
    func settings(_ settings: SettingsViewController, didUpdateGrid grid: Int, didUpdateGridElement gridElement: Int)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var cardsTable: UITableView!
    @IBOutlet weak var gridSizeTable: UITableView!
    
    var delegate: SettingsDelegate?
    
    var cards: [String]!
    
    var cardsDirectory = "Cards.bundle/"
    
    var currentCardsName: String!
    var currentGrid: Int!
    var currentGridElement: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard isParameters() else { fatalError("Parameters not provided")}
        
        title = "Settings"
        
        loadCards()
        
        cardsTable.dataSource = self
        cardsTable.delegate = self
        selectedCard()
        
        gridSizeTable.dataSource = self
        gridSizeTable.delegate = self
        selectedGrid()
    }
    
    func setParameters(currentCards: String, currentGrid: Int, currentGridElement: Int) {
        self.currentCardsName = currentCards
        self.currentGrid = currentGrid
        self.currentGridElement = currentGridElement
    }
    
    func isParameters() -> Bool {
        return currentCardsName != nil && currentGrid != nil && currentGridElement != nil
    }
    
    func loadCards() {
        cards = [String]()
        
        if let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: cardsDirectory) {
            for url in urls {
                cards.append(url.lastPathComponent)
            }
        }
        
        cards.sort()
    }
    
    func selectedCard() {
        guard let index = cards.firstIndex(of: currentCardsName) else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        cardsTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        cardsTable.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func selectedGrid() {
        let indexPath = IndexPath(row: currentGridElement, section: currentGrid)
        gridSizeTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        gridSizeTable.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == cardsTable {
            return 1
        }
        
        return grids.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == cardsTable {
            return ""
        }
        
        return "Cards: \(grids[section].numberOfElements)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cardsTable {
            return cards.count
        }
        
        return grids[section].combinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cardsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardsCell", for: indexPath)
            cell.textLabel?.text = cards[indexPath.item]
            
            return cell
        }
        
        let (gridSide1, gridSide2) = grids[indexPath.section].combinations[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath)
        cell.textLabel?.text = "\(gridSide1) x \(gridSide2)"
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cardsTable {
            delegate?.settings(self, didUpdateCards: cards[indexPath.row])
        } else {
            delegate?.settings(self, didUpdateGrid: indexPath.section, didUpdateGridElement: indexPath.row)
        }
    }
}
