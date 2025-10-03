//
//  MahjongGameVC.swift
//  Reflex
//
//  Created by Zhao on 2025/9/10.
//

import UIKit

class MahjongGameVC: UIViewController {
    
    // MARK: - Properties
    private var background_image_view: UIImageView!
    private var overlay_view: UIView!
    private var left_panel_view: UIView!
    private var right_panel_view: UIView!
    private var score_label: UILabel!
    private var timer_label: UILabel!
    private var start_button: UIButton!
    private var pause_button: UIButton!
    private var back_button: UIButton!
    
    private var mahjong_pool_view: UIView!
    private var falling_area_view: UIView!
    
    private var game_state: GameState!
    private var mahjong_data_manager: MahjongDataManager!
    private var game_timer: Timer?
    private var drop_timer: Timer?
    
    private var mahjong_buttons: [UIButton] = []
    private var falling_tiles: [UIView] = []
    
    private var current_game_mode: GameMode = .single
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 确保在视图完全显示后重新布局麻将
        if !mahjong_buttons.isEmpty {
            layoutMahjongButtons()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 在视图布局完成后重新布局麻将，确保居中显示
        DispatchQueue.main.async { [weak self] in
            if let self = self, !self.mahjong_buttons.isEmpty {
                self.layoutMahjongButtons()
            }
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .black
        
        // Background Image
        background_image_view = UIImageView()
        background_image_view.image = UIImage(named: "Reflex​Photo") ?? UIImage()
        background_image_view.contentMode = .scaleAspectFill
        background_image_view.clipsToBounds = true
        background_image_view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background_image_view)
        
        // Overlay View
        overlay_view = UIView()
        overlay_view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlay_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.layer.cornerRadius = 20
        overlay_view.layer.masksToBounds = true
        view.addSubview(overlay_view)
        
        // Left Panel (Mahjong Pool)
        left_panel_view = UIView()
        left_panel_view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        left_panel_view.layer.cornerRadius = 15
        left_panel_view.layer.borderWidth = 3
        left_panel_view.layer.borderColor = UIColor.white.cgColor
        left_panel_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(left_panel_view)
        
        // Right Panel (Falling Area)
        right_panel_view = UIView()
        right_panel_view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        right_panel_view.layer.cornerRadius = 15
        right_panel_view.layer.borderWidth = 3
        right_panel_view.layer.borderColor = UIColor.white.cgColor
        right_panel_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(right_panel_view)
        
        // Mahjong Pool View
        mahjong_pool_view = UIView()
        mahjong_pool_view.backgroundColor = UIColor.clear
        mahjong_pool_view.translatesAutoresizingMaskIntoConstraints = false
        left_panel_view.addSubview(mahjong_pool_view)
        
        // Falling Area View
        falling_area_view = UIView()
        falling_area_view.backgroundColor = UIColor.clear
        falling_area_view.translatesAutoresizingMaskIntoConstraints = false
        right_panel_view.addSubview(falling_area_view)
        
        setupLabels()
        setupButtons()
        setupConstraints()
    }
    
    private func setupLabels() {
        // Score Label
        score_label = UILabel()
        score_label.text = "Score: 0"
        score_label.font = UIFont.boldSystemFont(ofSize: 24)
        score_label.textColor = .white
        score_label.textAlignment = .center
        score_label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        score_label.layer.cornerRadius = 10
        score_label.layer.masksToBounds = true
        score_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(score_label)
        
        // Timer Label
        timer_label = UILabel()
        timer_label.text = "Tiles: 0/30"
        timer_label.font = UIFont.boldSystemFont(ofSize: 18)
        timer_label.textColor = .white
        timer_label.textAlignment = .center
        timer_label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        timer_label.layer.cornerRadius = 10
        timer_label.layer.masksToBounds = true
        timer_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(timer_label)
        
    }
    
