//
//  ImageCache.swift
//  KakaoApp
//
//  Created by 장공의 on 16/05/2019.
//  Copyright © 2019 gonini. All rights reserved.
//

import UIKit

public protocol Cacheable {
    associatedtype Key where Key: AnyObject
    associatedtype Value where Value: AnyObject
    
    var usagePriority: Int { get }
    
    func getValue(forKey key: Key) -> Value?
    func setValue(_ value: Value, forKey key: Key)
    func removeValue(forKey key: Key)
    func removeAll()
}

struct CacheStructure<Key: AnyObject, Value: AnyObject>: Cacheable {
    var usagePriority: Int
    
    private let _getValue: (_ key: Key) -> Value?
    private let _setValue: (_ value: Value, _ key: Key) -> Void
    private let _removeValue: (_ key: Key) -> Void
    private let _removeAll: () -> Void
    
    init<U: Cacheable>(_ cacheStrategy: U) where U.Key == Key, U.Value == Value {
        usagePriority = cacheStrategy.usagePriority
        _getValue = cacheStrategy.getValue
        _setValue = cacheStrategy.setValue
        _removeValue = cacheStrategy.removeValue
        _removeAll = cacheStrategy.removeAll
    }
    
    func getValue(forKey key: Key) -> Value? {
        return _getValue(key)
    }
    
    func setValue(_ value: Value, forKey key: Key) {
        _setValue(value, key)
    }
    
    func removeValue(forKey key: Key) {
        _removeValue(key)
    }
    
    func removeAll() {
        _removeAll()
    }
}

struct Freshness {
    let exprtDate: Date
    let cacheControl: CacheControl
    let lastModified: String
    
    func needUpdate() -> Bool {
        return isExpired() || cacheControl == .noCache
    }
    
    func isExpired() -> Bool {
        return Date() > exprtDate
    }
}

extension Freshness {
    static func empty() -> Freshness {
        return Freshness(exprtDate: .init(), cacheControl: .none, lastModified: "")
    }
}

class CacheForm<T> {
    let data: T
    let freshness: Freshness
    
    var isLatest: Bool {
        return !freshness.needUpdate()
    }
    
    var isExpired: Bool {
        return freshness.isExpired()
    }
    
    var lastModified: String {
        return freshness.lastModified
    }
    
    init(data: T) {
        self.data = data
        self.freshness = Freshness.empty()
    }
    
    init(data: T, freshness: Freshness) {
        self.data = data
        self.freshness = freshness
    }
}

enum CacheControl: CaseIterable {
    case sMaxAge
    case maxAge
    case onlyIfCache
    case noCache
    case noStore
    case none
    
    var originalString: String {
        get {
            switch self {
            case .sMaxAge:
                return "s-maxage"
            case .maxAge:
                return "max-age"
            case .onlyIfCache:
                return "only-if-cached"
            case .noCache:
                return "no-cache"
            case .noStore:
                return "no-store"
            default:
                return ""
            }
        }
    }
    
    var canCache: Bool {
        get {
            switch self {
            case .sMaxAge, .maxAge, .onlyIfCache, .noCache:
                return true
            default:
                return false
            }
        }
    }
}

class BasicInMemoryImageCache: Cacheable {
    private let cache = NSCache<NSURL, CacheForm<UIImage>>()
    
    var usagePriority: Int = 0
    
    func getValue(forKey key: NSURL) -> CacheForm<UIImage>? {
        return cache.object(forKey: key)
    }
    
    func setValue(_ value: CacheForm<UIImage>, forKey key: NSURL) {
        cache.setObject(value, forKey: key)
    }
    
    func removeValue(forKey key: NSURL) {
        cache.removeObject(forKey: key)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
