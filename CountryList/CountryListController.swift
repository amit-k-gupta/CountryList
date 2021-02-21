//
//  ViewController.swift
//  CountryList
//
//  Created by Amit Kumar Gupta on 20/02/21.
//

import UIKit
import AlamofireImage

class CountryListController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var refreshControl  =   UIRefreshControl()
    private var countryList: [CountryDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(refreshCountries), for: .valueChanged)
        self.table.refreshControl = refreshControl
        self.callRefreshCountries()
    }

    @IBAction func callRefreshCountries() {
        self.refreshControl.beginRefreshing()
        self.refreshCountries()
    }

    @objc func refreshCountries() {
        CLNetworkManager.shared.fetchCountries {[weak self] result in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let countries):
                self?.countryList = countries
            case .failure(let error):
                //  Ideally we shouldn't update if current fetch failed due to any issue.
                //  But the requirement was to update the list everytime
                //  That is why even storing of the list in Coredata/UserDefaults has been avoided
                self?.countryList.removeAll()
                self?.showAlert(error: error)
            }
            self?.table.reloadData()
        }
    }

    private func showAlert(error: Error) {
        let alertController = UIAlertController(title: CLConstants.error, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(.init(title: CLConstants.retry, style: .default, handler: {_ in
            self.refreshCountries()
        }))
        alertController.addAction(.init(title: CLConstants.cancel, style: .cancel, handler: .none))
        self.present(alertController, animated: true, completion: .none)
    }

    private func flagURL(for country: String?) -> URL? {
        return URL(string: "https://www.countryflags.io/\(country ?? "")/shiny/64.png")
    }
}

extension CountryListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CLConstants.cellID, for: indexPath)
        cell.textLabel?.text =  countryList[indexPath.row].name
        cell.textLabel?.numberOfLines   =   0
        if let countryFlagURL = self.flagURL(for: countryList[indexPath.row].code) {
            cell.imageView?.af_setImage(withURL: countryFlagURL, completion: {_ in
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
        return cell
    }
}

extension CountryListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provinceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "provinces") as! ProvinceListController
        provinceVC.selectedCountry  =   countryList[indexPath.row].countryId
        self.present(provinceVC, animated: true, completion: nil)
    }
}
