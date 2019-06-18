//
//  MatchesMessagesController.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 6/2/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//
//import LBTATools
//import Firebase
//
//struct Match {
//    let name, profileImageUrl, uid: String
//
//    init(dictionary: [String: Any]) {
//        self.name = dictionary["name"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
//    }
//}
//
//class MatchCell: LBTAListCell<Match> {
//
//    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "handeeLogo"), contentMode: .scaleAspectFill)
//    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2550676465, green: 0.2552897036, blue: 0.2551020384, alpha: 1), textAlignment: .center, numberOfLines: 2)
//
//    override var item: Match! {
//        didSet {
//            usernameLabel.text = item.name
//            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
//        }
//    }
//
//    override func setupViews() {
//        super.setupViews()
//
//        profileImageView.clipsToBounds = true
//        profileImageView.constrainWidth(80)
//        profileImageView.constrainHeight(80)
//        profileImageView.layer.cornerRadius = 80 / 2
//
//        stack(stack(profileImageView, alignment: .center),
//              usernameLabel)
//    }
//}
//
//class MatchesMessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
//
//    let customNavBar = MatchesNavBar()
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: 120, height: 140)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let match = items[indexPath.item]
//        let chatLogController = ChatLogController(match: match)
//        navigationController?.pushViewController(chatLogController, animated: true)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchMatches()
//
//        collectionView.backgroundColor = .white
//
//        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
//
//        view.addSubview(customNavBar)
//        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
//
//        collectionView.contentInset.top = 150
//    }
//
//    fileprivate func fetchMatches() {
//        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
//        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in
//
//            if let err = err {
//                print("Failed to fetch matches:", err)
//                return
//            }
//
//            print("Here are my matches documents")
//
//            var matches = [Match]()
//
//            querySnapshot?.documents.forEach({ (documentSnapshot) in
//                let dictionary = documentSnapshot.data()
//                matches.append(.init(dictionary: dictionary))
//            })
//
//            self.items = matches
//            self.collectionView.reloadData()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .init(top: 16, left: 0, bottom: 16, right: 0)
//    }
//
//    @objc fileprivate func handleBack() {
//        navigationController?.popViewController(animated: true)
//    }
//
//}

import LBTATools
import Firebase

class MatchesHorizontalController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    var rootMatchesController: MatchesMessagesController?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = self.items[indexPath.item]
        rootMatchesController?.didSelectMatchFromHeader(match: match)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        fetchMatches()
    }
    
    fileprivate func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Failed to fetch matches:", err)
                return
            }
            
            print("Here are my matches documents")
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
}

class MatchesHeader: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1))
    
    let matchesHorizontalController = MatchesHorizontalController()
    
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(stack(newMatchesLabel).padLeft(20),
              matchesHorizontalController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class MatchesMessagesController: LBTAListHeaderController<MatchCell, Match, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
    
    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMatches()
        setupUI()
    }
    
    fileprivate func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Failed to fetch matches:", err)
                return
            }
            
            print("Here are my matches documents")
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}
