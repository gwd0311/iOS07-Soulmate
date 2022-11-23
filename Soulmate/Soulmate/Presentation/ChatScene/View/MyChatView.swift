//
//  MyChatView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class MyChatView: UIView {
    
    private lazy var chatLabel: UILabel = {
        let label = PaddingLabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .messagePurple
        label.layer.cornerCurve = .continuous
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textColor = .white
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        label.textColor = .labelGrey
        label.text = "오전 8:18"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with chat: Chat) {
        chatLabel.text = chat.text
    }
    
    func layout() {
        
        chatLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.trailing.equalTo(self.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.width.lessThanOrEqualTo(230)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(chatLabel.snp.leading).offset(-5)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
}