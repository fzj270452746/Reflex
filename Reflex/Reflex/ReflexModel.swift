

import Foundation
import UIKit

// MARK: - Game Models
struct ReflexModel {
    var reflexItemPhoto: UIImage
    var reflexItemValue: Int
    var reflexItemIsSelect = false
    var reflexItemText = ""
    var reflexItemType: MahjongType
}

enum MahjongType: String, CaseIterable {
    case dong = "Dong"
    case tiao = "Tiao" 
    case wang = "Wang"
}

enum GameMode: String, CaseIterable, Codable {
    case single = "Single Drop"
    case triple = "Triple Drop"
}

struct GameScore: Codable {
    var score: Int
    var date: Date
    var mode: GameMode
    var accuracy: Double
}

// MARK: - Mahjong Data
class MahjongDataManager {
    static let shared = MahjongDataManager()
    
    private init() {}
    
    var allMahjongTiles: [ReflexModel] {
        return dongTiles + tiaoTiles + wangTiles
    }
    
    var dongTiles: [ReflexModel] {
        return [
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 1") ?? UIImage(), reflexItemValue: 1, reflexItemText: "Dong 1", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 2") ?? UIImage(), reflexItemValue: 2, reflexItemText: "Dong 2", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 3") ?? UIImage(), reflexItemValue: 3, reflexItemText: "Dong 3", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 4") ?? UIImage(), reflexItemValue: 4, reflexItemText: "Dong 4", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 5") ?? UIImage(), reflexItemValue: 5, reflexItemText: "Dong 5", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 6") ?? UIImage(), reflexItemValue: 6, reflexItemText: "Dong 6", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 7") ?? UIImage(), reflexItemValue: 7, reflexItemText: "Dong 7", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 8") ?? UIImage(), reflexItemValue: 8, reflexItemText: "Dong 8", reflexItemType: .dong),
            ReflexModel(reflexItemPhoto: UIImage(named: "dong 9") ?? UIImage(), reflexItemValue: 9, reflexItemText: "Dong 9", reflexItemType: .dong)
        ]
    }
    
    var tiaoTiles: [ReflexModel] {
        return [
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 1") ?? UIImage(), reflexItemValue: 1, reflexItemText: "Tiao 1", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 2") ?? UIImage(), reflexItemValue: 2, reflexItemText: "Tiao 2", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 3") ?? UIImage(), reflexItemValue: 3, reflexItemText: "Tiao 3", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 4") ?? UIImage(), reflexItemValue: 4, reflexItemText: "Tiao 4", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 5") ?? UIImage(), reflexItemValue: 5, reflexItemText: "Tiao 5", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 6") ?? UIImage(), reflexItemValue: 6, reflexItemText: "Tiao 6", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 7") ?? UIImage(), reflexItemValue: 7, reflexItemText: "Tiao 7", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 8") ?? UIImage(), reflexItemValue: 8, reflexItemText: "Tiao 8", reflexItemType: .tiao),
            ReflexModel(reflexItemPhoto: UIImage(named: "tiao 9") ?? UIImage(), reflexItemValue: 9, reflexItemText: "Tiao 9", reflexItemType: .tiao)
        ]
    }
    
    var wangTiles: [ReflexModel] {
        return [
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 1") ?? UIImage(), reflexItemValue: 1, reflexItemText: "Wang 1", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 2") ?? UIImage(), reflexItemValue: 2, reflexItemText: "Wang 2", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 3") ?? UIImage(), reflexItemValue: 3, reflexItemText: "Wang 3", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 4") ?? UIImage(), reflexItemValue: 4, reflexItemText: "Wang 4", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 5") ?? UIImage(), reflexItemValue: 5, reflexItemText: "Wang 5", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 6") ?? UIImage(), reflexItemValue: 6, reflexItemText: "Wang 6", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 7") ?? UIImage(), reflexItemValue: 7, reflexItemText: "Wang 7", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 8") ?? UIImage(), reflexItemValue: 8, reflexItemText: "Wang 8", reflexItemType: .wang),
            ReflexModel(reflexItemPhoto: UIImage(named: "wang 9") ?? UIImage(), reflexItemValue: 9, reflexItemText: "Wang 9", reflexItemType: .wang)
        ]
    }
    
    func getRandomTiles(count: Int) -> [ReflexModel] {
        let shuffled = allMahjongTiles.shuffled()
        return Array(shuffled.prefix(count))
    }
    
    func getTargetTile() -> ReflexModel {
        return allMahjongTiles.randomElement() ?? allMahjongTiles[0]
    }
}

// MARK: - Game State
class GameState {
    var current_score: Int = 0
    var total_tiles_dropped: Int = 0
    var correct_clicks: Int = 0
    var wrong_clicks: Int = 0
    var game_mode: GameMode = .single
    var is_game_active: Bool = false
    var current_target_tile: ReflexModel?
    var available_tiles: [ReflexModel] = []
    var drop_speed: Double = 4.0
    var max_tiles: Int = 30
    
    func resetGame() {
        current_score = 0
        total_tiles_dropped = 0
        correct_clicks = 0
        wrong_clicks = 0
        is_game_active = false
        current_target_tile = nil
        available_tiles = []
        drop_speed = 4.0
    }
    
    var accuracy: Double {
        let total_clicks = correct_clicks + wrong_clicks
        return total_clicks > 0 ? Double(correct_clicks) / Double(total_clicks) : 0.0
    }
}
