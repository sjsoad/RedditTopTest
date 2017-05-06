//
//  PostsService.swift
//  RedditTopTest
//
//  Created by Glib Pavliuchenko on 5/6/17.
//  Copyright © 2017 Glib Pavliuchenko. All rights reserved.
//

import Foundation

final class PostsService {
	private let networkSession: NetworkSession
	
	init(_ session: NetworkSession) {
		networkSession = session
	}
	
	func fetchPosts() {
		let endpont = GetTopPostsEndpoint(4, count: 0)
		networkSession.performRequest(from: endpont, completion: { response in
			
		})
	}
}