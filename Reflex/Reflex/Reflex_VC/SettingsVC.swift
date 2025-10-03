//
//  SettingsVC.swift
//  Reflex
//
//  Created by Zhao on 2025/9/10.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - Properties
    private var background_image_view: UIImageView!
    private var overlay_view: UIView!
    private var title_label: UILabel!
    private var back_button: UIButton!
    
    private var difficulty_segmented_control: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
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
        setupControls()
        setupButtons()
        setupConstraints()
    }
    
    private func setupLabels() {
        // Title Label
        title_label = UILabel()
        title_label.text = "Settings"
        title_label.font = UIFont.boldSystemFont(ofSize: 36)
        title_label.textColor = .white
        title_label.textAlignment = .center
        title_label.layer.shadowColor = UIColor.black.cgColor
        title_label.layer.shadowOffset = CGSize(width: 2, height: 2)
        title_label.layer.shadowOpacity = 0.8
        title_label.layer.shadowRadius = 4
        title_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(title_label)
    }
    
    private func setupControls() {
        // Difficulty Segmented Control
        let difficulty_label = createSettingLabel(text: "Difficulty")
        difficulty_segmented_control = UISegmentedControl(items: ["Easy", "Normal", "Hard"])
        difficulty_segmented_control.selectedSegmentIndex = 1
        difficulty_segmented_control.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        difficulty_segmented_control.selectedSegmentTintColor = .systemBlue
        difficulty_segmented_control.addTarget(self, action: #selector(difficultyChangedInSea), for: .valueChanged)
        
        let difficulty_stack = createSettingStack(label: difficulty_label, control: difficulty_segmented_control)
        overlay_view.addSubview(difficulty_stack)
        
        // Store references for constraints
        difficulty_stack.tag = 100
    }
    
    private func createSettingLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }
    
    private func createSettingStack(label: UILabel, control: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, control])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        stack.layer.cornerRadius = 12
        stack.layer.borderWidth = 2
        stack.layer.borderColor = UIColor.black.cgColor
        stack.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func setupButtons() {
        // Back Button
        back_button = createStyledButton(title: "Back", backgroundColor: .systemRed)
        back_button.addTarget(self, action: #selector(backTappedInSea), for: .touchUpInside)
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
            
            // Title Label
            title_label.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 20),
            title_label.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            title_label.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            title_label.heightAnchor.constraint(equalToConstant: 50),
            
            // Difficulty Stack
            overlay_view.viewWithTag(100)!.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 40),
            overlay_view.viewWithTag(100)!.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            overlay_view.viewWithTag(100)!.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            overlay_view.viewWithTag(100)!.heightAnchor.constraint(equalToConstant: 60),
            
            // Back Button
            back_button.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            back_button.centerXAnchor.constraint(equalTo: overlay_view.centerXAnchor),
            back_button.widthAnchor.constraint(equalToConstant: 100),
            back_button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Methods
    private func loadSettings() {
        difficulty_segmented_control.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "difficulty_level")
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(difficulty_segmented_control.selectedSegmentIndex, forKey: "difficulty_level")
    }
    
    // MARK: - Control Actions
    @objc private func difficultyChangedInSea() {
        saveSettings()
    }
    
    @objc private func backTappedInSea() {
        navigationController?.popViewController(animated: true)
    }
}
