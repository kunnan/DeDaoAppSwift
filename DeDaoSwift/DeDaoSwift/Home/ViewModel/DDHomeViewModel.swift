//
//  DDHomeViewModel.swift
//  DeDaoSwift
//
//  Created by niuting on 2017/3/7.
//  Copyright © 2017年 niuNaruto. All rights reserved.
//

import UIKit
import ObjectMapper


public enum structureType : String {
    
    case structureTypeCategory = "category"
    case structureTypeFreecolumn = "freecolumn"
    case structureTypeLive = "live"
    case structureTypeFreeAudio = "freeAudio"
    case structureTypeColumn = "column"
    case structureTypeStorytell = "storytell"
    case structureTypeMagazine = "magazine"
    case structureTypeDataMiningAduioOrBook = "dataMiningAduioOrBook"
    case structureTypeNew = "new"
    case structureTypeSubject = "subject"
}
class DDHomeViewModel: DDBaseTableViewModel {

    
    var dataModel  = Mapper<DDHomeDataModel>().map(JSON : ["":""])

    lazy var typeModelArray = Array<DDHomePositionStructureModel>()

    
    override func refreshData(_ array: (Array<Any>) -> (), _ error : ((String) -> ())) {
        
      
        let homeJsonDic = DDTool.getDictionaryWithPatch(fileName:"homeJsonData.json") as? Dictionary<String, Any>
        let model = Mapper<DDHomeModel>().map(JSON: homeJsonDic ?? ["":""])
        dataModel = model?.c?.data
        
        let typeDic = DDTool.getDictionaryWithPatch(fileName: "homePositionData.json") as? Dictionary<String, Any>
        let typeModel = Mapper<DDHomePositionModel>().map(JSON: typeDic ?? ["":""])
        if let tempArray = typeModel?.c?.structure {
            typeModelArray = tempArray
            array(typeModelArray)
        }else{
            error("数据❎")
        }
    }
    
    
}


// MARK: - tabelView的相关方法
extension DDHomeViewModel{
    
    override func createViewModelWithModel(_ model: Any?, _ cellClass: AnyClass?) -> DDBaseTableViewModel {
        return DDHomeViewModel.init(model, cellClass)
    }
    
    override func dataAtIndexPath(_ indexPath: IndexPath) -> DDBaseTableViewModel {
        
        let section = indexPath.section
        let row = indexPath.row
        let type = typeModelArray[section].type

        
        if type == structureType.structureTypeCategory.rawValue {
            if row == 0 {
                return DDBaseTableViewModel.init(dataModel?.slider, DDHomeBannerCell.classForCoder())
            }else{
                return DDBaseTableViewModel.init(nil, DDHomeIndexCell.classForCoder())
            }
        }else if type == structureType.structureTypeFreecolumn.rawValue{
            return DDBaseTableViewModel.init(dataModel?.freecolumn, DDHomeFreeColumnCell.classForCoder())
        }else if type == structureType.structureTypeLive.rawValue{
            return DDBaseTableViewModel.init(dataModel?.live?.data, DDHomeLiveCell.classForCoder())
        }else if type == structureType.structureTypeFreeAudio.rawValue{
            return DDBaseTableViewModel.init(dataModel?.freeAudio, DDHomeFreeAudioCell.classForCoder())
        }else if type == structureType.structureTypeColumn.rawValue{
            if indexPath.row >= 3  {
                if let count =  dataModel?.column?.count {
                    return DDBaseTableViewModel.init("查看全部\(count)个", DDHomeShowMoreCell.classForCoder())
                }
                
            }
            if let list = dataModel?.column?.list {
                return DDBaseTableViewModel.init(list[row], DDHomeColumnCell.classForCoder())
            }
        }else if type == structureType.structureTypeMagazine.rawValue{
            return DDBaseTableViewModel.init(dataModel?.magazine?.data, DDHomeMagazineCell.classForCoder())
        }else if type == structureType.structureTypeDataMiningAduioOrBook.rawValue{
            return DDBaseTableViewModel.init(dataModel?.dataMiningAduioOrBook, DDHomeHotAndGustCell.classForCoder())
        }else if type == structureType.structureTypeNew.rawValue{
            return DDBaseTableViewModel.init(dataModel?.new, DDHomeHotAndGustCell.classForCoder())
        }else if type == structureType.structureTypeSubject.rawValue{
            return DDBaseTableViewModel.init(dataModel?.subject, DDHomeSubjectCell.classForCoder())
        }else if type == structureType.structureTypeStorytell.rawValue{
            return DDBaseTableViewModel.init(dataModel?.storytell?.data, DDHomeStorytellCell.classForCoder())
        }

        return DDBaseTableViewModel.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return typeModelArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let type = typeModelArray[section].type
        if type == structureType.structureTypeCategory.rawValue {
            return 2
        }else if type == structureType.structureTypeColumn.rawValue {
            return 3 + 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let type = typeModelArray[section].type
        guard currentShowHeadViewType(type) else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: DDHomeTableHeadView.cellIdentifier()) as! DDHomeTableHeadView
            view.setHeadFootViewModel([dataModel ?? "",type] as [Any])
            return view
        }
        return nil

    }
    
    func currentShowHeadViewType(_ type : String) -> Bool {
        guard
            type == structureType.structureTypeFreecolumn.rawValue ||
            type == structureType.structureTypeMagazine.rawValue ||
            type == structureType.structureTypeCategory.rawValue ||
            type == structureType.structureTypeSubject.rawValue else {
            
                return false
        }
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let type = typeModelArray[section].type
        guard currentShowHeadViewType(type) else {  return 44 }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}

