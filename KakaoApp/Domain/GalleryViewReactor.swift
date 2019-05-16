//
//  GalleryViewReactor.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class GalleyViewReactor: Reactor {
    
    let initialState: State = .init(isbusy: false,
                                    galleyContents: [])
    
    private let galleyImageService: GalleyImagesService
    
    init(galleyImageService: GalleyImagesService) {
        self.galleyImageService = galleyImageService
    }
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case loadGalleyImage
        case galleryImageLoaded(with: [URL])
    }
   
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let galleyImageObservable = galleyImageService
            .observeImages()
            .map(Mutation.galleryImageLoaded)
        
        return .merge(mutation, galleyImageObservable)
    }
   
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .viewWillAppear:
                return .just(.loadGalleyImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadGalleyImage:
            newState.isbusy = true
            galleyImageService.requestImages()
            return newState
            
        case let .galleryImageLoaded(with):
            newState.isbusy = false
            newState.galleyContents = with
            return newState
        }
    }
    
    struct State {
        var isbusy: Bool
        var galleyContents: [URL]
    }
}
