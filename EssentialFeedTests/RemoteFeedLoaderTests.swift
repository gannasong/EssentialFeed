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

    sut.load { _ in }

    XCTAssertEqual(client.requestedURLs, [url])
  }

  func test_loadTwice_requestsDataFromURLTwice() {
    let url = URL(string: "https://a-given-url.com")!
    let (sut, client) = makeSUT(url: url)

    sut.load { _ in }
    sut.load { _ in }

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
    client.complete(with: clientError)
    // Assert
    // Then we expect the captured load error to be a connectivity error.
    XCTAssertEqual(capturedErrors, [.connectivity])
  }

  func test_load_deliversErrorOnNon200HTTPResponse() {
    let (sut, client) = makeSUT()

    let samples = [199, 201, 300, 400, 500]

    samples.enumerated().forEach { index, code in
      var capturedErrors = [RemoteFeedLoader.Error]()
      sut.load { capturedErrors.append($0) }

      client.complete(withStatusCode: code, at: index)

      XCTAssertEqual(capturedErrors, [.invalidData])
    }
  }

  // MARK: - Helpers

  private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
  }

  private class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()

    var requestedURLs: [URL] {
      return messages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
      messages.append((url, completion))
    }

    /*
     - 把 Complete error 封裝，取代 client.completions[0](clientError) 寫法
     */
    func complete(with error: Error, at index: Int = 0) {
      messages[index].completion(error, nil)
    }

    func complete(withStatusCode code: Int, at index: Int = 0) {
      let response = HTTPURLResponse(url: messages[index].url,
                                     statusCode: code,
                                     httpVersion: nil,
                                     headerFields: nil)
      messages[index].completion(nil, response)
    }
  }
}
