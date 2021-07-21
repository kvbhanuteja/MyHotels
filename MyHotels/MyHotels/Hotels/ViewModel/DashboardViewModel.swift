//
//  DashboardViewModel.swift
//  MyHotels
//
//  Created by Ajay Gupta on 21/07/21.
//

import UIKit

protocol ReloadTableViewUpdate {
    func updateTableViewData(indexPath: IndexPath)
    func reloadTableView()
    func noRecordView()
}

protocol HotelDataUpdateDelegate {
    func updateTheData(obj: HotelDetails, rowIndex: Int)
    func addData(obj: HotelDetails)
}

class DashboardViewModel {
    
    var dataModel = [HotelDetails]()
    
    var reloadTableViewDelegate: ReloadTableViewUpdate
    
    init(reloadTableViewDelegate: ReloadTableViewUpdate) {
        self.reloadTableViewDelegate = reloadTableViewDelegate
        if dataModel.count <= 0 {
            self.reloadTableViewDelegate.noRecordView()
        }
    }
    
    func deleteData(index: Int) {
        self.dataModel.remove(at: index)
        self.reloadTableViewDelegate.reloadTableView()
        if self.dataModel.count <= 0 {
            self.reloadTableViewDelegate.noRecordView()
        }
    }
    
}

extension DashboardViewModel: HotelDataUpdateDelegate {
    func updateTheData(obj: HotelDetails, rowIndex: Int) {
        let place = self.dataModel.firstIndex { hotel in
            hotel.id == obj.id
        }
        if let index = place, index <= self.dataModel.count {
            self.dataModel[index] = obj
        }
        if dataModel.count <= 0 {
            self.reloadTableViewDelegate.noRecordView()
        } else {
            self.reloadTableViewDelegate.updateTableViewData(indexPath: IndexPath(row: rowIndex, section: 0))
        }
    }
    
    func addData(obj: HotelDetails) {
        self.dataModel.append(obj)
        self.reloadTableViewDelegate.reloadTableView()
    }    
}
