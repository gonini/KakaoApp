//
//  GalleyImageService.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import Foundation
import RxSwift

protocol GalleyImagesService {
    
    func observeImages() -> Observable<[URL]>
    func requestImages()
}
