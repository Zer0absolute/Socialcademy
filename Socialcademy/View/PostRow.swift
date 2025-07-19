//
//  PostRow.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostRow: View {
	let post: Post
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(post.authorName)
					.font(.subheadline)
					.fontWeight(.medium)
				Spacer()
				Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
					.font(.caption)
			}
			.foregroundColor(.gray)
			Text(post.title)
				.font(.title3)
				.fontWeight(.semibold)
			Text(post.content)
		}
		.padding(.vertical)
    }
}

#Preview {
	List {
		PostRow(post: Post.testPost)
	}
}
