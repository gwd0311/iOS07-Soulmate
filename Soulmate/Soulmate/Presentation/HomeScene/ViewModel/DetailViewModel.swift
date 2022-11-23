//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation

final class DetailViewModel {
    let userInfo: RegisterUserInfo
    let distance: Int

    private weak var coordinator: HomeCoordinator?
    
    init(userInfo: RegisterUserInfo, distance: Int, coordinator: HomeCoordinator) {
        self.userInfo = userInfo
        self.distance = distance
        self.coordinator = coordinator
    }

    
}

extension DetailViewModel {
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}