//
//  GettyImageServiceTests.swift
//  KakaoAppTests
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

@testable import KakaoApp

class GettyImageServiceTests: XCTestCase {
    
    func testObserveImages() {
        let service = GettyImageService()
        let expected = URL(string: "https://www.gettyimagesgallery.com/wp-content/uploads/2018/12/GettyImages-3360485-1024x802.jpg")
        
        XCTAssertEqual(try service.requestImages().toBlocking().first()?.first, expected)
    }
}
