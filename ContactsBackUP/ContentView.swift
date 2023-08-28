//
//  ContentView.swift
//  ContactsBackUP
//
//  Created by Yousef Zuriqi on 28/08/2023.
//

import SwiftUI
import Contacts
import MessageUI
import Lottie



struct ContentView: View {
    
    @State private var showMailView = false
    @State private var vcfFileURL: URL?
    @State private var isLoading = false
    @State private var progress = 0.0
    @State private var showAlert = false

    
    var body: some View {
        
        NavigationView {
            VStack {
                LottieView(name: "backup")
                    .frame(width: 200, height: 200)
                Button {
                    isLoading = true
                    Task {
                        let contacts =  try await fetchContacts()
                        if let vcfData = generateVCF(contacts: contacts) {
                            if let url = saveVCFFile(data: vcfData) {
                                
                                DispatchQueue.main.async {
                                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                        if progress >= 100 {
                                            timer.invalidate()
                                            self.vcfFileURL = url
                                        } else {
                                            progress += 4
                                        }
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Label("**UPLOAD CONTACTS**", systemImage: "square.and.arrow.up.fill")
                        .imageScale(.large)
                }
                .frame(width: 200)
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                
                    LoadingView(progress: $progress)
                    .frame(width: 300)
                        .padding()
                        .padding()
                
                
                Button {
                    self.showMailView = true
                }label: {
                    Label("**SEND BY MAIL**", systemImage: "envelope.fill")
                        .imageScale(.large)
                }
                .frame(width: 200)
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .background(vcfFileURL == nil ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(self.vcfFileURL == nil)
                
                .animation(.easeInOut, value: vcfFileURL)

            }
            .navigationTitle("Backup Your Contacts")
            .alert(isPresented: $showAlert) {
                      Alert(title: Text("Congratulation!!"),
                            message: Text("Your contacts backup have been sent by mail"),
                            dismissButton: .default(Text("Got it!")))
                  }
            .sheet(isPresented: $showMailView) {
                if self.vcfFileURL == nil {
                    Text("NO URL")
                } else {
                    MailView(vcfFileURL: vcfFileURL!) {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            showAlert = true
                            RateTheApp.shared.askForRatingAfterTwoSeconds()
                        }
                        
                    }
                }
            }
        }
       
    }
    
    func fetchContacts() async throws -> [CNContact] {
        let store = CNContactStore()
        var contacts = [CNContact]()
        
//        try await requestContactAccess()
        
        let request = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        
        try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
            contacts.append(contact)
        })
        
        return contacts
    }
        

    
    func generateVCF(contacts: [CNContact]) -> Data? {
        guard !contacts.isEmpty else {return nil}
        for contact in contacts {
            print("Given Name: \(contact.givenName)")
            print("Family Name: \(contact.familyName)")
            print("Phone number: \(String(describing: contact.phoneNumbers.first?.value.stringValue ?? "")) ")
            // ... and so on
        }
        do {
            let vcfData = try CNContactVCardSerialization.data(with: contacts)
            return vcfData
        } catch {
            print("Error creating data: \(error)")
            return nil
        }
        
    }
    
    func saveVCFFile(data: Data) -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("contacts.vcf")
        do {
            try data.write(to: path)
            print("VCF file saved to \(path)")
            return path
        } catch {
            print("Failed to save VCF file:", error)
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
