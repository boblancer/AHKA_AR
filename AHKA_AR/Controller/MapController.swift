//
//  mapController.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 24/2/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit
import AVFoundation
class MapController: UIViewController, PinDelegate{
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var mapView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var slideView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var slideViewLeading: NSLayoutConstraint!
    
    let infoSlide:HowToSlide = Bundle.main.loadNibNamed("HowToSlide", owner: self, options: nil)?.first as! HowToSlide
    let pinKeyList = ["01" ,"02" ,"03" ,"04" ,"05" ,"06" ,"07" ,"08" ,"09" ,"10" ,"11" ,"12"]
    
    let foundPinList = ["holyWell" ,"skywalk" ,"noName2" ,"coffee" ,"voodooHub","cuturalCenter" ,"noName1" ,"visitorCenter" ,"chiefHub","saoChingcha" ,"coffeeRoasting" ,"ghostDoor"]
    let defaults = UserDefaults.standard
    
    var timer: Timer? = nil

    var player: AVAudioPlayer?
    var howToSlides: [HowToSlide] = []
    var map = MapCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        defaults.set(true, forKey: "01")
//        defaults.set(true, forKey: "02")
//        defaults.set(true, forKey: "03")
//        defaults.set(true, forKey: "04")
//        defaults.set(true, forKey: "05")
//        defaults.set(true, forKey: "06")
//        defaults.set(true, forKey: "07")
//        defaults.set(true, forKey: "08")
//        defaults.set(true, forKey: "09")
//        defaults.set(true, forKey: "10")
//        defaults.set(true, forKey: "11")
//        defaults.set(true, forKey: "12")
        playSound()
        popup.isHidden = false
        slideView.delegate = self
        
        mapView.dataSource = self
        mapView.delegate = self
        mapView.isPagingEnabled = true
        mapView.register(UINib(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        mapView.reloadData()
        

        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.popup.transform = CGAffineTransform(translationX: 0, y: self.popup.frame.height)
        })
        print(defaults.bool(forKey: "Congrats"))
        if timer == nil && defaults.bool(forKey: "Congrats") != true{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bouncePins), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if player == nil{
            playSound()
        }
        else{
            player?.play()
        }
        
        if timer == nil && defaults.bool(forKey: "Congrats") != true{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bouncePins), userInfo: nil, repeats: true)
        }
        
        var check = true
        if map.pinList.count == 12{
            for index in 0...11{
                if defaults.bool(forKey: pinKeyList[index]) == true{
                    let imageTitle = foundPinList[index] + "Found"
                    if let image = UIImage(named: imageTitle) {
                        map.pinList[index].setImage(image, for: .normal)
                        map.pinList[index].accessibilityIdentifier = imageTitle+"Found"
                    }
                }
                else{
                    check = false
                }
            }
            
            if check && defaults.bool(forKey: "Congrats") != true{
                defaults.set(true, forKey: "Congrats")
                pageControl.isHidden = true
                popup.isHidden = false
                clearPopup()
                
                map.mapView.alpha = 0.5
                for pin in map.pinList{
                    pin.alpha = 0.7
                }
                
                slideView.contentSize = CGSize(width: view.frame.width, height: slideView.frame.height)
                
                
                infoSlide.images.image = UIImage(named: "congrat")
                
                slideView.addSubview(infoSlide)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self.bottomBar.frame.height)
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if player != nil{
            player?.pause()
        }
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 3009 4892
        
        
        infoSlide.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: slideView.frame.height)
        
        createSlides()
        
        let xRatio: CGFloat = 13 / 167
        let xWidth = view.frame.width / 5
        let xShadow = xRatio * xWidth
        let xX = view.frame.midX - (xWidth / 2) + (xShadow)
        let screenWidth = view.frame.width
        let screenRatio = screenWidth / 3009
        let bottomSpace = 205 * screenRatio
        var contentHeight = 4892 * screenRatio
        
        if contentHeight > slideView.frame.height{
            contentHeight = slideView.frame.height
            let leftY = (view.frame.height - (contentHeight + 25)) / 2
            let closeButtonHeight = (contentHeight + 25) + leftY - (xWidth / 2) - (bottomSpace / 2)
            
            pageControl.frame = CGRect(x: view.frame.midX - (pageControl.frame.width / 2), y: contentHeight, width: pageControl.frame.width, height: pageControl.frame.height)
            closeButton.frame = CGRect(x:  xX, y: closeButtonHeight + 6, width: xWidth, height: xWidth)
        }
        else{
            let leftY = (view.frame.height - (contentHeight + 25)) / 2
            let closeButtonHeight = (contentHeight + 25) + leftY - (xWidth / 2) - (bottomSpace / 2)
            
            pageControl.frame = CGRect(x: view.frame.midX - (pageControl.frame.width / 2), y: contentHeight + 25, width: pageControl.frame.width, height: pageControl.frame.height)
            closeButton.frame = CGRect(x:  xX, y: closeButtonHeight + 25, width: xWidth, height: xWidth)
        }
        
    }
    
    func playSound() {
       
        let url = Bundle.main.url(forResource: "bgsound", withExtension: "mp3")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    func createSlides(){
        let images: [UIImage?] = [UIImage(named: "howTo1"), UIImage(named: "howTo2"), UIImage(named: "howTo3"), UIImage(named: "howTo4"), UIImage(named: "howTo5")]
        
        for i in 0..<images.count{
            let howTo:HowToSlide = Bundle.main.loadNibNamed("HowToSlide", owner: self, options: nil)?.first as! HowToSlide
            howTo.images.image = images[i]
            howTo.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: slideView.frame.height)
            howToSlides.append(howTo)
        }
        pageControl.numberOfPages = 5

    }
    
    func clearPopup(){
        infoSlide.removeFromSuperview()
        for howto in howToSlides{
            howto.removeFromSuperview()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.map.mapView.alpha = 1
        for pin in self.map.pinList{
            pin.alpha = 1
        }
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.popup.transform = CGAffineTransform(translationX: 0, y: self.popup.frame.height)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: 0)
            
        })
    }
    
    @IBAction func howToPlayPressed(_ sender: UIButton) {
        
        popup.isHidden = false
        clearPopup()
        pageControl.isHidden = false
        map.mapView.alpha = 0.5
        
        for pin in map.pinList{
            pin.alpha = 0.7
        }
        
        slideView.contentSize = CGSize(width: view.frame.width * 5, height: slideView.frame.height)
        for howto in howToSlides{
            slideView.addSubview(howto)
        }
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self.bottomBar.frame.height)
        })
        
    }
    
    func pinIsPressed(_ mapCell: MapCell, _ imageTitle : String){
        
        pageControl.isHidden = true
        popup.isHidden = false
        clearPopup()
        
        map.mapView.alpha = 0.5
        for pin in map.pinList{
            pin.alpha = 0.7
        }
        
        slideView.contentSize = CGSize(width: view.frame.width, height: slideView.frame.height)
        
        if let image = UIImage(named: imageTitle){
            infoSlide.images.image = image
        }
        
        slideView.addSubview(infoSlide)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self.bottomBar.frame.height)
        })
    }
    
    
    
}





