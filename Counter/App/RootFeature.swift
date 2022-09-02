//
//  RootFeature.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import ComposableArchitecture

struct RootState: Equatable {
    var counter = CounterState()
    var favorite: FavoriteState {
        get {
            FavoriteState(
                favoriteNumbers: self.counter.favoriteNumbers
            )
        }
        set {
            self.counter.favoriteNumbers = newValue.favoriteNumbers
        }
    }
}

enum RootAction: Equatable {
    case counter(CounterAction)
    case favorite(FavoriteAction)
}

struct RootEnvironment: Equatable {
    static let live: Self = .init()
}

let RootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /RootAction.counter,
        environment: { _ in .init(factClient: .live) }
    ),
    favoriteReducer.pullback(
        state: \.favorite,
        action: /RootAction.favorite,
        environment: { _ in .init() }
    )
)
