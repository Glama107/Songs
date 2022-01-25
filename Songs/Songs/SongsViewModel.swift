//
//  SongsViewModel.swift
//  Songs
//
//  Created by Guillaume on 19/01/2022.
//

import Foundation

class SongsViewModel: ObservableObject {
    @Published var showAddSongView : Bool = false
    @Published var songs = [Song]()
    
    init() {
        fetchSongs()
    }
    
    func fetchSongs() {
        let songsResult = DBManager.shared.getAllSongs()
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
