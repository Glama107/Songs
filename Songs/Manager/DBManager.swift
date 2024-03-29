//
//  Persistence.swift
//  Songs
//
//  Created by Guillaume on 19/01/2022.
//

import CoreData

struct DBManager {
    static let shared = DBManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Songs")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }


    // MARK: - Songs

    func getAllSongs() -> Result<[Song], Error> {
        let fetchRequest = Song.fetchRequest()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)

        fetchRequest.sortDescriptors = [descriptor]
        let context = container.viewContext

        do {
            let songs = try context.fetch(fetchRequest)
            return .success(songs)
        } catch {
            return .failure(error)
        }
    }
    
    func getFavsSongs() -> Result<[Song], Error> {
        let fetchRequest = Song.fetchRequest()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
        
        fetchRequest.sortDescriptors = [descriptor]
        let context = container.viewContext
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let songs = try context.fetch(fetchRequest)
            return .success(songs)
        } catch {
            return .failure(error)
        }
    }

    func getSong(by id: NSManagedObjectID) -> Result<Song, Error> {
        let context = container.viewContext
        do {
            let song = try context.existingObject(with: id) as! Song
            return .success(song)
        } catch {
            return .failure(error)
        }
    }


    func addSong(
        title: String,
        rate: Int64,
        releaseDate: Date,
        isFavorite: Bool = false,
        lyrics: String?,
        coverURL: URL?
    ) -> Result<Song, Error> {

        let context = container.viewContext

        // ⚠️ ARTIST -- DUMMY DATA
        // A DEGAGER
        let artistsRes = getAllArtists()
        var artist: Artist?
        switch artistsRes {
        case .failure: artist = nil
        case .success(let artists): artist = artists.first
        }

        let song = Song(entity: Song.entity(),
                        insertInto: context)
        song.title = title
        song.releaseDate = releaseDate
        song.rate = rate
        song.isFavorite = isFavorite
        song.coverURL = coverURL
        song.lyrics = lyrics
        // Relation
        song.artist = artist

        do {
            try context.save()
            return .success(song)
        } catch {
            return .failure(error)
        }
    }

    @discardableResult
    func deleteSong(by id: NSManagedObjectID) -> Result<Void, Error> {
        let context = container.viewContext

        do {
            let song = try context.existingObject(with: id)
            context.delete(song)
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    // MARK: - Artist

    func addDefaultArtist() {
        let artistsResult = getAllArtists()
        var fetchedArtists = [Artist]()
        switch artistsResult {
            case .success(let artists): fetchedArtists = artists
            case .failure: return
        }

        if fetchedArtists.isEmpty {
            let context = container.viewContext
            let baseArtist = Artist(entity: Artist.entity(), insertInto: context)
            baseArtist.songs = []
            baseArtist.coverURL = URL(string: "https://saschasalles.sirv.com/saschasalles.com/main/portrait.jpg")
            baseArtist.firstName = "Sascha"
            baseArtist.lastName = "Salles"
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getAllArtists() -> Result<[Artist], Error> {
        let fetchRequest = Artist.fetchRequest()
        let context = container.viewContext

        do {
            let artists = try context.fetch(fetchRequest)
            return .success(artists)
        } catch {
            return .failure(error)
        }
    }
    
    func addArtist(
        firstName: String,
        lastName: String,
        coverURL: URL?
    ) -> Result<Artist, Error> {
        
        let context = container.viewContext
        
        let artist = Artist(entity: Artist.entity(),
                            insertInto: DBManager.shared.container.viewContext)
        artist.firstName = firstName
        artist.lastName = lastName
        artist.coverURL = coverURL
        // Relation
        
        do {
            try context.save()
            return .success(artist)
        } catch {
            return .failure(error)
        }
    }
    
}
