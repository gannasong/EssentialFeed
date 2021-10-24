//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by SUNG HAO LIN on 2021/10/24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
  private let session: URLSession
  
  // 如果使用套件就在 init 時給預設值
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
    session.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
      } else if let data = data, let response = response as? HTTPURLResponse {
        completion(.success(data, response))
      }else {
        completion(.failure(UnexpectedValuesRepresentation()))
      }
    }.resume()
  }
}
