import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Foundation

class UserDetailsController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    //implement map services (CoreLocation) for weather feature
    let gradientLayer = CAGradientLayer()
    let apiKey = "0607a9d8a05ce2cd13b0988ef30b4cdf"
    var lat = 33.640560
    var lon = -112.222100
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
        
    }
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [bottomColor, topColor]
    }
   
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [bottomColor, topColor]
    }
    
    // you should really create a different ViewModel object for UserDetails
    // ie UserDetailsViewModel
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
   
            let dynamicButtonTitle = NSAttributedString(string: "Order \(infoLabel.text!))",
                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            orderButton.setAttributedTitle(dynamicButtonTitle, for: .normal)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    // how do i swap out a UIImageView with a UIViewController component
    let swipingPhotosController = SwipingPhotosController()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        //label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
            imageView.image = UIImage(named: "10n")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintColor = .clear//UIColor(white: 0.90, alpha: 1)
            return imageView
        }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir-Light", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir-Light", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    @objc fileprivate func handleDislike() {
        print("Disliking")
    }
    
    fileprivate func setupActivityIndicator() {
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.layer.addSublayer(gradientLayer)
        setupLayout()
        setupVisualBlurEffectView()
        //setupBottomControls()
        view.addSubview(orderButton)
        
        setupSwipeButton()
        setupActivityIndicator()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.cityLabel.text = "\(jsonResponse["name"].stringValue)"
        self.conditionLabel.text = "\(jsonWeather["main"].stringValue) and \(jsonWeather["description"].stringValue)"
                self.weatherImageView.image = UIImage(named: iconName)
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue * 9/5) + 32)) °" //formula to convert celcius to farenheit
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = "\(dateFormatter.string(from: date)) High: \((Int(round(jsonTemp["temp_max"].doubleValue * 9/5) + 32))) °"
                //Low: \(jsonTemp["temp_min"].doubleValue * 9/5) + 32) °"
                
                let suffix = iconName.suffix(1)
                if(suffix == "n") {
                    
                    self.setGreyGradientBackground()
                } else {
                    
                    self.setBlueGradientBackground()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    let orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowRadius = 14
        button.layer.shadowOpacity = 1.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        button.layer.borderColor = UIColor.yellow.cgColor
        button.addTarget(self, action: #selector(handleOrder), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleOrder() {
        print("Swiping to Order!")
    }
    
    fileprivate func setupSwipeButton() {

        let stackView = UIStackView(arrangedSubviews: [cityLabel, conditionLabel, temperatureLabel, dayLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: infoLabel.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 20, width: 140, height: 140)
        
        
        let buttonStackView = UIStackView(arrangedSubviews: [orderButton])
        //buttonStackView.axis = .vertical
        // buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: 0, height: 50)
        
 
        let imageStackView = UIStackView(arrangedSubviews: [weatherImageView])
        imageStackView.axis = .vertical
        imageStackView.distribution = .fillEqually
        view.addSubview(imageStackView)
        imageStackView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: buttonStackView.topAnchor, right: stackView.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 40, paddingRight: 0, width: 140, height: 140)

    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)
        
        scrollView.addSubview(infoLabel)
        infoLabel.textAlignment = .center
//        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16))
        
        infoLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
       
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
    }
    
    fileprivate let extraSwipingHeight: CGFloat = 0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        let imageView = swipingPhotosController.view!
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width + extraSwipingHeight)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
}
