//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by SUNG HAO LIN on 2021/10/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

  func test_init_doesNotRequestDataFromURL() {
    let url = URL(string: "https://a-url.com")!
    let client = HTTPClientSpy()
    _ = RemoteFeedLoader(url: url, client: client)

    XCTAssertNil(client.requestURL)
  }

  func test_load_requestDataFromURL() {
    let url = URL(string: "https://a-url.com")!
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)

    sut.load()

    XCTAssertEqual(client.requestURL, url)
  }

  // MARK: - Helpers

  private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
  }

  private class HTTPClientSpy: HTTPClient {
    var requestURL: URL?

    func get(from url: URL) {
      requestURL = url
    }
  }
}
