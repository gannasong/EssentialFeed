//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by SUNG HAO LIN on 2021/10/23.
//

import Foundation

internal class FeedItemMapper {
  private struct Root: Decodable {
    let items: [Item]

    var feed: [FeedItem] {
      return items.map { $0.item }
    }
  }

  // Raw data decode to Item then map to FeedItem , avoid leak decode key to API module.
  // Decouple the Feed Feature module from API implementation details
  private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL

    var item: FeedItem {
      return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
  }

  private static var OK_200: Int { return 200 }

  internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      return .failure(RemoteFeedLoader.Error.invalidData)
    }

    return .success(root.feed)
  }
}

