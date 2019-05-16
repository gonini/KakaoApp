//
//  GalleyImageCell.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit
import SnapKit

class GalleyImageCell: UICollectionViewCell {
    
    private let galleyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubview(galleyImage)
        galleyImage.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self)
        }
    }
    
}
