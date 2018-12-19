//
//  AnimatedTabMenu.swift
//  animated-tab-menu
//
//  Created by Zhenwei Liu on 2018/12/19.
//
import UIKit
import SnapKit

open class AnimatedTabMenu: UIView {
    //MARK: private priority
    
    private var contentView: UIView!
    private var tabButtonsArray: [AnimateTabItem] = []
    private var titleArray: [String] = []
    private var currentSelectIndex: Int = 0
    private var scrollView : UIScrollView!
    open var selectBlock: ((UInt) -> Void)?
    open var normalFontSize: UIFont = UIFont.systemFont(ofSize: 10)
    open var selectFontSize: UIFont = UIFont.systemFont(ofSize: 20)
    open var normalTextColor: UIColor = UIColor.black
    open var selectTextColor: UIColor = UIColor.red
    open var animationInterval: TimeInterval = 0.3
    open var animatelineColor : UIColor = UIColor.black
    open var animatelineHeight : CGFloat = 1
    open var titleSpace : CGFloat = 10
    open var bottomLineColor : UIColor = UIColor.gray
    open var bottomLineHeight : CGFloat = 0.5
    private var animateBottomLine : UIView!
    open var contentInset : UIEdgeInsets = UIEdgeInsets.zero
    open var defaultSelectedIndex : Int = 0 {
        didSet {
            self.currentSelectIndex = defaultSelectedIndex
        }
    }
    //MARK: override method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addScrollView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addScrollView()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.addTabButtons()
        self.addConstraintForSubTabs()
        
    }
    private func addBottomLine() {
        let line = UIView()
        line.backgroundColor = self.bottomLineColor
        self.contentView.addSubview(line)
        line.snp.makeConstraints {[unowned self] (make) in
            make.left.right.width.equalTo(self)
            make.bottom.equalTo(self).offset(-self.bottomLineHeight)
            make.height.equalTo(self.bottomLineHeight)
        }
    }
    
    
    func testAddBottomLine() {
        animateBottomLine = UIView()
        animateBottomLine.backgroundColor = self.animatelineColor
        let selectedTabButton = self.tabButtonsArray[self.currentSelectIndex]
        self.contentView.addSubview(animateBottomLine)
        animateBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(selectedTabButton.frame.minX)
            make.bottom.equalTo(self.contentView).offset(-self.animatelineHeight)
            make.height.equalTo(self.animatelineHeight)
            make.width.equalTo(selectedTabButton.getWidth())
        }
    }
    
    func updateLineView(progress:CGFloat,currentBtn:AnimateTabItem,lastBtn:AnimateTabItem) {
        let x = (currentBtn.frame.origin.x - lastBtn.frame.origin.x) * progress + lastBtn.frame.origin.x
        let width = ( currentBtn.getWidth() - lastBtn.getWidth() ) * progress + lastBtn.getWidth()
        animateBottomLine.snp.updateConstraints { (make) in
            make.left.equalTo(self.contentView).offset(x)
            make.width.equalTo(width)
        }
        self.contentView.layoutIfNeeded()
    }
    //MARK: public config method
    
    /// 设置动画时间
    ///
    /// - Parameter interval: 时间间隔
    public func setAnimationInterval(interval: TimeInterval) {
        self.animationInterval = interval
        self.layoutSubviews()
    }
    
    /// 设置未选中状态下的颜色
    ///
    /// - Parameter color: 色值
    public func setNormalTextColor(color: UIColor) {
        self.normalTextColor = color
        self.layoutSubviews()
    }
    
    /// 设置选中状态下的颜色
    ///
    /// - Parameter color
    public func setSelectTextColor(color: UIColor) {
        self.selectTextColor = color
        self.layoutSubviews()
    }
    
    /// 设置选中字号
    ///
    /// - Parameter fontSize
    public func setSelectFontFize(fontSize: UIFont) {
        self.selectFontSize = fontSize;
        self.layoutSubviews()
    }
    public func setSelectedSegmentIndex(_ index: UInt,progress:CGFloat) {
        if self.currentSelectIndex != index {
            if progress == 1 {
                UIView.animate(withDuration: self.animationInterval) {
                    self.updateUI(index: Int(index), progress: progress)
                }
            } else {
                self.updateUI(index: Int(index), progress: progress)
            }
        }
    }
    /// 设置常规字号
    ///
    /// - Parameter fontSize
    public func setNormalFontFize(fontSize: UIFont) {
        self.normalFontSize = fontSize
        self.layoutSubviews()
    }
    
    /// 设置Tab标题
    ///
    /// - Parameter titles
    public func setTitleArray(titles:  [String]) {
        self.titleArray = titles
        self.layoutSubviews()
    }
    
    //MARK: private add subviews method
    
    private func addScrollView() {
        scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {[unowned self] (make) in
            make.edges.equalTo(self)
        }
        self.contentView = UIView()
        scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        self.testAddBottomLine()
        addBottomLine()
    }
    
    private func addTabButtons() {
        self.tabButtonsArray.removeAll()
        for index in 0..<self.titleArray.count {
            let tab = AnimateTabItem()
            tab.setSelectedTitleFont(self.selectFontSize)
            tab.setNormalTitleFont(self.normalFontSize)
            tab.setSelectedTitleColor(self.selectTextColor)
            tab.setNormalTitleColor(self.normalTextColor)
            tab.tag = index;
            tab.setTitle(self.titleArray[index])
            tab.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
            self.tabButtonsArray.append(tab)
        }
    }
    
    private func addConstraintForSubTabs() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        var leftConstraint = self.contentView.snp.left
        for index in 0..<self.tabButtonsArray.count {
            let tabButton = self.tabButtonsArray[index]
            self.contentView.addSubview(tabButton)
            self.addConstraintForButton(button: tabButton, leftSlibling: leftConstraint)
            leftConstraint = tabButton.snp.right
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.right.equalTo(leftConstraint)
        }
        
        
    }
    
    private func addConstraintForButton(button: AnimateTabItem, leftSlibling:ConstraintItem) {
        let leftOffset = (button.tag == 0) ? 0 : titleSpace
        if self.currentSelectIndex == button.tag {
            button.setSelected(progress: 1)
        }
        button.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(leftSlibling).offset(leftOffset)
            make.bottom.equalTo(0);
            make.height.equalTo(self.contentView.snp.height);
        }
        
    }
    
    public func updateUI(index: Int,progress:CGFloat) {
        if index == self.currentSelectIndex {
            return;
        }
        let currentButton = self.tabButtonsArray[index]
        let lastSelectButton = self.tabButtonsArray[self.currentSelectIndex]
        currentButton.setSelected(progress:progress)
        lastSelectButton.setSelected(progress: 1 - progress)
        if progress >= 1 {
            self.currentSelectIndex = index
        }
        self.layoutIfNeeded()
        self.updateLineView(progress: progress, currentBtn: currentButton,lastBtn: lastSelectButton)
        UIView.animate(withDuration: self.animationInterval) {
            
            if currentButton.frame.maxX - self.scrollView.contentOffset.x > self.frame.width
            {
                self.scrollView.setContentOffset(CGPoint(x:currentButton.frame.origin.x + currentButton.frame.width - self.frame.width , y: self.scrollView.contentOffset.y
                ), animated: true)
                
            }
            if currentButton.frame.origin.x - self.scrollView.contentOffset.x  < 0 {
                self.scrollView.setContentOffset(CGPoint(x:currentButton.frame.origin.x
                    , y: self.scrollView.contentOffset.y
                ), animated: true)
            }
            
        }
    }
    
    //MARK: event method
    
    @objc private func tapButton(sender:AnimateTabItem) {
        if self.selectBlock != nil {
            self.selectBlock!(UInt(sender.tag))
        }
        UIView.animate(withDuration: self.animationInterval) {
            self.updateUI(index: sender.tag, progress: 1)
        }
    }
}
