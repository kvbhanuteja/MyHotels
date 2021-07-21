//
//  DashBoardViewController.swift
//  MyHotels
//
//  Created by Bhanuteja on 20/07/21.
//

import UIKit

class DashBoardViewController: BaseClassViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DashboardViewModel?
    let emptyView = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DashboardViewModel(reloadTableViewDelegate: self)
        tableView.separatorColor = UIColor(named: Constants.Colors.textColor)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: Constants.storyBoard.HotelDetailsCellNib, bundle: nil),
                           forCellReuseIdentifier: HotelDetailsTableViewCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.add,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addHotelAction(_:)))
    }

    @objc func addHotelAction(_ sender: Any) {
        let controller = getAddHotelController()
        controller.actionType = .add
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func editDetails(_ sender: UIButton) {
        let controller = getAddHotelController()
        controller.actionType = .edit
        controller.selectedRow = sender.tag
        controller.hotelObject = self.viewModel?.dataModel[sender.tag]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func deleteDetails(_ sender: UIButton) {
        viewModel?.deleteData(index: sender.tag)
    }
    
    fileprivate func getAddHotelController() -> AddHotelsViewController {
        let story = UIStoryboard(name: Constants.storyBoard.addHotelDetailsStoryBoard,
                                 bundle: nil)
        guard let controller = story.instantiateViewController(withIdentifier: Constants.storyBoard.addHotelDetailsStoryBoardID) as? AddHotelsViewController else {
            return AddHotelsViewController()
        }
        controller.hotelDataUpdateDelegate = self.viewModel
        return controller
       
    }
}

extension DashBoardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dataModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsTableViewCell.cellId,
                                                       for: indexPath) as? HotelDetailsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        guard let model = viewModel?.dataModel[indexPath.row]  else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.setUp(data: model)
        cell.edit.tag = indexPath.row
        cell.edit.addTarget(self, action: #selector(editDetails(_:)), for: .touchUpInside)
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(deleteDetails(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DashBoardViewController: ReloadTableViewUpdate {
    func noRecordView() {
        let label = UILabel(frame: CGRect(x: 20,
                                          y: 0,
                                          width: UIScreen.main.bounds.width - 40,
                                          height: UIScreen.main.bounds.height - 100))
        label.text = Constants.noRecords
        label.numberOfLines = 0
        label.textColor = UIColor(named: Constants.Colors.textColor)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Neue", size: 20)
        emptyView.addSubview(label)
        self.view.addSubview(emptyView)
    }
    
    func updateTableViewData(indexPath: IndexPath) {
        self.emptyView.removeFromSuperview()
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func reloadTableView() {
        self.emptyView.removeFromSuperview()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

