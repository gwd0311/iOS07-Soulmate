//
//  DefaultListenOthersChattingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultListenOthersChattingUseCase: ListenOthersChattingUseCase {
    
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    private let loadChattingRepository: LoadChattingsRepository
    private var listenerRegistration: ListenerRegistration?
    var newMessages = PassthroughSubject<[Chat], Never>()
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
        
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func listenOthersChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let lastDocument = loadChattingRepository.lastDocument, let uid else {
            return
        }
        
        var query = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "date")
        
        if let lastDocument = loadChattingRepository.lastDocument {
            query = query
                .start(afterDocument: lastDocument)
        }

        listenerRegistration = query
            .addSnapshotListener { [weak self] snapshot, err in
                
                guard let snapshot, err == nil, !snapshot.documentChanges.isEmpty else { return }
                
                let addedChange = snapshot.documentChanges.filter { change in
                    change.type == .added
                }
                
                if addedChange.isEmpty { return }
                
                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }.reversed()
                let others = infos.filter { $0.userId != uid }
                let chats = others.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    var readUsers = Set(info.readUsers)
                    readUsers.insert(uid)
                    var arrReadUsers = readUsers.map { $0 }
                    
                    return Chat(isMe: isMe, userId: info.userId, readUsers: arrReadUsers, text: text, date: date, state: .validated)
                }
                                
                guard !chats.isEmpty else { return }
                guard let lastDocument = snapshot.documents.last else { return }
                
                for doc in snapshot.documents {
                    
                    let userId = doc.data()["userId"] as? String
                    if userId == uid { continue }
                    
                    let docRef = doc.reference
                    var readUsers = Set(doc.data()["readUsers"] as? [String] ?? [])
                    readUsers.insert(uid)
                    var arrReadUsers = readUsers.map { $0 }
                    
                    
                    docRef.updateData(["readUsers": arrReadUsers]) { err in
                        
                        if err == nil {
                            
                            let lastReadDocRef = db
                                .collection("ChatRooms")
                                .document(chatRoomId)
                                .collection("LastRead")
                                .document("\(uid)")
                            
                            lastReadDocRef.updateData(
                                ["lastReadTime" : Timestamp(date: Date.now)]
                            )
                            
                        } else {
                            print(err)
                        }
                    }
                    
                }
                
                //                    var unreadCount = try await db.collection("ChatRooms").document(documentId).getDocument().data(as: ChatRoomInfoDTO.self).unreadCount
                //
                //                    // FIXME: force unwrapping 수정하기
                //                    unreadCount[othersId]! += 1
                
                guard let othersId = self?.info.userIds.first(where: { $0 != uid }) else { return }
                
                db.collection("ChatRooms").document(chatRoomId).updateData(["unreadCount": [uid: 0.0, othersId: 0.0 ]])
                                    
                
                self?.loadChattingRepository.setLastDocument(lastDocument)                
                self?.newMessages.send(chats)
                self?.listenerRegistration?.remove()
                self?.listenerRegistration = nil
                self?.listenOthersChattings()
            }
    }
}
