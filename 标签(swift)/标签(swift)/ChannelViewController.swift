//
//  ChannelViewController.swift
//  标签(swift)
//
//  Created by administrator on 2017/3/7.
//  Copyright © 2017年 WL. All rights reserved.
//

import UIKit


private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

private let ChannelViewCellIdentifier = "ChannelViewCellIdentifier"
private let ChannelViewHeaderIdentifier = "ChannelViewHeaderIdentifier"

let itemW: CGFloat = (SCREEN_WIDTH - 100) * 0.25

class ChannelViewController: UIViewController {

    var switchoverCallback: ((_ selectedArr: [String], _ recommendArr: [String], _ index: Int) -> ())?
    
    var headerArr = [["切换频道","点击添加更多频道"],["长按拖动排序","点击添加更多频道"]]
    var selectedArr = ["推荐","河北","财经","娱乐","体育","社会","NBA","视频","汽车","图片","科技","军事","国际","数码","星座","电影","时尚","文化","游戏","教育","动漫","政务","纪录片","房产","佛学","股票","理财"]

    var recommendArr = ["有声","家居","电竞","美容","电视剧","搏击","健康","摄影","生活","旅游","韩流","探索","综艺","美食","育儿"]
    
    var isEdite = false
    
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?
    
    
    init(a:[String], b:[String]) {
        selectedArr = a
        recommendArr = b
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载collectionView
    private lazy var collectionView: UICollectionView = {
        
        
        let clv = UICollectionView(frame: self.view.frame, collectionViewLayout: ChannelViewLayout())
        clv.backgroundColor = UIColor.white
        clv.delegate = self
        clv.dataSource = self
        clv.register(ChannelViewCell.self, forCellWithReuseIdentifier: ChannelViewCellIdentifier)
        clv.register(ChannelHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChannelViewHeaderIdentifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        clv.addGestureRecognizer(longPress)
        
        return clv
    }()
    
    private lazy var dragingItem: ChannelViewCell = {
       
        let cell = ChannelViewCell(frame: CGRect(x: 0, y: 0, width: itemW, height: itemW * 0.5))
        cell.isHidden = true
        return cell
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "频道管理"
        view.addSubview(collectionView)
        collectionView.addSubview(dragingItem)
            }
    
    //MARK: - 长按动作
    func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        
        if !isEdite {
            
            isEdite = !isEdite
            collectionView.reloadData()
            return
        }
        let point = tap.location(in: collectionView)
        
        switch tap.state {
            case UIGestureRecognizerState.began:
                dragBegan(point: point)
            case UIGestureRecognizerState.changed:
                drageChanged(point: point)
            case UIGestureRecognizerState.ended:
                drageEnded(point: point)
            case UIGestureRecognizerState.cancelled:
                drageEnded(point: point)
            default: break
            
        }
        
    }

    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        
        
        
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0
        {return}
        
        let item = collectionView.cellForItem(at: indexPath!) as? ChannelViewCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.text = item!.text
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath || targetIndexPath?.item == 0 {return}
        // 更新数据
        let obj = selectedArr[indexPath!.item]
        selectedArr.remove(at: indexPath!.row)
        selectedArr.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        let endCell = collectionView.cellForItem(at: indexPath!)
        
        UIView.animate(withDuration: 0.25, animations: {
        
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
            
        }, completion: {
        
            (finish) -> () in
            
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
            
        })
        
    }
    



}

//MARK: - UICollectionViewDelegate 方法
extension ChannelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? selectedArr.count : recommendArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelViewCellIdentifier, for: indexPath) as! ChannelViewCell
        
        cell.text = indexPath.section == 0 ? selectedArr[indexPath.item] : recommendArr[indexPath.item]
        cell.edite = (indexPath.section == 0 && indexPath.item == 0) ? false : isEdite
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if indexPath.section > 0 {
            
            // 更新数据
            let obj = recommendArr[indexPath.item]
            recommendArr.remove(at: indexPath.item)
            selectedArr.append(obj)
            collectionView.moveItem(at: indexPath, to: NSIndexPath(item: selectedArr.count - 1, section: 0) as IndexPath)
            
        } else {
            
            if isEdite {
                
                if indexPath.item == 0 {return}
                // 更新数据
                let obj = selectedArr[indexPath.item]
                selectedArr.remove(at: indexPath.item)
                recommendArr.insert(obj, at: 0)
                collectionView.moveItem(at: indexPath, to: NSIndexPath(item: 0, section: 1) as IndexPath)
                
            } else {
                
                if switchoverCallback != nil {
                    
                    switchoverCallback!(selectedArr, recommendArr, indexPath.item)
                    _ = navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChannelViewHeaderIdentifier, for: indexPath) as! ChannelHeaderView
        header.text = isEdite ? headerArr[1][indexPath.section] : headerArr[0][indexPath.section]
        header.button.isSelected = isEdite
        if indexPath.section > 0 {header.button.isHidden = true} else {header.button.isHidden = false}
        
        
        header.clickCallback = {[weak self] in
            
            self?.isEdite = !(self?.isEdite)!
            collectionView.reloadData()
            
        }
        
        return header
        
    }
    
}


//MARK: - 自定义cell
class ChannelViewCell: UICollectionViewCell {
    
    var edite = true {
        didSet {
            
            imageView.isHidden = !edite
        }
    }
    
    var text: String? {
        
        didSet {
            
            label.text = text
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        contentView.addSubview(label)
        label.addSubview(imageView)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    private lazy var label: UILabel = {
        
        let label = UILabel(frame: self.bounds)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var imageView: UIImageView = {
       
        let image = UIImageView(frame: CGRect(x: 2, y: 2, width: 10, height: 10))
        image.image = UIImage(named: "close")
        image.isHidden = true
        return image
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 自定义头视图
class ChannelHeaderView: UICollectionReusableView {
    
    var clickCallback: (() -> ())?
    
    var text: String? {
        
        didSet {
            
            label.text = text
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(label)
        addSubview(button)
        backgroundColor = UIColor.groupTableViewBackground
    }
    
    func buttonClick() {
        
        if (clickCallback != nil) { clickCallback!() }
    }
    
    
    private lazy var label: UILabel = {
        
        let label = UILabel(frame: self.bounds)
        label.frame.origin.x = 20
        return label
    }()
    
    lazy var button: UIButton = {
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("编辑", for: .normal)
        btn.setTitle("完成", for: .selected)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.frame = CGRect(x: SCREEN_WIDTH - 80, y: 0, width: 80, height: self.frame.height)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return btn
        
    }()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 自定义布局属性
class ChannelViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 40)
        itemSize = CGSize(width: itemW, height: itemW * 0.5)
        minimumLineSpacing = 15
        minimumInteritemSpacing = 20
        sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
    }
    
}
