//
//  ViewController.swift
//  ButtonSliderDemo
//
//  Created by Saurabh Yadav on 14/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, ButtonProtocol {
    @IBOutlet weak var buttonsView: ButtonsView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsView.buttonProtocolDelegate = self
        buttonsView.wordsArray = ["Offers", "Burgers", "Shakes", "Biryani","Snacks", "Lucknow Biryani"]
    }
}

extension ViewController {
    func selectedButton(withTag : Int) {
        print(withTag)
    }
}
