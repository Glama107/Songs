//
//  FavsViewModel.swift
//  Songs
//
//  Created by Guillaume on 25/01/2022.
//

import SwiftUI

class FavsViewModel: ObservableObject {
    @Published var showAddSongView = false
    
    @Published var songs = [Song]()
    init() {
        fetchSongs()
    }
    
    func fetchSongs() {
        let songsResult = DBManager.shared.getFavsSongs()
        switch songsResult {
        case .failure: return ()
        case .success(let songs): self.songs = songs
        }
    }
    
    func deleteSongs(at offsets: IndexSet) {
        offsets.forEach { index in
            DBManager.shared.deleteSong(by: songs[index].objectID)
        }
        songs.remove(atOffsets: offsets)
    }
}
