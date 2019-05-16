//
//  ViewController.swift
//  KakaoApp
//
//  Created by 장공의 on 13/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit
import SnapKit

class GalleryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    private func addView() {
        let galleryCollectionView: UICollectionView = {
            let collectionViewLayout: UICollectionViewFlowLayout = {
                let layout = UICollectionViewFlowLayout()
                layout.itemSize = .init(width: 100, height: 100)
                return layout
            }()
            
            let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
            view.delegate = self
            view.dataSource = self
            view.backgroundColor = .clear
            view.register(GalleyImageCell.self, forCellWithReuseIdentifier: GelleryViewKey.imageCellIdentifier)
            return view
        }()
        
        view.addSubview(galleryCollectionView)
        
        galleryCollectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
  
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GelleryViewKey.imageCellIdentifier,
                                                      for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

enum GelleryViewKey {
    static let imageCellIdentifier = "cellIdentifier"
}
