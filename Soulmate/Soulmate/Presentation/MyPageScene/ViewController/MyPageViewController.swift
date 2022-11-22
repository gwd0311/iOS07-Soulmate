//
//  MyPageViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit

final class MyPageView: UIView {
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        self.addSubview(view)
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 78
        imageView.layer.borderWidth = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.backgroundColor = .white
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var editImageView: UIImageView = {
        let image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .heavy))
        
        let imageView = UIImageView(image: image?.resized(to: CGSize(width: 23, height: 23)).withTintColor(.gray))
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 23
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.symbolGrey?.cgColor
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = "초록잎"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        titleLabel.sizeToFit()
        
        let ageLabel = UILabel()
        ageLabel.text = "25"
        ageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        ageLabel.sizeToFit()
        
        [titleLabel, ageLabel].forEach { stackView.addArrangedSubview($0) }
        self.addSubview(stackView)
        return stackView
    }()
    
    lazy var remainingHeartsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.backgroundColor = .lightPurple
        
        let titleLabel = UILabel()
        titleLabel.text = "보유 하트"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        
        let heartCountLabel = UILabel()
        heartCountLabel.text = "30개"
        heartCountLabel.textColor = .mainPurple
        heartCountLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        
        let rightArrowImage = UIImage(systemName: "chevron.right")
        let rightArrowView = UIImageView(image: rightArrowImage?.resized(to: CGSize(width: 15, height: 15)).withTintColor(.borderPurple ?? .purple))
        rightArrowView.contentMode = .center
        
        [titleLabel, heartCountLabel, rightArrowView].forEach { stackView.addArrangedSubview($0) }
        self.addSubview(stackView)
        return stackView
    }()
    
    lazy var remainingHeartView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPurple
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 10
        view.addSubview(remainingHeartsStackView)
        self.addSubview(view)
        return view
    }()
    
    lazy var heartShopView: MyPageMenuView = {
        let view = MyPageMenuView(symbolName: "myPageHeart", titleName: "하트샵 가기", trailingText: "")
        self.addSubview(view)
        return view
    }()
    
    lazy var personalInfoView: MyPageMenuView = {
        let view = MyPageMenuView(symbolName: "myPagePersonalInfo", titleName: "개인정보 처리방침", trailingText: "")
        self.addSubview(view)
        return view
    }()
    
    lazy var versionInfoView: MyPageMenuView = {
        let view = MyPageMenuView(symbolName: "myPagePin", titleName: "버전정보", trailingText: "v 3.2.20")
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        self.backgroundColor = .myPageGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(174)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(contentView.snp.top)
            $0.width.height.equalTo(156)
        }
        
        editImageView.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.width.height.equalTo(46)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        remainingHeartView.snp.makeConstraints {
            $0.top.equalTo(profileInfoStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(62)
        }
        
        remainingHeartsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.edges.equalToSuperview().inset(20)
        }
        
        heartShopView.snp.makeConstraints {
            $0.top.equalTo(remainingHeartView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        personalInfoView.snp.makeConstraints {
            $0.top.equalTo(heartShopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        versionInfoView.snp.makeConstraints {
            $0.top.equalTo(personalInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
    }
    
}

final class MyPageViewController: UIViewController {
    
    let symbols = ["myPageHeart", "myPagePersonalInfo", "myPagePin"]
    let titles = ["하트샵 가기", "개인정보 처리방침", "버전정보"]
    let subTexts = ["", "", "v 3.2.20"]
    
    lazy var contentView = MyPageView()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.size.width, height: 68)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MyPageMenuCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageMenuCollectionViewCell")
        self.view.addSubview(view)
        return view
    }()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        // binding
        // viewModel -> view
        // view -> viewModel
    }
    
    
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.contentView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 메뉴리스트 수 전달
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageMenuCollectionViewCell", for: indexPath) as? MyPageMenuCollectionViewCell else {
            print("안나왔어요")
            return UICollectionViewCell()
        }
        print("나오고있어요")
        cell.symbol.image = UIImage(named: symbols[indexPath.row])
        cell.title.text = titles[indexPath.row]
        cell.trailingDescription.text = subTexts[indexPath.row]
        return cell
        
    }
    
}
