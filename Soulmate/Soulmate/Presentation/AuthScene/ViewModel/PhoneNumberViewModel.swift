//
//  PhoneNumberViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import Combine
import FirebaseAuth

struct PhoneNumberViewModelActions {
    var showCertificationPage: ((String) -> Void)?
    var quitPhoneLoginFlow: (() -> Void)?
}

class PhoneNumberViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType
    
    typealias Action = PhoneNumberViewModelActions
    
    struct Input {
        var didChangedNationCode: AnyPublisher<String?, Never>
        var didChangedPhoneNumber: AnyPublisher<String?, Never>
        var didTouchedNextButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    // MARK: UseCase
    var phoneSignInUseCase: PhoneSignInUseCase

    // MARK: Properties
    
    var actions: Action?
    var bag = Set<AnyCancellable>()
    
    @Published var nationCode: String?
    @Published var phoneNumber: String?
    
    // MARK: Configuration
    
    init(phoneSignInUseCase: PhoneSignInUseCase) {
        self.phoneSignInUseCase = phoneSignInUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        
        input.didChangedNationCode
            .assign(to: \.nationCode, on: self)
            .store(in: &bag)
        
        input.didChangedPhoneNumber
            .assign(to: \.phoneNumber, on: self)
            .store(in: &bag)
        
        input.didTouchedNextButton
            .sink { [weak self] _ in
                self?.nextButtonTouched()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = Publishers.CombineLatest($nationCode, $phoneNumber)
            .map { (value1, value2) in
                guard let value1 = value1,
                      let value2 = value2,
                      !value1.isEmpty,
                      !value2.isEmpty else { return false }
                return true
            }
            .eraseToAnyPublisher()
        
        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
    
    // MARK: Logic
    
    func nextButtonTouched() {
        guard var phoneNumber = phoneNumber else { return }
        
        // FIXME: 국가코드 부분은 추후 수정
        phoneNumber.removeFirst()
        phoneNumber = "+82" + phoneNumber
        
        Task { [phoneNumber, weak self] in
            do {
                let verificationID = try await phoneSignInUseCase.verifyPhoneNumber(phoneNumber: phoneNumber)
                await MainActor.run { [self] in
                    self?.actions?.showCertificationPage?(phoneNumber)
                }
            }
            catch {
                print(error)
            }
        }
        
    }
}
