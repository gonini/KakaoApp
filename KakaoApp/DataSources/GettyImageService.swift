//
//  GettyImagesService.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import Kanna

struct GettyImageService: GalleyImagesService {
    
    private static let baseUrl = "https://www.gettyimagesgallery.com/collection/sasha/"
    
    func observeImages() -> Observable<[URL]> {
        return RxAlamofire
            .requestString(.get, GettyImageService.baseUrl)
            .map { $0.1 }
            .map { self.parseGettyImage(response: $0) }
         .asObservable()
        
    }
    
    private func parseGettyImage(response: String) -> [URL] {
        let html = try? HTML(html: response, encoding: .utf8)
        
        guard let images = html?.xpath("//img") else {
            fatalError()
        }
        
        return images
            .map { $0["data-src"] }
            .filter { $0 != nil }
            .map { URL(string: $0!) }
            .compactMap { $0 }
    }
}
