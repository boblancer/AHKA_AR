//
//  mapController.swift
//  AHKA_AR
//
//  Created by Kanokporn Wongwaitayakul on 24/2/2563 BE.
//  Copyright © 2563 boblancer. All rights reserved.
//

import UIKit
class MapController: UIViewController, PinDelegate{
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var mapView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var slideView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var popup: UIView!
    
    let infoSlide:HowToSlide = Bundle.main.loadNibNamed("HowToSlide", owner: self, options: nil)?.first as! HowToSlide
    let pinKeyList = ["01" ,"02" ,"03" ,"04" ,"05" ,"06" ,"07" ,"08" ,"09" ,"10" ,"11" ,"12"]

    let foundPinList = ["holyWell" ,"skywalk" ,"noName2" ,"coffee" ,"voodooHub","cuturalCenter" ,"noName1" ,"visitorCenter" ,"chiefHub","saoChingcha" ,"coffeeRoasting" ,"ghostDoor"]
    let defaults = UserDefaults.standard

    var howToSlides: [HowToSlide] = []
    var map = MapCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(true, forKey: "10")
        popup.isHidden = false
        slideView.delegate = self
        infoSlide.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 95)
        
        mapView.dataSource = self
        mapView.delegate = self
        mapView.isPagingEnabled = true
        mapView.register(UINib(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        mapView.reloadData()
        
        createSlides()
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.popup.transform = CGAffineTransform(translationX: 0, y: self.popup.frame.height)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var check = true
        if map.pinList.count == 12{
            for index in 0...11{
                if defaults.bool(forKey: pinKeyList[index]) == true{
                    let imageTitle = foundPinList[index] + "Found"
                    if let image = UIImage(named: imageTitle) {
                        map.pinList[index].setImage(image, for: .normal)
                        map.pinList[index].accessibilityIdentifier = imageTitle
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
                
                slideView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 95)
                infoSlide.images.image = UIImage(named: "congrat")
                
                slideView.addSubview(infoSlide)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                           self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
                           self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self.bottomBar.frame.height)
                })
            }
        }
    }

    func createSlides(){
        let images: [UIImage] = [#imageLiteral(resourceName: "howTo1"), #imageLiteral(resourceName: "howTo2"), #imageLiteral(resourceName: "howTo3"), #imageLiteral(resourceName: "howTo4")]
        
        for i in 0..<images.count{
            let howTo:HowToSlide = Bundle.main.loadNibNamed("HowToSlide", owner: self, options: nil)?.first as! HowToSlide
            howTo.images.image = images[i]
            howTo.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height - 95)
            howToSlides.append(howTo)
        }
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
//        pageControl.currentPage = 0
        pageControl.numberOfPages = 4
        pageControl.isHidden = false
        map.mapView.alpha = 0.5
        
        for pin in map.pinList{
            pin.alpha = 0.7
        }
        
        slideView.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height - 95)
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
        
        slideView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 95)
        infoSlide.images.image = UIImage(named: imageTitle)
        
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
        
        for pin in cell.pinList{
            let width = pin.frame.size.width * heightRatio
            let height = pin.frame.size.height * heightRatio
            let x = pin.frame.origin.x * heightRatio
            let y = pin.frame.origin.y * heightRatio
            
            pin.frame = CGRect(x: x , y: y, width: width, height: height)
            
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
    
    
}