    private func setupButtons() {
        // Start Button
        start_button = createStyledButton(title: "Start Game", backgroundColor: .systemGreen)
        start_button.addTarget(self, action: #selector(startGameInSea), for: .touchUpInside)
        overlay_view.addSubview(start_button)
        
        // Pause Button
        pause_button = createStyledButton(title: "Pause", backgroundColor: .systemOrange)
        pause_button.addTarget(self, action: #selector(pauseGameInSea), for: .touchUpInside)
        pause_button.isEnabled = false
        overlay_view.addSubview(pause_button)
        
        // Back Button
        back_button = createStyledButton(title: "Back", backgroundColor: .systemRed)
        back_button.addTarget(self, action: #selector(backToMenuInSea), for: .touchUpInside)
        overlay_view.addSubview(back_button)
    }
    
    private func createStyledButton(title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background Image
            background_image_view.topAnchor.constraint(equalTo: view.topAnchor),
            background_image_view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background_image_view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background_image_view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Overlay
            overlay_view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            overlay_view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overlay_view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overlay_view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Left Panel (Mahjong Pool) - 60% width
            left_panel_view.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 80),
            left_panel_view.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor),
            left_panel_view.widthAnchor.constraint(equalTo: overlay_view.widthAnchor, multiplier: 0.6),
            left_panel_view.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            
            // Right Panel (Falling Area) - 35% width
            right_panel_view.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 80),
            right_panel_view.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor),
            right_panel_view.widthAnchor.constraint(equalTo: overlay_view.widthAnchor, multiplier: 0.35),
            right_panel_view.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            
            // Mahjong Pool View
            mahjong_pool_view.topAnchor.constraint(equalTo: left_panel_view.topAnchor, constant: 20),
            mahjong_pool_view.leadingAnchor.constraint(equalTo: left_panel_view.leadingAnchor, constant: 20),
            mahjong_pool_view.trailingAnchor.constraint(equalTo: left_panel_view.trailingAnchor, constant: -20),
            mahjong_pool_view.bottomAnchor.constraint(equalTo: left_panel_view.bottomAnchor, constant: -20),
            
            // Falling Area View
            falling_area_view.topAnchor.constraint(equalTo: right_panel_view.topAnchor, constant: 20),
            falling_area_view.leadingAnchor.constraint(equalTo: right_panel_view.leadingAnchor, constant: 20),
            falling_area_view.trailingAnchor.constraint(equalTo: right_panel_view.trailingAnchor, constant: -20),
            falling_area_view.bottomAnchor.constraint(equalTo: right_panel_view.bottomAnchor, constant: -20),
            
