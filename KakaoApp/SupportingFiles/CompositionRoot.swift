//
//  CompositionRoot.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        
        defaultContainer.register(GalleyImagesService.self) { container in
            return GettyImageService()
        }
        
        defaultContainer.register(GalleyViewReactor.self) { container in
            return GalleyViewReactor(galleyImageService: container.resolve(GalleyImagesService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(GalleryViewController.self) { container, resolver in
            resolver.reactor = container.resolve(GalleyViewReactor.self)!
        }
        
    }
}
