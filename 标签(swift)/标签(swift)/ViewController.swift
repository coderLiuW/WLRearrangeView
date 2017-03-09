//
//  ViewController.swift
//  标签(swift)
//
//  Created by administrator on 2017/3/7.
//  Copyright © 2017年 WL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectedArr = ["推荐","河北","财经","娱乐","体育","社会","NBA","视频","汽车","图片","科技","军事","国际","数码","星座","电影","时尚","文化","游戏","教育","动漫","政务","纪录片","房产","佛学","股票","理财"]
    
    var recommendArr = ["有声","家居","电竞","美容","电视剧","搏击","健康","摄影","生活","旅游","韩流","探索","综艺","美食","育儿"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func buttonClick(_ sender: Any) {
        
        let channelVC = ChannelViewController(a: selectedArr, b: recommendArr)
        channelVC.switchoverCallback = {
            
            (selectedArr, recommendArr, index) -> () in
            
            self.navigationItem.title = selectedArr[index]
            self.selectedArr = selectedArr
            self.recommendArr = recommendArr
            
        }
        navigationController?.pushViewController(channelVC, animated: true)
        
    }


}