            // Score Label - 左边
            score_label.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 10),
            score_label.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            score_label.widthAnchor.constraint(equalToConstant: 120),
            score_label.heightAnchor.constraint(equalToConstant: 40),
            
            // Timer Label - 右边
            timer_label.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 10),
            timer_label.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            timer_label.widthAnchor.constraint(equalToConstant: 120),
            timer_label.heightAnchor.constraint(equalToConstant: 40),
            
            // Back Button - 放在左边
            back_button.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            back_button.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 10),
            back_button.widthAnchor.constraint(equalToConstant: 95),
            back_button.heightAnchor.constraint(equalToConstant: 45),
            
            // Start Button - 放在中间
            start_button.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            start_button.centerXAnchor.constraint(equalTo: overlay_view.centerXAnchor),
            start_button.widthAnchor.constraint(equalToConstant: 115),
            start_button.heightAnchor.constraint(equalToConstant: 45),
            
            // Pause Button - 放在右边
            pause_button.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            pause_button.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -10),
            pause_button.widthAnchor.constraint(equalToConstant: 95),
            pause_button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func setupGame() {
        game_state = GameState()
        mahjong_data_manager = MahjongDataManager.shared
        setupMahjongPool()
    }
    
    private func setupMahjongPool() {
        guard mahjong_pool_view != nil else {
            return
        }
        
        // Clear existing buttons
        mahjong_buttons.forEach { $0.removeFromSuperview() }
        mahjong_buttons.removeAll()
        
        // Generate tiles for the pool (增加到18个麻将，6行3列布局)
        let pool_tiles = generatePoolTiles(count: 18)
        game_state.available_tiles = pool_tiles
        
        // Create buttons for each tile
        for (index, tile) in pool_tiles.enumerated() {
            let button = createMahjongButton(tile: tile, index: index)
            mahjong_pool_view.addSubview(button)
            mahjong_buttons.append(button)
        }
        
        // 调试信息（可以在发布时移除）
        // print("Created \(mahjong_buttons.count) buttons, available_tiles count: \(game_state.available_tiles.count)")
        
        // 初始布局麻将
        layoutMahjongButtons()
    }
    
    private func generatePoolTiles(count: Int) -> [ReflexModel] {
        let all_tiles = mahjong_data_manager.allMahjongTiles
        var pool_tiles: [ReflexModel] = []
        
        // 确保池中包含所有可能的目标麻将（每种类型至少一个）
        let dong_tiles = mahjong_data_manager.dongTiles
        let tiao_tiles = mahjong_data_manager.tiaoTiles
        let wang_tiles = mahjong_data_manager.wangTiles
        
        // 从每种类型中选择一些麻将
        let dong_count = min(6, dong_tiles.count)
        let tiao_count = min(6, tiao_tiles.count)
        let wang_count = min(6, wang_tiles.count)
        
        pool_tiles.append(contentsOf: Array(dong_tiles.shuffled().prefix(dong_count)))
        pool_tiles.append(contentsOf: Array(tiao_tiles.shuffled().prefix(tiao_count)))
        pool_tiles.append(contentsOf: Array(wang_tiles.shuffled().prefix(wang_count)))
        
        // 如果还需要更多麻将，随机添加
        while pool_tiles.count < count {
            if let random_tile = all_tiles.randomElement() {
                pool_tiles.append(random_tile)
            }
        }
        
        // 打乱顺序并限制数量
        return Array(pool_tiles.shuffled().prefix(count))
    }
    
    private func layoutMahjongButtons() {
        guard !mahjong_buttons.isEmpty, 
              let pool_view = mahjong_pool_view,
              let left_panel = left_panel_view else { return }
        
        // 确保视图已经完成布局
        pool_view.layoutIfNeeded()
        
        // 6行3列布局参数，适应18个麻将
        let columns = 3
        let rows = 6
        let button_size: CGFloat = 50  // 减小尺寸以适应更多麻将
        let spacing: CGFloat = 8       // 减小间距
        
        // 计算总的宽度和高度
        let total_width = CGFloat(columns) * button_size + CGFloat(columns - 1) * spacing
        let total_height = CGFloat(rows) * button_size + CGFloat(rows - 1) * spacing
        
        // 使用 mahjong_pool_view 的实际frame来计算居中位置
        let pool_frame = pool_view.frame
        let available_width = pool_frame.width
        let available_height = pool_frame.height
        
        // 计算起始位置，使麻将在 mahjong_pool_view 中居中显示
        let start_x = max(0, (available_width - total_width) / 2)
        let start_y = max(0, (available_height - total_height) / 2)
        
        // 调试信息（可以在发布时移除）
        // print("Pool frame: \(pool_frame)")
        // print("Total size: \(total_width) x \(total_height)")
        // print("Start position: (\(start_x), \(start_y))")
        
        for (index, button) in mahjong_buttons.enumerated() {
            let row = index / columns
            let col = index % columns
            
            let x = start_x + CGFloat(col) * (button_size + spacing)
            let y = start_y + CGFloat(row) * (button_size + spacing)
            
            button.frame = CGRect(x: x, y: y, width: button_size, height: button_size)
        }
    }
    
    private func createMahjongButton(tile: ReflexModel, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(tile.reflexItemPhoto, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        
        button.addTarget(self, action: #selector(mahjongButtonTappedInSea(_:)), for: .touchUpInside)
        
        // Store tile info in button tag
        button.tag = index
        
        return button
    }
    
    // MARK: - Game Logic
    @objc private func startGameInSea() {
        game_state.resetGame()
        game_state.is_game_active = true
        game_state.game_mode = current_game_mode
        
        // 重新设置麻将池，确保 available_tiles 和按钮保持同步
        setupMahjongPool()
        
        start_button.isEnabled = false
        pause_button.isEnabled = true
        
        updateUI()
        startDroppingTiles()
    }
    
    @objc private func pauseGameInSea() {
        if game_state.is_game_active {
            game_state.is_game_active = false
            game_timer?.invalidate()
            drop_timer?.invalidate()
            pause_button.setTitle("Resume", for: .normal)
        } else {
            game_state.is_game_active = true
            pause_button.setTitle("Pause", for: .normal)
            startDroppingTiles()
        }
    }
    
    @objc private func backToMenuInSea() {
        game_timer?.invalidate()
        drop_timer?.invalidate()
        navigationController?.popViewController(animated: true)
    }
    
    private func startDroppingTiles() {
        guard game_state.is_game_active else { return }
        
        if game_state.game_mode == .single {
            dropSingleTile()
        } else {
            dropTripleTiles()
        }
        
        // Schedule next drop
        let next_drop_interval = max(1.3, game_state.drop_speed - (Double(game_state.total_tiles_dropped) * 0.1))
        drop_timer = Timer.scheduledTimer(withTimeInterval: next_drop_interval, repeats: false) { [weak self] _ in
            self?.startDroppingTiles()
        }
    }
    
    private func dropSingleTile() {
        guard game_state.total_tiles_dropped < game_state.max_tiles else {
            endGame()
            return
        }
        
        // 确保目标麻将来自当前可用的麻将池
        guard !game_state.available_tiles.isEmpty else {
            endGame()
            return
        }
        
        let target_tile = game_state.available_tiles.randomElement() ?? game_state.available_tiles[0]
        game_state.current_target_tile = target_tile
        createFallingTile(tile: target_tile)
        
        game_state.total_tiles_dropped += 1
        updateUI()
    }
    
    private func dropTripleTiles() {
        guard game_state.total_tiles_dropped < game_state.max_tiles else {
            endGame()
            return
        }
        
        // 确保目标麻将来自当前可用的麻将池
        guard !game_state.available_tiles.isEmpty else {
            endGame()
            return
        }
        
        let tiles_to_drop = min(3, game_state.max_tiles - game_state.total_tiles_dropped)
        
        // 生成三个不同的麻将
        var selected_tiles: [ReflexModel] = []
        let available_count = game_state.available_tiles.count
        
        for i in 0..<tiles_to_drop {
            if available_count > i {
                // 尽量选择不同的麻将
                let tile_index = (i * (available_count / max(1, tiles_to_drop))) % available_count
                selected_tiles.append(game_state.available_tiles[tile_index])
            } else {
                // 如果可用麻将不够，随机选择
                selected_tiles.append(game_state.available_tiles.randomElement() ?? game_state.available_tiles[0])
            }
        }
        
        // 设置第一个麻将为目标麻将
        game_state.current_target_tile = selected_tiles.first
        
        // 分别在不同位置和时间投放三个麻将
        for i in 0..<tiles_to_drop {
            let delay = Double(i) * 0.5  // 增加时间间隔避免重叠
            let position_offset = i - 1  // -1, 0, 1 用于左中右位置
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.createFallingTile(tile: selected_tiles[i], positionOffset: position_offset)
            }
        }
        
        game_state.total_tiles_dropped += tiles_to_drop
        updateUI()
    }
    
    private func createFallingTile(tile: ReflexModel, positionOffset: Int = 0) {
        let tile_view = UIView()
        tile_view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tile_view.layer.cornerRadius = 8
        tile_view.layer.borderWidth = 2
        tile_view.layer.borderColor = UIColor.black.cgColor
        tile_view.layer.shadowColor = UIColor.black.cgColor
        tile_view.layer.shadowOffset = CGSize(width: 2, height: 2)
        tile_view.layer.shadowOpacity = 0.3
        tile_view.layer.shadowRadius = 3
        
        let image_view = UIImageView(image: tile.reflexItemPhoto)
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        tile_view.addSubview(image_view)
        
        NSLayoutConstraint.activate([
            image_view.topAnchor.constraint(equalTo: tile_view.topAnchor, constant: 5),
            image_view.leadingAnchor.constraint(equalTo: tile_view.leadingAnchor, constant: 5),
            image_view.trailingAnchor.constraint(equalTo: tile_view.trailingAnchor, constant: -5),
            image_view.bottomAnchor.constraint(equalTo: tile_view.bottomAnchor, constant: -5)
        ])
        
        falling_area_view.addSubview(tile_view)
        falling_tiles.append(tile_view)
        
        // Position at top with offset for multiple tiles
        let center_x = falling_area_view.bounds.width/2 - 30
        let offset_x = center_x + CGFloat(positionOffset) * 25  // 25点间距避免重叠
        let safe_x = max(5, min(offset_x, falling_area_view.bounds.width - 65))  // 确保在边界内
        tile_view.frame = CGRect(x: safe_x, y: -60, width: 60, height: 60)
        
        // Animate falling
        UIView.animate(withDuration: game_state.drop_speed, delay: 0, options: .curveLinear, animations: {
            tile_view.frame.origin.y = self.falling_area_view.bounds.height
        }) { _ in
            tile_view.removeFromSuperview()
            if let index = self.falling_tiles.firstIndex(of: tile_view) {
                self.falling_tiles.remove(at: index)
            }
        }
    }
    
    @objc private func mahjongButtonTappedInSea(_ sender: UIButton) {
        guard game_state.is_game_active, let target_tile = game_state.current_target_tile else { return }
        
        // 添加安全检查，防止数组越界
        let tag = sender.tag
        guard tag >= 0 && tag < game_state.available_tiles.count else {
            print("Error: Button tag \(tag) is out of range for available_tiles array (count: \(game_state.available_tiles.count))")
            return
        }
        
        let selected_tile = game_state.available_tiles[tag]
        let is_correct = selected_tile.reflexItemType == target_tile.reflexItemType && 
                        selected_tile.reflexItemValue == target_tile.reflexItemValue
        
        if is_correct {
            game_state.correct_clicks += 1
            game_state.current_score += 5
            game_state.drop_speed = max(0.5, game_state.drop_speed - 0.1)
            
            // Correct animation then remove the tile
            animateCorrectSelection(button: sender) { [weak self] in
                self?.removeTileFromPool(at: tag)
            }
        } else {
            game_state.wrong_clicks += 1
            
            // Wrong animation
            animateWrongSelection(button: sender)
        }
        
        updateUI()
    }
    
    private func removeTileFromPool(at index: Int) {
        guard index >= 0 && index < mahjong_buttons.count else { return }
        
        // 移除按钮
        let button = mahjong_buttons[index]
        button.removeFromSuperview()
        mahjong_buttons.remove(at: index)
        
        // 移除对应的麻将数据
        if index < game_state.available_tiles.count {
            game_state.available_tiles.remove(at: index)
        }
        
        // 重新设置剩余按钮的tag
        for (newIndex, remainingButton) in mahjong_buttons.enumerated() {
            remainingButton.tag = newIndex
        }
        
        // 重新布局剩余的麻将
        layoutMahjongButtons()
        
        // 检查是否所有麻将都已消失
        if mahjong_buttons.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.restartGameAfterAllTilesCleared()
            }
        }
    }
    
    private func restartGameAfterAllTilesCleared() {
        // 停止当前游戏
        game_timer?.invalidate()
        drop_timer?.invalidate()
        
        // 显示完成提示
        let alert = UIAlertController(title: "Congratulations!", message: "All tiles cleared!\nScore: \(game_state.current_score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Game", style: .default) { [weak self] _ in
            self?.setupMahjongPool()
            self?.game_state.is_game_active = true
            self?.startDroppingTiles()
        })
        alert.addAction(UIAlertAction(title: "Back to Menu", style: .default) { [weak self] _ in
            self?.backToMenuInSea()
        })
        present(alert, animated: true)
    }
    
    private func animateCorrectSelection(button: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            button.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { _ in
                completion()
            }
        }
    }
    
    private func animateWrongSelection(button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(translationX: -10, y: 0)
            button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(translationX: 10, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform.identity
                    button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                }
            }
        }
    }
    
    private func updateUI() {
        score_label.text = "Score: \(game_state.current_score)"
        timer_label.text = "Tiles: \(game_state.total_tiles_dropped)/\(game_state.max_tiles)"
    }
    
    private func endGame() {
        game_state.is_game_active = false
        game_timer?.invalidate()
        drop_timer?.invalidate()
        
        start_button.isEnabled = true
        pause_button.isEnabled = false
        pause_button.setTitle("Pause", for: .normal)
        
        // Show game over alert
        let alert = UIAlertController(title: "Game Over!", message: "Final Score: \(game_state.current_score)\nAccuracy: \(String(format: "%.1f", game_state.accuracy * 100))%", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.setupMahjongPool()
        })
        alert.addAction(UIAlertAction(title: "Back to Menu", style: .default) { _ in
            self.backToMenuInSea()
        })
        present(alert, animated: true)
        
        // Save score
        saveGameScore()
    }
    
    private func saveGameScore() {
        let score = GameScore(
            score: game_state.current_score,
            date: Date(),
            mode: game_state.game_mode,
            accuracy: game_state.accuracy
        )
        
        // Save to UserDefaults (in a real app, you might use Core Data)
        var scores = UserDefaults.standard.array(forKey: "game_scores") as? [Data] ?? []
        if let encoded = try? JSONEncoder().encode(score) {
            scores.append(encoded)
            UserDefaults.standard.set(scores, forKey: "game_scores")
        }
    }
    
    // MARK: - Public Methods
    func setGameMode(_ mode: GameMode) {
        current_game_mode = mode
    }
}
