//
//  ButtonsView.swift
//  ButtonSliderDemo
//
//  Created by Saurabh Yadav on 14/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

protocol ButtonProtocol{
    func selectedButton(withTag : Int)
}
class ButtonsView: UIView {
    
    private var scrollView: UIScrollView?
    var buttonProtocolDelegate : ButtonProtocol?
    var movingView : UIView?
    var buttonWidths = [CGFloat]()
    @IBInspectable
    var wordsArray: [String] = [String]() {
        didSet {
            createButtons()
        }
    }
    var padding: CGFloat = 10
    var currentWidth: CGFloat = 0

    private func createButtons() {
        scrollView?.removeFromSuperview()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(scrollView!)
        scrollView!.backgroundColor = UIColor.gray
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        self.calculateButtonWidths()
        let totalWidthOfButtons = buttonWidths.reduce(10.0,+)
        let isBigButton = buttonWidths.contains(where: {$0 > (scrollView?.frame.size.width)!/2})
        print(isBigButton)
            for i in 0..<wordsArray.count {
                let text = wordsArray[i]
                var button = UIButton()
                if totalWidthOfButtons >= self.frame.size.width || isBigButton {
                    button = UIButton(frame: CGRect(x:currentWidth, y: 0.0, width: buttonWidths[i], height: self.frame.size.height))
                }else{
                    button = UIButton(frame: CGRect(x:currentWidth, y: 0.0, width: self.frame.size.width/CGFloat(self.buttonWidths.count), height: self.frame.size.height))
                    buttonWidths[i] = self.frame.size.width/CGFloat(self.buttonWidths.count)
                }
                button.tag = i
                button.setTitle(text, for: .normal)
                let buttonWidth = button.frame.size.width
                currentWidth = currentWidth + buttonWidth + (i == wordsArray.count - 1 ? 0 : padding)
                scrollView!.addSubview(button)
                button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
            }

        scrollView!.contentSize = CGSize(width:currentWidth,height:scrollView!.frame.size.height)
        self.addMovingView()
    }

    func addMovingView(){
        movingView = UIView.init(frame: CGRect.init(x: 0, y: (scrollView?.frame.size.height)! - 2, width: buttonWidths[0], height: 2))
        movingView?.backgroundColor = UIColor.green
        scrollView?.addSubview(movingView!)
    }
    func pressed(sender : UIButton){
        self.buttonProtocolDelegate!.selectedButton(withTag : sender.tag)
        self.moveButtonToCenterIfPossible(sender : sender)
    }

    func animageMovingView(sender : UIButton){
        UIView.animate(withDuration: 0.20, delay: 0, options: [UIViewAnimationOptions.curveEaseInOut], animations: {
            //Set x position what ever you want, in our case, it will be the beginning of the button
            () -> Void in
            self.movingView?.frame = CGRect(x: sender.frame.origin.x, y: (self.movingView?.frame.origin.y)! , width: sender.frame.size.width, height: 2)
            self.superview?.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            // ....
        })
    }
    
    func moveButtonToCenterIfPossible(sender : UIButton){
        self.scrollView?.scrollToView(button: sender, animated: true)
        print(sender.frame)
        self.animageMovingView(sender : sender)
        
    }
    
    func calculateButtonWidths(){
        
        for i in 0..<wordsArray.count {
            
            let text = wordsArray[i]
            let button = UIButton(frame: CGRect(x:0, y: 0.0, width: 100, height: 50))
            button.tag = i
            button.setTitle(text, for: .normal)
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: padding, bottom: 5, right: padding)
            button.sizeToFit()
            let buttonWidth = button.frame.size.width
            buttonWidths.append(buttonWidth)
        }
    }
}

extension UIScrollView {
    
    func scrollToView(button:UIButton, animated: Bool) {
        if let origin = button.superview {
            
            let buttonStart = button.frame.origin
            let buttonCenterPoint = button.center
            var scrollOffset = (origin as? UIScrollView)?.contentOffset

            let deviceBounds = (origin.superview?.frame.size.width)!/2
            print(buttonStart, deviceBounds, scrollOffset ?? "0.0")

            let differenceLeft = buttonCenterPoint.x - (scrollOffset?.x)!
            let differenceRight = ((origin as? UIScrollView)?.contentSize.width)! - (contentOffset.x + deviceBounds*2)
            
            if buttonCenterPoint.x > deviceBounds {
                // scroll left & right
                if differenceLeft > deviceBounds && differenceRight < deviceBounds && differenceRight < button.frame.size.width {
                        //handle last button
                    scrollOffset?.x = (scrollOffset?.x)! + differenceRight
                }else{
                    //for all others in the middle
                    scrollOffset?.x = (scrollOffset?.x)! + differenceLeft - deviceBounds
                }
                self.setContentOffset(CGPoint.init(x: (scrollOffset?.x)! , y: 0), animated: true)
                // scroll right
            }else {
                // left most buttons
                self.setContentOffset(CGPoint.init(x: 0 , y: 0), animated: true)
            }
        }
    }
}
