//
//  GalleryViewReactor.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import Foundation
import ReactorKit

final class GalleyViewReactor: Reactor {
    
    let initialState: State = .init(isbusy: false,
                                    galleyContents: [])
    
    private let galleyImageService: GalleyImagesService
    
    init(galleyImageService: GalleyImagesService) {
        self.galleyImageService = galleyImageService
    }
    
    enum Action {
        
    }
    
    struct State {
        var isbusy: Bool
        var galleyContents: [URL]
    }
}
