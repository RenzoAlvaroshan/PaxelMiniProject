//
//  RepoCell.swift
//  PaxelMiniProject
//
//  Created by Renzo Alvaroshan on 08/10/22.
//

import UIKit
import Kingfisher

class RepoCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RepoCell"
    
    private lazy var repoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ownerLoginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray3
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, ownerLoginLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(repoImageView)
        repoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        contentView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(repoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(80)
        }
    }
    
    func configure(with repo: Repository) {
        guard let url = URL(string: repo.owner.avatarURL) else { return }
        self.repoImageView.kf.setImage(with: url)
        
        fullNameLabel.text = repo.fullName
        ownerLoginLabel.text = repo.owner.login
        descriptionLabel.text = repo.itemDescription
    }
}
