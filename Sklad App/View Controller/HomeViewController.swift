//
//  HomeViewController.swift
//  Sklad App
//
//  Created by Ibrokhim Movlonov on 4/2/19.
//  Copyright © 2019 Ibrokhim Movlonov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let transition = SlideInTransition()
    var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(menuButton(_:)))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
        fetchAllIncomings()
        
        
    }
    //==================
    
    func fetchAllIncomings() {
        guard let url = URL(string: "http://192.168.0.106:8080/companies/1") else {
            return
        }
        
        guard let url1 = URL(string: "https://api.myjson.com/bins/mofc4") else{return}
        Alamofire.request(url1,
                          method: .get)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data")
                    return
                }
                
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                //print(swiftyJsonVar[0]["attribute_name"].string!)
        }
    }
    
    
    //==========
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .ostatok:
            let view = UIView()
            view.backgroundColor = .yellow
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionCell", for: indexPath) as! MyCustomCollectionCell
        // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
        cell.backgroundColor = UIColor.orange
        cell.label.text = "item \(indexPath.item)"
        
        return cell
    }
    
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}
