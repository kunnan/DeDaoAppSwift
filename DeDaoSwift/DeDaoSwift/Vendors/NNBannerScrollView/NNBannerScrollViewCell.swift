//
//  NNBannerScrollViewCell.swift
//  NNBannerScrollView
//
//  Created by niuting on 2017/3/8.
//  Copyright © 2017年 niuNaruto. All rights reserved.
//

import UIKit

class NNBannerScrollViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(imageView)
        imageView.frame = self.bounds
        
    }
    
}
