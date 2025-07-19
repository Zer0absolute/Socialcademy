//
//  PostList.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostsList: View {
	private var posts = [Post.testPost]
	
    var body: some View {
		NavigationStack {
			List(posts) { post in
				Text(post.title)
				Text(post.content)
			}
			.navigationTitle("Posts")
		}
    }
}

#Preview {
    PostsList()
}
