//
//  FireStoreStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreNetworkDatabaseApi: NetworkDatabaseApi {
    
    let db = Firestore.firestore()

    func create<T: Codable>(table: String, documentID: String, data: T) async throws {
        let collection = db.collection(table)
        let encoder = Firestore.Encoder()
        let fetchData = try encoder.encode(data)
        try await collection.document(documentID).setData(fetchData)
        
    }
    
    func create(path: String, data: [String: Any]) async throws -> Bool {
        if let _ = try? await db.collection(path).addDocument(data: data) {
            return true
        }
        
        return false
    }
    
    func read<T: Decodable>(table: String, documentID: String, type: T.Type) async throws -> T {
        let snapshot = try await db.collection(table).document(documentID).getDocument()
        return try snapshot.data(as: T.self)
    }
    
    func read<T: Codable>(table: String, constraints: [QueryEntity], type: T.Type) async throws -> [T] {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.map {
            try $0.data(as: T.self)
        }
    }
    
    func read<T: Decodable>(path: String, constraints: [QueryEntity], type: T.Type) async throws -> (data: [T], snapshot: QuerySnapshot) {
        var query = db.collection(path) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        let data = try snapshot.documents.map { try $0.data(as: T.self) }
        
        return (data, snapshot)
    }
    
    func update(table: String, documentID: String, with fields: [AnyHashable: Any]) async throws {
        let snapshot = try await db.collection(table).document(documentID).getDocument()
        try await snapshot.reference.updateData(fields)
    }

    func update(table: String, constraints: [QueryEntity], with fields: [AnyHashable: Any]) async throws {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        try await withThrowingTaskGroup(of: Void.self) { group throws in
            for document in snapshot.documents {
                group.addTask {
                    try await document.reference.updateData(fields)
                }
            }
        }
    }

    func delete(table: String, constraints: [QueryEntity]) async throws {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        try await withThrowingTaskGroup(of: Void.self) { group throws in
            for document in snapshot.documents {
                group.addTask {
                    try await document.reference.delete()
                }
            }
        }
    }
}
