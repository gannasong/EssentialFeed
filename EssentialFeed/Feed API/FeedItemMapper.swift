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

  internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
    guard response.statusCode == OK_200 else {
      throw RemoteFeedLoader.Error.invalidData
    }

    let root = try JSONDecoder().decode(Root.self, from: data)
    return root.items.map { $0.item }
  }
}

