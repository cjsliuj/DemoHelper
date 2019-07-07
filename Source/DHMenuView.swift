//
//  DHMenuView.swift
//  DemoHelper
//
//  Created by 刘杰 on 2019/7/7.
//  Copyright © 2019 jerry. All rights reserved.
//

import Foundation
import SnapKit
@objc public class DHMenuSection: NSObject {
    let title: String
    let rows: [DHMenuRow]
    @objc public init(title: String, rows: [DHMenuRow]) {
        self.title = title
        self.rows = rows
    }
}
@objc public class DHMenuRow: NSObject {
    @objc public let title: String
    let action: ((_ rowView: UIView)->Void)?
    @objc public init(title: String, action: ((_ rowView: UIView)->Void)?){
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
    public func internalInit(){
        self.backgroundColor = UIColor.white
        _tbv = UITableView.init(frame: UIScreen.main.bounds, style: .grouped)
        
        _tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        _tbv.delegate = self
        _tbv.dataSource = self
        self.addSubview(_tbv)
        let v = UIView()
        v.backgroundColor = UIColor.white
        _tbv.backgroundView = v
        _tbv.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource[section]
        let v = UIView()
        v.backgroundColor = UIColor.gray
        let lb = UILabel()
        lb.text = section.title
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        v.addSubview(lb)
        lb.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
        }
        return v
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
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
        row.action?(tableView.cellForRow(at: indexPath)!)
        delegate?.dhMenuViewOnClickedRow?(menuView: self, row: row, rowView: tableView.cellForRow(at: indexPath)!)
    }
}
