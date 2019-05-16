//
//  ViewController.swift
//  KakaoApp
//
//  Created by 장공의 on 13/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxViewController

final class GalleryViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    private var galleryCollectionView: UICollectionView!
    private var galleyContents = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    private func addView() {
        galleryCollectionView = {
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
        return galleyContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GelleryViewKey.imageCellIdentifier,
                                                      for: indexPath)
        
        guard let galleyImageCell = cell as? GalleyImageCell else {
            return cell
        }
        
        galleyImageCell.setImage(url: galleyContents[indexPath.row])
        
        return galleyImageCell
    }
}

extension GalleryViewController: StoryboardView {
  
    func bind(reactor: GalleyViewReactor) {
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.galleyContents }
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.galleyContents = $0
                self.galleryCollectionView?.reloadData()
            }).disposed(by: disposeBag)
    }
}

enum GelleryViewKey {
    static let imageCellIdentifier = "cellIdentifier"
}
