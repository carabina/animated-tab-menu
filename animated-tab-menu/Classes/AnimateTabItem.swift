//
//  AnimateTabItem.swift
//  animated-tab-menu
//
//  Created by Zhenwei Liu on 2018/12/19.
//

import Foundation
import UIKit

open class AnimateTabItem: UIButton {
    private var normalTitleColor : UIColor = UIColor.black
    private var selectedTitleColor : UIColor = UIColor.orange
    private var normalTitleFont : UIFont = UIFont.systemFont(ofSize: 14)
    private var selectedTitleFont : UIFont = UIFont.boldSystemFont(ofSize: 16)
    private var title : String = ""
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    public func setNormalTitleColor(_ color : UIColor) {
        self.normalTitleColor = color
        self.setTitleColor(self.normalTitleColor, for: UIControl.State.normal)
    }
    public func setSelectedTitleColor(_ color : UIColor) {
        self.selectedTitleColor = color
        self.setTitleColor(self.selectedTitleColor, for: UIControl.State.selected)
    }
    public func setNormalTitleFont(_ font : UIFont) {
        self.normalTitleFont = font
    }
    public func setSelectedTitleFont(_ font : UIFont) {
        self.selectedTitleFont = font
    }
    public func setTitle(_ title : String) {
        self.title = title
        self.setTitle(self.title, for: UIControl.State.normal)
        self.setTitleColor(self.normalTitleColor, for: UIControl.State.normal)
        self.titleLabel?.font = self.normalTitleFont
        self.contentVerticalAlignment = .bottom
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        let height = (self.frame.height - self.normalTitleFont.lineHeight)/2
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom:height, right: 0)
    }
    public func setSelected(progress : CGFloat) {
        var currentProgress = progress
        if progress >= 1 {
            currentProgress = 1
            self.isSelected = true
        }
        if progress <= 0 {
            self.isSelected = false
            currentProgress = 0
        }
        let fontSize = (self.selectedTitleFont.pointSize - self.normalTitleFont.pointSize) * currentProgress + self.normalTitleFont.pointSize
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    public func getWidth() -> CGFloat {
        let constraintRect = CGSize()
        let boundingBox = self.title.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: self.titleLabel?.font ?? self.normalTitleFont], context: nil)
        return boundingBox.size.width
    }
    
}
