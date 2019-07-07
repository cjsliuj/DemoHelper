//
//  UIView+Ex.swift
//  TestApp
//
//  Created by 刘杰 on 2019/7/7.
//  Copyright © 2019 jerry. All rights reserved.
//

import Foundation
import UIKit
public extension UIView{
    @objc func dhShowDropDownMenu(titles: [String],
                                       onSelectedHandler: ((_ index: Int, _ item: String)->Void)?){
        let dropDown = DropDown()
        objc_setAssociatedObject(self, "dropDown", dropDown, .OBJC_ASSOCIATION_RETAIN)
        dropDown.anchorView = self // UIView or UIBarButtonItem
        dropDown.dataSource = titles
        dropDown.selectionAction = {(index: Int, item: String) in
            onSelectedHandler?(index, item)
        }
        dropDown.show()
    }
}
