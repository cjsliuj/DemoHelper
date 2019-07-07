//
//  DHMenuView.swift
//  DemoHelper
//
//  Created by 刘杰 on 2019/7/7.
//  Copyright © 2019 jerry. All rights reserved.
//

import Foundation
//import SnapKit
@objc public class DHMenuSection: NSObject {
    let title: String
    var rows: [DHMenuRow]
    
    @objc public init(title: String, rows: [DHMenuRow]) {
        self.title = title
        self.rows = rows
    }
}
@objc public class DHMenuRow: NSObject {
    @objc public var title: String
    @objc public var tag: String = ""
    let action: ((_ menuView: DHMenuView, _ row: DHMenuRow, _ rowView: UIView)->Void)?
    @objc public init(title: String, action: ((_ menuView: DHMenuView, _ row: DHMenuRow, _ rowView: UIView)->Void)?){
        self.title = title
        self.action = action
    }
    
}
@objc public protocol DHMenuViewDelegate: class{
    @objc optional
    func dhMenuViewOnClickedRow(menuView: DHMenuView, row: DHMenuRow, rowView: UIView)
}
@objc public class DHMenuView: UIView,UITableViewDelegate,UITableViewDataSource{
    var _tbv: UITableView!
    @objc public weak var delegate: DHMenuViewDelegate?
    @objc public var dataSource: [DHMenuSection] = []{
        didSet{
            _tbv.reloadData()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.internalInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.internalInit()
    }
    @objc public func updateRow(_ destRow: DHMenuRow){
        if !dataSource.flatMap({return $0.rows}).contains(destRow) {
            assert(false, "不包含改row，无法更新")
        }
        var toReplaceSectionIdx: Int!
        var toReplaceRowIdx: Int!
        for (secIndex, sec) in dataSource.enumerated(){
            for (rowIndex, row) in sec.rows.enumerated(){
                if row == destRow{
                    toReplaceSectionIdx = secIndex
                    toReplaceRowIdx = rowIndex
                    break
                }
            }
        }
        dataSource[toReplaceSectionIdx].rows[toReplaceRowIdx] = destRow
        _tbv.reloadRows(at: [IndexPath(row: toReplaceRowIdx, section: toReplaceSectionIdx)], with: .none)
    }
    public func internalInit(){
        self.backgroundColor = UIColor.white
        _tbv = UITableView.init(frame: UIScreen.main.bounds, style: .grouped)
        _tbv.translatesAutoresizingMaskIntoConstraints = false
        _tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        _tbv.delegate = self
        _tbv.dataSource = self
        self.addSubview(_tbv)
        let v = UIView()
        v.backgroundColor = UIColor.white
        _tbv.backgroundView = v
        
        [NSLayoutConstraint.Attribute.leading,
        NSLayoutConstraint.Attribute.top,
        NSLayoutConstraint.Attribute.bottom,
        NSLayoutConstraint.Attribute.trailing].forEach { (att) in
            self.addConstraint(NSLayoutConstraint.init(item: _tbv,
                                                       attribute: att,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute:att,
                                                       multiplier: 1,
                                                       constant: 0))
        }
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource[section]
        let v = UIView()
        
        v.backgroundColor = UIColor(red:0.87, green:0.93, blue:1.00, alpha:1.00)
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = section.title
        lb.textColor = UIColor(red:1.00, green:0.58, blue:0.06, alpha:1.00)
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        v.addSubview(lb)
        v.addConstraint(NSLayoutConstraint.init(item: lb,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: v,
                                                attribute:.leading,
                                                multiplier: 1,
                                                constant: 10))

        v.addConstraint(NSLayoutConstraint.init(item: lb,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: v,
                                                attribute:.centerY,
                                                multiplier: 1,
                                                constant: 0))
        
        return v
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = dataSource[indexPath.section]
        let row = section.rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = dataSource[indexPath.section]
        let row = section.rows[indexPath.row]
        row.action?(self, row, tableView.cellForRow(at: indexPath)!)
        delegate?.dhMenuViewOnClickedRow?(menuView: self, row: row, rowView: tableView.cellForRow(at: indexPath)!)
    }
}
