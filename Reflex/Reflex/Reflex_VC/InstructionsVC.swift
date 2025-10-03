

import UIKit

class InstructionsVC: UIViewController {
    
    // MARK: - Properties
    private var background_image_view: UIImageView!
    private var overlay_view: UIView!
    private var scroll_view: UIScrollView!
    private var content_view: UIView!
    private var title_label: UILabel!
    private var back_button: UIButton!
    
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
        
        setupScrollView()
        setupLabels()
        setupButtons()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scroll_view = UIScrollView()
        scroll_view.backgroundColor = .clear
        scroll_view.showsVerticalScrollIndicator = true
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(scroll_view)
        
        content_view = UIView()
        content_view.backgroundColor = .clear
        content_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.addSubview(content_view)
    }
    
    private func setupLabels() {
        // Title Label
        title_label = UILabel()
        title_label.text = "How to Play"
        title_label.font = UIFont.boldSystemFont(ofSize: 36)
        title_label.textColor = .white
        title_label.textAlignment = .center
        title_label.layer.shadowColor = UIColor.black.cgColor
        title_label.layer.shadowOffset = CGSize(width: 2, height: 2)
        title_label.layer.shadowOpacity = 0.8
        title_label.layer.shadowRadius = 4
        title_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(title_label)
        
        createInstructionContent()
    }
    
    private func createInstructionContent() {
        
        // Game Objective
        let objective_section = createInstructionSection(
            title: "Game Objective",
            content: "Test your reflexes by quickly identifying and tapping the correct mahjong tiles as they fall from the top of the screen. Score points for correct taps and try to achieve the highest score possible!",
            icon: "target"
        )
        content_view.addSubview(objective_section)
        
        // How to Play
        let gameplay_section = createInstructionSection(
            title: "How to Play",
            content: "1. Choose between Single Drop or Triple Drop mode\n2. Watch for mahjong tiles falling from the top\n3. Quickly tap the matching tile in the left panel\n4. Correct taps earn 5 points each\n5. Game speed increases as you progress\n6. Complete all 30 tiles to finish the game",
            icon: "gamecontroller.fill"
        )
        content_view.addSubview(gameplay_section)
        
        // Game Modes
        let modes_section = createInstructionSection(
            title: "Game Modes",
            content: "• Single Drop Mode: One tile falls at a time\n• Triple Drop Mode: Three tiles fall simultaneously\n\nChoose the mode that best challenges your reflexes!",
            icon: "square.stack.3d.up.fill"
        )
        content_view.addSubview(modes_section)
        
        // Scoring
        let scoring_section = createInstructionSection(
            title: "Scoring System",
            content: "• Correct tap: +5 points\n• Wrong tap: 0 points\n• Accuracy: Percentage of correct taps\n• Speed increases with each correct tap\n• Complete all 30 tiles to see your final score",
            icon: "star.fill"
        )
        content_view.addSubview(scoring_section)
        
        // Tips
        let tips_section = createInstructionSection(
            title: "Pro Tips",
            content: "• Focus on the falling tiles, not the pool\n• Look for both type and number matches\n• Stay calm and don't rush\n• Practice regularly to improve your reflexes\n• Try both modes to find your preference",
            icon: "lightbulb.fill"
        )
        content_view.addSubview(tips_section)
        
        // Setup constraints for all sections
        NSLayoutConstraint.activate([
            // Objective Section
            objective_section.topAnchor.constraint(equalTo: content_view.topAnchor, constant: 20),
            objective_section.leadingAnchor.constraint(equalTo: content_view.leadingAnchor, constant: 20),
            objective_section.trailingAnchor.constraint(equalTo: content_view.trailingAnchor, constant: -20),
            
            // Gameplay Section
            gameplay_section.topAnchor.constraint(equalTo: objective_section.bottomAnchor, constant: 20),
            gameplay_section.leadingAnchor.constraint(equalTo: content_view.leadingAnchor, constant: 20),
            gameplay_section.trailingAnchor.constraint(equalTo: content_view.trailingAnchor, constant: -20),
            
            // Modes Section
            modes_section.topAnchor.constraint(equalTo: gameplay_section.bottomAnchor, constant: 20),
            modes_section.leadingAnchor.constraint(equalTo: content_view.leadingAnchor, constant: 20),
            modes_section.trailingAnchor.constraint(equalTo: content_view.trailingAnchor, constant: -20),
            
            // Scoring Section
            scoring_section.topAnchor.constraint(equalTo: modes_section.bottomAnchor, constant: 20),
            scoring_section.leadingAnchor.constraint(equalTo: content_view.leadingAnchor, constant: 20),
            scoring_section.trailingAnchor.constraint(equalTo: content_view.trailingAnchor, constant: -20),
            
            // Tips Section
            tips_section.topAnchor.constraint(equalTo: scoring_section.bottomAnchor, constant: 20),
            tips_section.leadingAnchor.constraint(equalTo: content_view.leadingAnchor, constant: 20),
            tips_section.trailingAnchor.constraint(equalTo: content_view.trailingAnchor, constant: -20),
            tips_section.bottomAnchor.constraint(equalTo: content_view.bottomAnchor, constant: -20)
        ])
    }
    
    private func createInstructionSection(title: String, content: String, icon: String) -> UIView {
        let container_view = UIView()
        container_view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        container_view.layer.cornerRadius = 15
        container_view.layer.borderWidth = 2
        container_view.layer.borderColor = UIColor.black.cgColor
        container_view.layer.shadowColor = UIColor.black.cgColor
        container_view.layer.shadowOffset = CGSize(width: 0, height: 2)
        container_view.layer.shadowOpacity = 0.2
        container_view.layer.shadowRadius = 4
        container_view.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon
        let icon_image_view = UIImageView()
        icon_image_view.image = UIImage(systemName: icon)
        icon_image_view.tintColor = .systemBlue
        icon_image_view.contentMode = .scaleAspectFit
        icon_image_view.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(icon_image_view)
        
        // Title
        let title_label = UILabel()
        title_label.text = title
        title_label.font = UIFont.boldSystemFont(ofSize: 20)
        title_label.textColor = .black
        title_label.numberOfLines = 0
        title_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(title_label)
        
        // Content
        let content_label = UILabel()
        content_label.text = content
        content_label.font = UIFont.systemFont(ofSize: 16)
        content_label.textColor = .black
        content_label.numberOfLines = 0
        content_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(content_label)
        
        NSLayoutConstraint.activate([
            // Icon
            icon_image_view.topAnchor.constraint(equalTo: container_view.topAnchor, constant: 15),
            icon_image_view.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 15),
            icon_image_view.widthAnchor.constraint(equalToConstant: 30),
            icon_image_view.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            title_label.topAnchor.constraint(equalTo: container_view.topAnchor, constant: 15),
            title_label.leadingAnchor.constraint(equalTo: icon_image_view.trailingAnchor, constant: 10),
            title_label.trailingAnchor.constraint(equalTo: container_view.trailingAnchor, constant: -15),
            title_label.heightAnchor.constraint(equalToConstant: 30),
            
            // Content
            content_label.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 10),
            content_label.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 15),
            content_label.trailingAnchor.constraint(equalTo: container_view.trailingAnchor, constant: -15),
            content_label.bottomAnchor.constraint(equalTo: container_view.bottomAnchor, constant: -15)
        ])
        
        return container_view
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
            
            // Scroll View
            scroll_view.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 20),
            scroll_view.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor),
            scroll_view.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor),
            scroll_view.bottomAnchor.constraint(equalTo: back_button.topAnchor, constant: -20),
            
            // Content View
            content_view.topAnchor.constraint(equalTo: scroll_view.topAnchor),
            content_view.leadingAnchor.constraint(equalTo: scroll_view.leadingAnchor),
            content_view.trailingAnchor.constraint(equalTo: scroll_view.trailingAnchor),
            content_view.bottomAnchor.constraint(equalTo: scroll_view.bottomAnchor),
            content_view.widthAnchor.constraint(equalTo: scroll_view.widthAnchor),
            
            // Back Button
            back_button.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            back_button.centerXAnchor.constraint(equalTo: overlay_view.centerXAnchor),
            back_button.widthAnchor.constraint(equalToConstant: 100),
            back_button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func backTappedInSea() {
        navigationController?.popViewController(animated: true)
    }
}