//MARK: - pagecontroller change page

extension MapController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}






//MARK: - set up map cell
extension MapController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
        cell.delegate = self
        // new 2393 1612
        let img = #imageLiteral(resourceName: "map")
        let heightRatio = mapView.frame.size.height / 1612
        let width = 2393 * heightRatio
        
        let newImg = img.resizeImageWith(newSize: CGSize(width: width, height: mapView.frame.size.height))
        
        cell.mapView.image = newImg
        cell.scrollView.contentSize = newImg.size
        
        for index in 0...11{
            let pin = cell.pinList[index]
            let realPin = cell.realPinList[index]
            let width = pin.frame.size.width * heightRatio
            let height = pin.frame.size.height * heightRatio
            let x = pin.frame.origin.x * heightRatio
            let y = pin.frame.origin.y * heightRatio
            
            pin.frame = CGRect(x: x , y: y, width: width, height: height)
            realPin.frame = CGRect(x: x , y: y, width: width, height: height)
        }
        
        for text in cell.textList{
            let width = text.frame.size.width * heightRatio
            let height = text.frame.size.height * heightRatio
            let x = text.frame.origin.x * heightRatio
            let y = text.frame.origin.y * heightRatio
            
            cell.textPosition[text] = [width, height, x, y]
            text.frame = CGRect(x: x , y: y, width: width, height: height)
            
        }
        
        for text in cell.textList2{
            let width = text.frame.size.width * heightRatio
            let height = text.frame.size.height * heightRatio
            let x = text.frame.origin.x * heightRatio
            let y = text.frame.origin.y * heightRatio
            
            cell.textPosition[text] = [width, height, x, y]
            text.frame = CGRect(x: x , y: y, width: width, height: height)
        }
        map = cell
        return cell
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = mapView.bounds.width
        let yourHeight = mapView.bounds.height
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @objc func bouncePins(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            for pin in self.map.pinList{
                if pin.accessibilityIdentifier!.contains("Found") == false {
                    pin.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

                }
            }
        }) { (_) in
            UIView.animate(withDuration: 1) {
                for pin in self.map.pinList{
                    if pin.accessibilityIdentifier!.contains("Found") == false{
                        pin.transform = CGAffineTransform.identity
                    }
                }
            }
        }
        
    }
    
}

