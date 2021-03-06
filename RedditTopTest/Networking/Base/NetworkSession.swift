//
//  NetworkSession.swift
//  RedditTopTest
//
//  Created by Glib Pavliuchenko on 5/6/17.
//  Copyright © 2017 Glib Pavliuchenko. All rights reserved.
//

import Foundation

class NetworkSession: RequestsPerformer {
	
	private let urlSession: URLSession
	private let serverURL: URL
	var currentDataTask: URLSessionDataTask?
	
	init(_ urlSession: URLSession, baseServerURL: URL) {
		self.urlSession = urlSession
		serverURL = baseServerURL
	}
	
	func performRequest<EndpointType: Endpoint>(from endpoint: EndpointType,
	                    completion: @escaping (Result<EndpointType.Response>) -> Void) {
		currentDataTask?.cancel()
		currentDataTask = nil
		guard let url = requestURL(with: endpoint) else {
			completion(Result.failure())
			return
		}
		currentDataTask = urlSession.dataTask(with: url) { [weak self] data, _, error in
			var failed = true
			defer {
				if failed {
					completion(Result.failure())
				}
			}
			guard let strongSelf = self else { return }
			guard strongSelf.currentDataTask != nil else { return}
			guard error == nil else { return }
			guard let rawData = data else { return }
			guard let response = EndpointType.Response(rawData) else { return }
			failed = false
			completion(Result.success(value: response))
		}
		currentDataTask?.resume()
	}

	func requestURL<EndpointType: Endpoint>(with endpoint: EndpointType) -> URL? {
		let components = endpoint.parameters.enumerated().map {"\($0.element.key)=\($0.element.value)"}
		let queryString = components.joined(separator: "&")
		var urlComponents = URLComponents(url: serverURL, resolvingAgainstBaseURL: true)
		urlComponents?.path = endpoint.path
		urlComponents?.query = queryString
		return urlComponents?.url
	}
}
