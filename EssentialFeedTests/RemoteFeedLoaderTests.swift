//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by SUNG HAO LIN on 2021/10/22.
//

import XCTest

class RemoteFeedLoader {

}

class HTTPClient {
  var requestURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

  func test_init_doesNotRequestDataFromURL() {
    let client = HTTPClient()
    _ = RemoteFeedLoader()

    XCTAssertNil(client.requestURL)
  }
}
