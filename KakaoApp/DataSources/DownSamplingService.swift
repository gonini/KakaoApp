//
//  DownSamplingService.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit

final class DownSamplingService: ImageDownloadService {
    public static let share = DownSamplingService()
    private static let maxSamplingSize = 100
    private let cache = BasicInMemoryImageCache()
    
    init() { }
    
    func donwload(with: URL) -> UIImage {
        
        let key = with as NSURL
        
        guard let cachedImage = cache.getValue(forKey: key) else {
            let imageSource = CGImageSourceCreateWithURL(with as CFURL, nil)!
            
            let options: [NSString: Any] = [
                kCGImageSourceThumbnailMaxPixelSize: DownSamplingService.maxSamplingSize,
                kCGImageSourceCreateThumbnailFromImageAlways: true
            ]
            
            let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)!
            
            let ret = UIImage(cgImage: scaledImage)
            
            cache.setValue(.init(data: ret), forKey: key)
            
            return ret
        }
        
        return cachedImage.data
    }
}
