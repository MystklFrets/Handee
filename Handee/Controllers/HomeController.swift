//
//  ViewController.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 11/11/18.
//  Copyright © 2018 Raul Fernando Gutierrez. All rights reserved.
//

//import UIKit
//import Firebase
//
//class HomeController: UIViewController {
//
//    let topStackView = TopNavigationStackView()
//    let buttonStackView = HomeBottomControlsStackView()
//    let cardsDeckView = UIView()
//
//    var cardViewModels = [CardViewModel]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
//        setupLayout()
//        setupFirestoreUserCards()
//        fetchUsersFromFirestore()
//    }
//
//    fileprivate func fetchUsersFromFirestore(){
////        let query = Firestore.firestore().collection("users").whereField("cost", isLessThan: 151).whereField("cost", isGreaterThan: 49).whereField("relatedwork", arrayContains: "Weed Control")
//    let query = Firestore.firestore().collection("users")
//            query.getDocuments { (snapshot, err) in
//            if let err = err {
//                print("failed to fetch users", err)
//                return
//            }
//            snapshot?.documents.forEach({ (documentSnapshot) in
//                let userDictionary = documentSnapshot.data()
//                let user = User(dictionary: userDictionary)
//                self.cardViewModels.append(user.toCardViewModel())
//            })
//            self.setupFirestoreUserCards()
//        }
//    }
//
//    @objc func handleSettings() {
//       let registrationController = RegistrationController()
//       present(registrationController, animated: true)
//    }
//
//    fileprivate func setupFirestoreUserCards() {
//        cardViewModels.forEach { (cardVM) in
//         let cardView = CardView(frame: .zero)
//            cardView.cardViewModel = cardVM
//            cardsDeckView.addSubview(cardView)
//            cardView.fillSuperview()
//        }
//    }
//
//    // MARK:- Fileprivate
//    fileprivate func setupLayout() {
//        view.backgroundColor = .white
//        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonStackView])
//        overallStackView.axis = .vertical
//        view.addSubview(overallStackView)
//        overallStackView.frame = .init(x: 0, y: 0, width: 300, height: 200)
//        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
//        overallStackView.isLayoutMarginsRelativeArrangement = true
//        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
//        overallStackView.bringSubviewToFront(cardsDeckView)
//
//    }
//}
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 3)
        //        let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Rob")
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                
             self.setupCardFromUser(user: user)
                
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    
    @objc func handleLogout() {
        let settingsController = RegistrationController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}

