//
//  MenuVC.swift
//  Reflex
//
//  Created by Zhao on 2025/9/10.
//

import UIKit

class MenuVC: UIViewController {
    
    // MARK: - Properties
    private var background_image_view: UIImageView!
    private var overlay_view: UIView!
    private var title_label: UILabel!
    private var subtitle_label: UILabel!
    
    private var single_mode_button: UIButton!
    private var triple_mode_button: UIButton!
    private var scores_button: UIButton!
    private var instructions_button: UIButton!
    private var settings_button: UIButton!
    
    private var button_stack_view: UIStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        overlay_view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.layer.cornerRadius = 20
        overlay_view.layer.masksToBounds = true
        view.addSubview(overlay_view)
        
        setupLabels()
        setupButtons()
        setupConstraints()
    }
    
    private func setupLabels() {
        // Title Label
        title_label = UILabel()
        title_label.text = "Mahjong Reflex"
        title_label.font = UIFont.boldSystemFont(ofSize: 22)
        title_label.textColor = .white
        title_label.textAlignment = .center
        title_label.layer.shadowColor = UIColor.black.cgColor
        title_label.layer.shadowOffset = CGSize(width: 2, height: 2)
        title_label.layer.shadowOpacity = 0.8
        title_label.layer.shadowRadius = 4
        title_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(title_label)
        
        // Subtitle Label
        subtitle_label = UILabel()
        subtitle_label.text = ""
        subtitle_label.font = UIFont.systemFont(ofSize: 20)
        subtitle_label.textColor = .white
        subtitle_label.textAlignment = .center
        subtitle_label.layer.shadowColor = UIColor.black.cgColor
        subtitle_label.layer.shadowOffset = CGSize(width: 1, height: 1)
        subtitle_label.layer.shadowOpacity = 0.8
        subtitle_label.layer.shadowRadius = 2
        subtitle_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(subtitle_label)
    }
    
    private func setupButtons() {
        // Single Mode Button
        single_mode_button = createMenuButton(
            title: "Single Drop Mode",
            subtitle: "",
            backgroundColor: .systemBlue,
            icon: "1.circle.fill"
        )
        single_mode_button.addTarget(self, action: #selector(singleModeTappedInSea), for: .touchUpInside)
        
        // Triple Mode Button
        triple_mode_button = createMenuButton(
            title: "Triple Drop Mode",
            subtitle: "",
            backgroundColor: .systemRed,
            icon: "3.circle.fill"
        )
        triple_mode_button.addTarget(self, action: #selector(tripleModeTappedInSea), for: .touchUpInside)
        
        // Scores Button
        scores_button = createMenuButton(
            title: "High Scores",
            subtitle: "",
            backgroundColor: .systemGreen,
            icon: "star.fill"
        )
        scores_button.addTarget(self, action: #selector(scoresTappedInSea), for: .touchUpInside)
        
        // Instructions Button
        instructions_button = createMenuButton(
            title: "How to Play",
            subtitle: "",
            backgroundColor: .systemOrange,
            icon: "questionmark.circle.fill"
        )
        instructions_button.addTarget(self, action: #selector(instructionsTappedInSea), for: .touchUpInside)
        
        // Settings Button
        settings_button = createMenuButton(
            title: "Settings",
            subtitle: "",
            backgroundColor: .systemPurple,
            icon: "gear.circle.fill"
        )
        settings_button.addTarget(self, action: #selector(settingsTappedInSea), for: .touchUpInside)
        
        // Stack View
        button_stack_view = UIStackView(arrangedSubviews: [
            single_mode_button,
            triple_mode_button,
            scores_button,
            instructions_button,
            settings_button
        ])
        button_stack_view.axis = .vertical
        button_stack_view.spacing = 10
        button_stack_view.distribution = .fillEqually
        button_stack_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(button_stack_view)
    }
    
    private func createMenuButton(title: String, subtitle: String, backgroundColor: UIColor, icon: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = backgroundColor.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 6
        
        // 确保按钮能够接收触摸事件
        button.isUserInteractionEnabled = true
        button.clipsToBounds = false
        
        // Create vertical stack for title and subtitle
        let content_stack = UIStackView()
        content_stack.axis = .vertical
        content_stack.spacing = 5
        content_stack.alignment = .center
        content_stack.isUserInteractionEnabled = false // 禁用用户交互，让触摸事件传递到按钮
        
        // Title
        let title_label = UILabel()
        title_label.text = title
        title_label.font = UIFont.boldSystemFont(ofSize: 20)
        title_label.textColor = .white
        title_label.textAlignment = .center
        title_label.isUserInteractionEnabled = false // 禁用用户交互
        
        // Subtitle
        let subtitle_label = UILabel()
        subtitle_label.text = subtitle
        subtitle_label.font = UIFont.systemFont(ofSize: 14)
        subtitle_label.textColor = .white.withAlphaComponent(0.8)
        subtitle_label.textAlignment = .center
        subtitle_label.isUserInteractionEnabled = false // 禁用用户交互
        
        // Icon
        let icon_image_view = UIImageView()
        icon_image_view.image = UIImage(systemName: icon)
        icon_image_view.tintColor = .white
        icon_image_view.contentMode = .scaleAspectFit
        icon_image_view.isUserInteractionEnabled = false // 禁用用户交互
        icon_image_view.translatesAutoresizingMaskIntoConstraints = false
        
        content_stack.addArrangedSubview(icon_image_view)
        content_stack.addArrangedSubview(title_label)
        content_stack.addArrangedSubview(subtitle_label)
        
        content_stack.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(content_stack)
        
        NSLayoutConstraint.activate([
            content_stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            content_stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            content_stack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 10),
            content_stack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -10),
            content_stack.topAnchor.constraint(greaterThanOrEqualTo: button.topAnchor, constant: 10),
            content_stack.bottomAnchor.constraint(lessThanOrEqualTo: button.bottomAnchor, constant: -10),
            icon_image_view.widthAnchor.constraint(equalToConstant: 30),
            icon_image_view.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 确保按钮能响应整个区域的点击
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Add press animation with more touch event types for better responsiveness
        button.addTarget(self, action: #selector(buttonPressedInSea(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleasedInSea(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        
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
            
            // Title Label
            title_label.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 40),
            title_label.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            title_label.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            title_label.heightAnchor.constraint(equalToConstant: 60),
            
            // Subtitle Label
            subtitle_label.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 10),
            subtitle_label.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            subtitle_label.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            subtitle_label.heightAnchor.constraint(equalToConstant: 10),
            
            // Button Stack View
            button_stack_view.topAnchor.constraint(equalTo: subtitle_label.bottomAnchor, constant: 15),
            button_stack_view.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 40),
            button_stack_view.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -40),
            button_stack_view.heightAnchor.constraint(equalToConstant: 430)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func singleModeTappedInSea() {
        let game_vc = MahjongGameVC()
        game_vc.setGameMode(.single)
        navigationController?.pushViewController(game_vc, animated: true)
    }
    
    @objc private func tripleModeTappedInSea() {
        let game_vc = MahjongGameVC()
        game_vc.setGameMode(.triple)
        navigationController?.pushViewController(game_vc, animated: true)
    }
    
    @objc private func scoresTappedInSea() {
        let scores_vc = ScoreVC()
        navigationController?.pushViewController(scores_vc, animated: true)
    }
    
    @objc private func instructionsTappedInSea() {
        let instructions_vc = InstructionsVC()
        navigationController?.pushViewController(instructions_vc, animated: true)
    }
    
    @objc private func settingsTappedInSea() {
        let settings_vc = SettingsVC()
        navigationController?.pushViewController(settings_vc, animated: true)
    }
    
    @objc private func buttonPressedInSea(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonReleasedInSea(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
}
