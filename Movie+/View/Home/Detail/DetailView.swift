//
//  DetailView.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    let movie: Movie
    
    var body: some View {
        
        ScrollView {
            if let posterPath = movie.posterPath, let imageUrl = NetworkService.shared.getImageURL(for: posterPath) {
                KFImage(imageUrl)
                    .placeholder({ progress in
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                    })
                    .resizable()
                    .frame(height: 300)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            HStack {
                Text(movie.title ?? movie.name ?? "No Title")
                    .font(.largeTitle)
                    .padding([.top, .leading])
                Spacer()
            }
            
            HStack {
                Text(genres())
                    .font(.callout)
                    .padding(.leading)
                Spacer()
            }
            
            if let overview = movie.overview {
                Text(overview.isEmpty ? "No Overview" : overview)
                    .padding()
            }
            
            ScrollView(.horizontal) {
                HStack{
                    if movie.adult ?? false {
                        infoCapsule(for: "18+")
                    }
                    if let date = movie.releaseDate ?? movie.firstAirDate {
                        infoCapsule(for: date.components(separatedBy: "-").first ?? "")
                    }
                    if let rate = movie.voteAverage {
                        infoCapsule(for: String(format: "%.1f", rate), Image(systemName: "star"))
                    }
                    if let language = movie.language {
                        infoCapsule(for: language, Image(systemName: "globe"))
                        
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("back-button")
                        .resizable()
                        .frame(width: 19, height: 38)
                })
                .padding()
            }
        })
        .ignoresSafeArea()
        .onAppear(perform: {
            AnalyticsManager.shared.logEvent(.movieDetail, parameters: ["movie_name" : movie.name ?? movie.title ?? ""])
        })
    }
    
    @ViewBuilder
    func infoCapsule(for info: String, _ icon: Image? = nil) -> some View {
        HStack {
            if let icon = icon {
                icon
                    .foregroundStyle(Color.black)
                    .padding(.leading, 10)
            }
            Text(info.capitalized)
                .padding(.all, 10)
                .foregroundColor(.black)
        }
        .background(Capsule().fill(Color.gray))
    }
    
    private func genres() -> String {
        if let _ = movie.title {
            return convert(for: .movie)
        } else {
            return convert(for: .tv)
        }
    }
    
    private func convert(for type: ContentType) -> String {
        guard let genreIDS = movie.genreIDS, !(movie.genreIDS?.isEmpty ?? false) else {return "No Genres"}
        return NetworkService.shared.getGenreNames(for: genreIDS, type: type)
    }
}

