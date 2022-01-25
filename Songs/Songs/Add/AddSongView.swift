//
//  AddSongView.swift
//  Songs
//
//  Created by Guillaume on 19/01/2022.
//

import SwiftUI

struct AddSongView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = AddSongViewModel()
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("Song Title", text: $viewModel.songTitle)
                    DatePicker("Release Date", selection: $viewModel.date, displayedComponents: .date)
                    RatingView(title: "Rate", rating: $viewModel.rate)
                }header: {
                    Text("Song")
                }
                Section{
                    NavigationLink {
                        AddArtistView()
                    } label: {
                        Label("Add artist", systemImage: "person.fill")
                    }
                    
                } header: {
                    Text("Artist")
                }
                Section {
                    Toggle("Favorite song", isOn: $viewModel.isFavorite)
                        .toggleStyle(.automatic)
                        .tint(.accentColor)
                }
                Button {
                    viewModel.addSong()
                } label: {
                    HStack {
                        Spacer()
                        Text("Add song")
                        Spacer()
                    }
                }
            }
            
            .alert(viewModel.alertTitle,
                   isPresented: $viewModel.showAlert) {
                        Button("OK", role: .cancel) {
                            presentationMode.wrappedValue.dismiss()
                }} message: {
                    Text(viewModel.alertMessage)
                }
                .navigationTitle("Add Song")
                .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
}


struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView()
    }
}
