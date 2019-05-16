//
//  GalleyImageCell.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit
import SnapKit
import ImageIO

final class GalleyImageCell: UICollectionViewCell {
    
    private static let dummyImage = UIImage(named: "loading_image")
    
    private let galleyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = GalleyImageCell.dummyImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var currentImageUrl: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL) {
        currentImageUrl = url
        galleyImageView.image = GalleyImageCell.dummyImage
        DispatchQueue.global().async {
            let image = DownSamplingService.share.donwload(with: url)
            
            DispatchQueue.main.async {
                guard self.currentImageUrl! == url else {
                    return
                }
                self.galleyImageView.image = image
            }
        }
    }
    
    private func addView() {
        addSubview(galleyImageView)
        galleyImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self)
        }
    }
}
