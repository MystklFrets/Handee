//
//import UIKit
//import Firebase
//import JGProgressHUD
//
//class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
//
//    let topStackView = TopNavigationStackView()
//    let cardsDeckView = UIView()
//    let bottomControls = HomeBottomControlsStackView()
//
//    var cardViewModels = [CardViewModel]() // empty array
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
//        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
//
//        setupLayout()
//        fetchCurrentUser()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("HomeController did appear")
//        // you want to kick the user out when they log out
//        if Auth.auth().currentUser == nil {
//            let registrationController = RegistrationController()
//            registrationController.delegate = self
//            let navController = UINavigationController(rootViewController: registrationController)
//            present(navController, animated: true)
//        }
//    }
//
//    func didFinishLoggingIn() {
//        fetchCurrentUser()
//    }
//
//    fileprivate let hud = JGProgressHUD(style: .dark)
//    fileprivate var user: User?
//
//    fileprivate func fetchCurrentUser() {
//         hud.textLabel.text = "Loading!"
//               // hud.show(in: view)
//                guard let uid = Auth.auth().currentUser?.uid else { return }
//                Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
//                if let err = err {
//                    self.hud.dismiss()
//                    print(err)
//                    return
//                }
//
//                    // fetched our user here
//            guard let dictionary = snapshot?.data() else { return }
//            self.user = User(dictionary: dictionary)
//
//            self.fetchUsersFromFirestore()
//        }
//    }
//
//    @objc fileprivate func handleRefresh() {
//        fetchUsersFromFirestore()
//    }
//
//    var lastFetchedUser: User?
//
//    fileprivate func fetchUsersFromFirestore() {
//        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
//        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
//
//        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
//        query.getDocuments { (snapshot, err) in
//            self.hud.dismiss()
//            if let err = err {
//                print("Failed to fetch users:", err)
//                return
//            }
//
//            snapshot?.documents.forEach({ (documentSnapshot) in
//                let userDictionary = documentSnapshot.data()
//                let user = User(dictionary: userDictionary)
//                if user.uid != Auth.auth().currentUser?.uid {
//                    self.setupCardFromUser(user: user)
//                }
//            })
//        }
//    }
//
//    fileprivate func setupCardFromUser(user: User) {
//        let cardView = CardView(frame: .zero)
//        cardView.delegate = self
//        cardView.cardViewModel = user.toCardViewModel()
//        cardsDeckView.addSubview(cardView)
//        cardsDeckView.sendSubviewToBack(cardView)
//        cardView.fillSuperview()
//    }
//
//    func didTapMoreInfo(cardViewModel: CardViewModel) {
//        print("Home controller:", cardViewModel.attributedString)
//        let userDetailsController = UserDetailsController()
//        userDetailsController.cardViewModel = cardViewModel
//        present(userDetailsController, animated: true)
//    }
//
//    @objc func handleSettings() {
//        let settingsController = SettingsController()
//        settingsController.delegate = self
//        let navController = UINavigationController(rootViewController: settingsController)
//        present(navController, animated: true)
//    }
//
//    func didSaveSettings() {
//        print("Notified of dismissal from SettingsController in HomeController")
//        fetchCurrentUser()
//    }
//
//    // MARK:- Fileprivate
//
//    fileprivate func setupLayout() {
//        view.backgroundColor = .white
//        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
//        overallStackView.axis = .vertical
//        view.addSubview(overallStackView)
//        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
//        overallStackView.isLayoutMarginsRelativeArrangement = true
//        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
//
//        overallStackView.bringSubviewToFront(cardsDeckView)
//    }
//
//}



