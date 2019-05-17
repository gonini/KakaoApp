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
                layout.itemSize = .init(width: 150, height: 150)
                return layout
            }()
            
            let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
            view.delegate = self
            view.dataSource = self
            view.prefetchDataSource = self
            view.backgroundColor = .clear
            view.register(GalleyImageCell.self, forCellWithReuseIdentifier: GelleryViewKey.imageCellIdentifier)
            return view
        }()
        
        view.addSubview(galleryCollectionView)
        
        galleryCollectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func resolveGalleyImageCell(_ collectionView: UICollectionView,
                                        cellForItemAt indexPath: IndexPath) -> GalleyImageCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GelleryViewKey.imageCellIdentifier,
                                                      for: indexPath)
        
        guard let galleyImageCell = cell as? GalleyImageCell else {
            fatalError()
        }
        
        return galleyImageCell
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return galleyContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resolveGalleyImageCell(collectionView, cellForItemAt: indexPath)
        cell.setImage(url: galleyContents[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let cell = resolveGalleyImageCell(collectionView, cellForItemAt: indexPath)
            cell.setImage(url: galleyContents[indexPath.row])
        }
    }
}

extension GalleryViewController: StoryboardView {
  
    func bind(reactor: GalleyViewReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
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
