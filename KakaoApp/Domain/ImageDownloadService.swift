//
//  ImageDownloadService.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit
import ImageIO

protocol ImageDownloadService {
    
    func donwload(with: URL) -> UIImage
}
