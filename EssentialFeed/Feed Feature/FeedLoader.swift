//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by SUNG HAO LIN on 2021/10/19.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
  case success([FeedItem])
  case failure(Error)
}

// 當 Error 有服從 Equatable 時，才可以使用 extensio LoadFeedResult methods
extension LoadFeedResult: Equatable where Error: Equatable {}

protocol FeedLoader {
  associatedtype Error: Swift.Error

  func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
