//
//  ScoreVC.swift
//  Reflex
//
//  Created by Zhao on 2025/9/10.
//

import UIKit

class ScoreVC: UIViewController {
    
    // MARK: - Properties
    private var background_image_view: UIImageView!
    private var overlay_view: UIView!
    private var title_label: UILabel!
    private var back_button: UIButton!
    private var clear_button: UIButton!
    
    private var scores_table_view: UITableView!
    private var no_scores_label: UILabel!
    
    private var game_scores: [GameScore] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadScores()
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
        setupTableView()
        setupConstraints()
    }
    
    private func setupLabels() {
        // Title Label
        title_label = UILabel()
        title_label.text = ""
        title_label.font = UIFont.boldSystemFont(ofSize: 36)
        title_label.textColor = .white
        title_label.textAlignment = .center
        title_label.layer.shadowColor = UIColor.black.cgColor
        title_label.layer.shadowOffset = CGSize(width: 2, height: 2)
        title_label.layer.shadowOpacity = 0.8
        title_label.layer.shadowRadius = 4
        title_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(title_label)
        
        // No Scores Label
        no_scores_label = UILabel()
        no_scores_label.text = "No scores yet!\nPlay a game to see your records here."
        no_scores_label.font = UIFont.systemFont(ofSize: 18)
        no_scores_label.textColor = .white.withAlphaComponent(0.8)
        no_scores_label.textAlignment = .center
        no_scores_label.numberOfLines = 0
        no_scores_label.isHidden = true
        no_scores_label.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(no_scores_label)
    }
    
    private func setupButtons() {
        // Back Button
        back_button = createStyledButton(title: "Back", backgroundColor: .systemRed)
        back_button.addTarget(self, action: #selector(backTappedInSea), for: .touchUpInside)
        overlay_view.addSubview(back_button)
        
        // Clear Button
        clear_button = createStyledButton(title: "Clear All", backgroundColor: .systemOrange)
        clear_button.addTarget(self, action: #selector(clearTappedInSea), for: .touchUpInside)
        overlay_view.addSubview(clear_button)
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
    
    private func setupTableView() {
        scores_table_view = UITableView()
        scores_table_view.backgroundColor = UIColor.clear
        scores_table_view.separatorStyle = .none
        scores_table_view.delegate = self
        scores_table_view.dataSource = self
        scores_table_view.register(ScoreTableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        scores_table_view.translatesAutoresizingMaskIntoConstraints = false
        overlay_view.addSubview(scores_table_view)
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
            
            // Back Button
            back_button.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 20),
            back_button.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            back_button.widthAnchor.constraint(equalToConstant: 80),
            back_button.heightAnchor.constraint(equalToConstant: 40),
            
            // Clear Button
            clear_button.topAnchor.constraint(equalTo: overlay_view.topAnchor, constant: 20),
            clear_button.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            clear_button.widthAnchor.constraint(equalToConstant: 100),
            clear_button.heightAnchor.constraint(equalToConstant: 40),
            
            // Table View
            scores_table_view.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 30),
            scores_table_view.leadingAnchor.constraint(equalTo: overlay_view.leadingAnchor, constant: 20),
            scores_table_view.trailingAnchor.constraint(equalTo: overlay_view.trailingAnchor, constant: -20),
            scores_table_view.bottomAnchor.constraint(equalTo: overlay_view.bottomAnchor, constant: -20),
            
            // No Scores Label
            no_scores_label.centerXAnchor.constraint(equalTo: scores_table_view.centerXAnchor),
            no_scores_label.centerYAnchor.constraint(equalTo: scores_table_view.centerYAnchor)
        ])
    }
    
    // MARK: - Data Methods
    private func loadScores() {
        guard let scores_data = UserDefaults.standard.array(forKey: "game_scores") as? [Data] else {
            game_scores = []
            updateUI()
            return
        }
        
        game_scores = scores_data.compactMap { data in
            try? JSONDecoder().decode(GameScore.self, from: data)
        }.sorted { $0.score > $1.score }
        
        updateUI()
    }
    
    private func updateUI() {
        no_scores_label.isHidden = !game_scores.isEmpty
        scores_table_view.isHidden = game_scores.isEmpty
        scores_table_view.reloadData()
    }
    
    // MARK: - Button Actions
    @objc private func backTappedInSea() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearTappedInSea() {
        let alert = UIAlertController(title: "Clear All Scores", message: "Are you sure you want to delete all your game records?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "game_scores")
            self.game_scores = []
            self.updateUI()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScoreVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game_scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreTableViewCell
        let score = game_scores[indexPath.row]
        cell.configure(with: score, rank: indexPath.row + 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Score Table View Cell
class ScoreTableViewCell: UITableViewCell {
    
    private var container_view: UIView!
    private var rank_label: UILabel!
    private var score_label: UILabel!
    private var mode_label: UILabel!
    private var date_label: UILabel!
    private var accuracy_label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container View
        container_view = UIView()
        container_view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        container_view.layer.cornerRadius = 12
        container_view.layer.borderWidth = 2
        container_view.layer.borderColor = UIColor.black.cgColor
        container_view.layer.shadowColor = UIColor.black.cgColor
        container_view.layer.shadowOffset = CGSize(width: 0, height: 2)
        container_view.layer.shadowOpacity = 0.2
        container_view.layer.shadowRadius = 4
        container_view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container_view)
        
        // Rank Label
        rank_label = UILabel()
        rank_label.font = UIFont.boldSystemFont(ofSize: 24)
        rank_label.textColor = .black
        rank_label.textAlignment = .center
        rank_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(rank_label)
        
        // Score Label
        score_label = UILabel()
        score_label.font = UIFont.boldSystemFont(ofSize: 20)
        score_label.textColor = .black
        score_label.textAlignment = .left
        score_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(score_label)
        
        // Mode Label
        mode_label = UILabel()
        mode_label.font = UIFont.systemFont(ofSize: 14)
        mode_label.textColor = .systemBlue
        mode_label.textAlignment = .left
        mode_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(mode_label)
        
        // Date Label
        date_label = UILabel()
        date_label.font = UIFont.systemFont(ofSize: 12)
        date_label.textColor = .gray
        date_label.textAlignment = .left
        date_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(date_label)
        
        // Accuracy Label
        accuracy_label = UILabel()
        accuracy_label.font = UIFont.systemFont(ofSize: 12)
        accuracy_label.textColor = .systemGreen
        accuracy_label.textAlignment = .right
        accuracy_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(accuracy_label)
        
        NSLayoutConstraint.activate([
            // Container View
            container_view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            container_view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            container_view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            container_view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            // Rank Label
            rank_label.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 15),
            rank_label.centerYAnchor.constraint(equalTo: container_view.centerYAnchor),
            rank_label.widthAnchor.constraint(equalToConstant: 40),
            rank_label.heightAnchor.constraint(equalToConstant: 30),
            
            // Score Label
            score_label.leadingAnchor.constraint(equalTo: rank_label.trailingAnchor, constant: 15),
            score_label.topAnchor.constraint(equalTo: container_view.topAnchor, constant: 10),
            score_label.trailingAnchor.constraint(equalTo: accuracy_label.leadingAnchor, constant: -10),
            score_label.heightAnchor.constraint(equalToConstant: 25),
            
            // Mode Label
            mode_label.leadingAnchor.constraint(equalTo: rank_label.trailingAnchor, constant: 15),
            mode_label.topAnchor.constraint(equalTo: score_label.bottomAnchor, constant: 5),
            mode_label.trailingAnchor.constraint(equalTo: accuracy_label.leadingAnchor, constant: -10),
            mode_label.heightAnchor.constraint(equalToConstant: 20),
            
            // Date Label
            date_label.leadingAnchor.constraint(equalTo: rank_label.trailingAnchor, constant: 15),
            date_label.topAnchor.constraint(equalTo: mode_label.bottomAnchor, constant: 2),
            date_label.trailingAnchor.constraint(equalTo: accuracy_label.leadingAnchor, constant: -10),
            date_label.heightAnchor.constraint(equalToConstant: 15),
            
            // Accuracy Label
            accuracy_label.trailingAnchor.constraint(equalTo: container_view.trailingAnchor, constant: -15),
            accuracy_label.centerYAnchor.constraint(equalTo: container_view.centerYAnchor),
            accuracy_label.widthAnchor.constraint(equalToConstant: 80),
            accuracy_label.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with score: GameScore, rank: Int) {
        rank_label.text = "#\(rank)"
        score_label.text = "Score: \(score.score)"
        mode_label.text = score.mode.rawValue
        date_label.text = formatDate(score.date)
        accuracy_label.text = "\(String(format: "%.1f", score.accuracy * 100))%"
        
        // Color coding for top 3
        switch rank {
        case 1:
            container_view.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.9)
            rank_label.textColor = .black
        case 2:
            container_view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.9)
            rank_label.textColor = .black
        case 3:
            container_view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.9)
            rank_label.textColor = .black
        default:
            container_view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            rank_label.textColor = .black
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
