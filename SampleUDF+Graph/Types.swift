import ReduxStore
import Core

typealias Action = Core.Action
typealias AppState = Core.AppState
typealias Rider = Core.Rider
typealias Graph = Core.Graph

typealias Store = ReduxStore.Store<AppState, Action>
typealias Observer = ReduxStore.Observer<AppState>