//import UIKit
//import Firebase
//import JGProgressHUD
//
//class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
//
//    let topStackView = TopNavigationStackView()
//    let cardsDeckView = UIView()
//    let bottomControls = HomeBottomControlsStackView()
//
//    var cardViewModels = [CardViewModel]() // empty array
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
//        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
//        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
//        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
//
//        setupLayout()
//        fetchCurrentUser()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("HomeController did appear")
//        // you want to kick the user out when they log out
//        if Auth.auth().currentUser == nil {
//            let registrationController = RegistrationController()
//            registrationController.delegate = self
//            let navController = UINavigationController(rootViewController: registrationController)
//            present(navController, animated: true)
//        }
//    }
//
//    func didFinishLoggingIn() {
//        fetchCurrentUser()
//    }
//
//    fileprivate let hud = JGProgressHUD(style: .dark)
//    fileprivate var user: User?
//
////    fileprivate func fetchCurrentUser() {
////        hud.textLabel.text = "Loading"
////        hud.show(in: view)
////        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
////        Firestore.firestore().fetchCurrentUser { (user, err) in
////            if let err = err {
////                print("Failed to fetch user:", err)
////                self.hud.dismiss()
////                return
////            }
////            self.user = user
////            self.fetchUsersFromFirestore()
////        }
////    }
//
//        fileprivate func fetchCurrentUser() {
//             hud.textLabel.text = "Loading!"
//                   // hud.show(in: view)
//                    guard let uid = Auth.auth().currentUser?.uid else { return }
//                    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
//                    if let err = err {
//                        self.hud.dismiss()
//                        print(err)
//                        return
//                    }
//
//                        // fetched our user here
//                guard let dictionary = snapshot?.data() else { return }
//                self.user = User(dictionary: dictionary)
//
//                self.fetchUsersFromFirestore()
//            }
//        }
//
//    @objc fileprivate func handleRefresh() {
//        fetchUsersFromFirestore()
//    }
//
//    var lastFetchedUser: User?
//
//    fileprivate func fetchUsersFromFirestore() {
//        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
//        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
//
//        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
//        topCardView = nil
//        query.getDocuments { (snapshot, err) in
//            self.hud.dismiss()
//            if let err = err {
//                print("Failed to fetch users:", err)
//                return
//            }
//
//            // we are going to set up the nextCardView relationship for all cards somehow?
//
//            // Linked List
//            var previousCardView: CardView?
//
//            snapshot?.documents.forEach({ (documentSnapshot) in
//                let userDictionary = documentSnapshot.data()
//                let user = User(dictionary: userDictionary)
//                if user.uid != Auth.auth().currentUser?.uid {
//                    let cardView = self.setupCardFromUser(user: user)
//
//                    previousCardView?.nextCardView = cardView
//                    previousCardView = cardView
//
//                    if self.topCardView == nil {
//                        self.topCardView = cardView
//                    }
//                }
//            })
//        }
//    }
//
//    var topCardView: CardView?
//
//    @objc fileprivate func handleLike() {
//        performSwipeAnimation(translation: 700, angle: 15)
//    }
//
//    @objc fileprivate func handleDislike() {
//        performSwipeAnimation(translation: -700, angle: -15)
//    }
//
//    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
//        let duration = 0.5
//        let translationAnimation = CABasicAnimation(keyPath: "position.x")
//        translationAnimation.toValue = translation
//        translationAnimation.duration = duration
//        translationAnimation.fillMode = .forwards
//        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        translationAnimation.isRemovedOnCompletion = false
//
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.toValue = angle * CGFloat.pi / 180
//        rotationAnimation.duration = duration
//
//        let cardView = topCardView
//        topCardView = cardView?.nextCardView
//
//        CATransaction.setCompletionBlock {
//            cardView?.removeFromSuperview()
//        }
//
//        cardView?.layer.add(translationAnimation, forKey: "translation")
//        cardView?.layer.add(rotationAnimation, forKey: "rotation")
//
//        CATransaction.commit()
//    }
//
//    func didRemoveCard(cardView: CardView) {
//        self.topCardView?.removeFromSuperview()
//        self.topCardView = self.topCardView?.nextCardView
//    }
//
//    fileprivate func setupCardFromUser(user: User) -> CardView {
//        let cardView = CardView(frame: .zero)
//        cardView.delegate = self
//        cardView.cardViewModel = user.toCardViewModel()
//        cardsDeckView.addSubview(cardView)
//        cardsDeckView.sendSubviewToBack(cardView)
//        cardView.fillSuperview()
//        return cardView
//    }
//
//    func didTapMoreInfo(cardViewModel: CardViewModel) {
//        print("Home controller:", cardViewModel.attributedString)
//        let userDetailsController = UserDetailsController()
//        userDetailsController.cardViewModel = cardViewModel
//        present(userDetailsController, animated: true)
//    }
//
//    @objc func handleSettings() {
//        let settingsController = SettingsController()
//        settingsController.delegate = self
//        let navController = UINavigationController(rootViewController: settingsController)
//        present(navController, animated: true)
//    }
//
//    func didSaveSettings() {
//        print("Notified of dismissal from SettingsController in HomeController")
//        fetchCurrentUser()
//    }
//
//    // MARK:- Fileprivate
//
//    fileprivate func setupLayout() {
//        view.backgroundColor = .white
//        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
//        overallStackView.axis = .vertical
//        view.addSubview(overallStackView)
//        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
//        overallStackView.isLayoutMarginsRelativeArrangement = true
//        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
//
//        overallStackView.bringSubviewToFront(cardsDeckView)
//    }
//
//}

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
            fileprivate func fetchCurrentUser() {
                 hud.textLabel.text = "Loading!"
                      //  hud.show(in: view)
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
                        if let err = err {
                            self.hud.dismiss()
                            print(err)
                            return
                        }
    
                            // fetched our user here
                    guard let dictionary = snapshot?.data() else { return }
                    self.user = User(dictionary: dictionary)
                    //self.user = user
    
                    self.fetchSwipes()
                }
            }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                
            print("failed to fetch swipes info for current user!", err)
            
            }
            print("Swipes:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            // we are going to set up the nextCardView relationship for all cards somehow?
            
            // Linked List
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true 
                if  isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document:", err)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully updated swipe....")
                    if didLike == 1  {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully saved swipe....")
                    if didLike == 1  {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
            print("failed to fetch document for card user")
            return
            }
            guard let data = snapshot?.data() else { return }
            print(data)
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                
            print("has matched!")
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
//        CATransaction.setCompletionBlock {
//            cardView?.removeFromSuperview()
//            if self.topCardView == nil {
//                self.view.bringSubviewToFront(self.button)
//            }
//        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        print("Home controller:", cardViewModel.attributedString)
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        print("Notified of dismissal from SettingsController in HomeController")
        fetchCurrentUser()
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




