//
//  ProvinceListController.swift
//  CountryList
//
//  Created by Amit Kumar Gupta on 20/02/21.
//

import Foundation
import AlamofireImage

class ProvinceListController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var refreshControl  =   UIRefreshControl()
    private var provinceList: [ProvinceDetail] = []
    var selectedCountry: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(refreshProvinces), for: .valueChanged)
        self.table.refreshControl = refreshControl
        self.callRefreshProvinces() //  Refresh provinces on the load
    }

    @IBAction func callRefreshProvinces() {
        self.refreshControl.beginRefreshing()
        self.refreshProvinces()
    }

    @objc func refreshProvinces() {
        CLNetworkManager.shared.fetchProvinces(for: selectedCountry, completionHandler: {[weak self] result in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let provinces):
                self?.provinceList = provinces
                if provinces.isEmpty {
                    self?.showAlert(error: NetworkError.resourceNotFound)
                }
            case .failure(let error):
                //  Ideally we shouldn't update if current fetch failed due to any issue.
                //  But the requirement was to update the list everytime
                //  That is why even storing of the list in Coredata/UserDefaults has been avoided
                self?.provinceList.removeAll()
                self?.showAlert(error: error as! NetworkError)
            }
            self?.table.reloadData()
        })
    }

    private func showAlert(error: NetworkError) {
        switch error {
        default:
            let alertController = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
            alertController.addAction(.init(title: CLConstants.retry, style: .default, handler: {_ in
                self.refreshProvinces()
            }))
            alertController.addAction(.init(title: CLConstants.cancel, style: .cancel, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: .none)
        }

    }
}

extension ProvinceListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CLConstants.cell2ID, for: indexPath)
        cell.textLabel?.text =  provinceList[indexPath.row].name
        cell.textLabel?.numberOfLines   =   0
        return cell
    }
}
