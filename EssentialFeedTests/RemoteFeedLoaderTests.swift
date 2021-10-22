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

    XCTAssertTrue(client.requestedURLs.isEmpty)
  }

  func test_load_requestsDataFromURL() {
    let url = URL(string: "https://a-url.com")!
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)

    sut.load()

    XCTAssertEqual(client.requestedURLs, [url])
  }

  func test_loadTwice_requestsDataFromURLTwice() {
    let url = URL(string: "https://a-given-url.com")!
    let (sut, client) = makeSUT(url: url)

    sut.load()
    sut.load()

    XCTAssertEqual(client.requestedURLs, [url, url])
  }

  func test_load_deliversErrorOnClientError() {
    // Arrange:
    // Given the sut and its HTTP client spy.
    let (sut, client) = makeSUT()

    // Act
    // When we tell the sut to load and we complete the client's HTTP request with an error.
    var capturedErrors = [RemoteFeedLoader.Error]()
    sut.load { capturedErrors.append($0) }

    let clientError = NSError(domain: "Test", code: 0)
    client.completions[0](clientError)
    // Assert
    // Then we expect the captured load error to be a connectivity error.
    XCTAssertEqual(capturedErrors, [.connectivity])
  }

  // MARK: - Helpers

  private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
  }

  private class HTTPClientSpy: HTTPClient {
    var requestedURLs = [URL]()
    var completions = [(Error) -> Void]()

    func get(from url: URL, completion: @escaping (Error) -> Void) {
      completions.append(completion)
      requestedURLs.append(url)
    }
  }
}
