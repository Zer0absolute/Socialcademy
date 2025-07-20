//
//  PostRow.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostRow: View {
	@State var viewModel: PostRowViewModel
	@State private var showConfirmationDialog = false
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(viewModel.post.authorName)
					.font(.subheadline)
					.fontWeight(.medium)
				Spacer()
				Text(viewModel.post.timestamp.formatted(date: .abbreviated, time: .omitted))
					.font(.caption)
			}
			.foregroundColor(.gray)
			Text(viewModel.post.title)
				.font(.title3)
				.fontWeight(.semibold)
			Text(viewModel.post.content)

			HStack {
				FavoriteButton(
					isFavorite: viewModel.post.isFavorite, 
					action: { viewModel.favoritePost() }
				)
				Spacer()
				Button(role: .destructive, action: {
					showConfirmationDialog = true
				}) {
					Label("Delete", systemImage: "trash")
				}
				.confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
					Button("Delete", role: .destructive, action: { viewModel.deletePost() })
				}
				.labelStyle(.iconOnly)
				.buttonStyle(.borderless)
				.padding(.leading)
			}
		}
		.padding(.vertical)
    }
}

private extension PostRow {
	struct FavoriteButton: View {
		let isFavorite: Bool
		let action: () -> Void
		
		var body: some View {
			Button(action: action) {
				if isFavorite {
					Label("Remove from Favorites", systemImage: "heart.fill")
						.foregroundColor(.red)
				} else {
					Label("Add to Favorites", systemImage: "heart")
						.foregroundColor(.gray)
				}
			}
			.animation(.easeInOut(duration: 0.2), value: isFavorite)
		}
	}
}



#Preview {
	List {
		PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
	}
}
