//
//  AddSongViewModel.swift
//  Songs
//
//  Created by Guillaume on 19/01/2022.
//

import Foundation

class AddSongViewModel: ObservableObject {
    @Published var songTitle: String = ""
    @Published var date = Date()
    @Published var rate = 3
    @Published var isFavorite = false
    @Published var showAlert = false
    var alertMessage: String = ""
    var alertTitle: String = ""
    
    func addSong() {
        let songResult = DBManager.shared.addSong(title: songTitle,
                                                  rate: Int64(rate),
                                                  releaseDate: date,
                                                  isFavorite: isFavorite,
                                                  lyrics: "Bla bla bla",
                                                  coverURL: URL(string: "https://api.lorem.space/image/album")
        )
        switch songResult {
        case .success(let song):
            handlerAlert(title: "Well done", message: "Successfully added \(song.title ?? "song")")
        case .failure(let error):
            handlerAlert(title: "Error", message: error.localizedDescription)
        }
    }
    private func handlerAlert(title: String, message : String) {
        alertTitle = title
        alertMessage = message
        showAlert.toggle()
    }
}
