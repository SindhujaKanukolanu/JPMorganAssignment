//
//  ViewController.swift
//  JPMorgan
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import UIKit
import Combine
import AFNetworking

class ViewController: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let rowIdentifier = "listIdentifier"
    private var cardsPublisher: AnyCancellable?
    private var sectionModel: [SectionModel] = []
    
    
    private lazy var datasource = makeDatasource()
    
    var viewModel = DataSourceViewModel()
    
    var cancellables = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableviewCells()
        setupBindings()
        // delay and update tableview
        self.update(with: self.viewModel.cards)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //destory all subscriptions
        cancellables.forEach { (subscriber) in
            subscriber.cancel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupBindings()
        if !AFNetworkReachabilityManager.shared().isReachable && viewModel.planetsArray.count > 0 {
            DispatchQueue.main.async {
                self.getOfflineArray()
            }
        }
    }
    
    private func setupBindings() {
            cardsPublisher = viewModel.fetchCards().sink(receiveCompletion: { (completion) in
                if case .failure(let error) = completion {
                    print("fetch error -- \(error)")
                }
            }, receiveValue: { [weak self] cards in
                
                self?.update(with: cards)
            })
    }
    
    private func getOfflineArray() {
        let defaults = UserDefaults.standard
        var dataModels: [DataModel] = []
        let offlineArray = defaults.array(forKey: "OfflineArray")
        offlineArray?.forEach { value in
            dataModels.append(DataModel(planetName: value as! String, rotation_period: value as! String))
        }
        sectionModel.append(SectionModel(title: "", rows: dataModels))
        update(with: sectionModel)
    }
    private func setupTableviewCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: rowIdentifier)
        tableView.dataSource = datasource
        tableView.delegate = self
        
        tableView.rowHeight = 100.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = datasource.snapshot().sectionIdentifiers[section]
        
        let label = UILabel()
        label.text = sectionModel.title
        return label
    }

}

// all diffable dataosurce code
extension ViewController {
    
    // create diffable tableview datasource
    private func makeDatasource() -> UITableViewDiffableDataSource<SectionModel, DataModel> {
        let reuseIdentifier = rowIdentifier
        
        return UITableViewDiffableDataSource<SectionModel, DataModel>(tableView: tableView) { tableView, indexPath, rowModel -> UITableViewCell? in
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            if cell.detailTextLabel == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            }
            cell.textLabel?.text = rowModel.planetName
            cell.detailTextLabel?.text = rowModel.rotation_period
            return cell
        }
        
    }
    
    func update(with cards: [SectionModel], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, DataModel>()
        
        cards.forEach { (section) in
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }
        
        datasource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
}

