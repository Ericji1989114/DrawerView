//
//  DrawerViewController.swift
//  Drawer
//
//  Created by Eric JI on 2020/06/30.
//  Copyright © 2020 ericji. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    // distance from bottom safeArea
    private let originalHeight: CGFloat
    
    // distance from top safeArea
    private let finalTopSpaceHeight: CGFloat?
    
    // buffer distance. Only over the buffer value. drawer will be set a new postion.
    private let resizeBuffer: CGFloat = 20
    
    private var originalY: CGFloat {
        let window = UIApplication.shared.keyWindow!
        return UIScreen.main.bounds.height - window.safeAreaInsets.bottom - self.originalHeight
    }
    
    private var finalTopY: CGFloat? {
        guard let height = finalTopSpaceHeight else {
            return nil
        }
        return height
    }
    
    init(originalHeight: CGFloat, finalTopSpaceHeight: CGFloat? = nil) {
        
        self.originalHeight = originalHeight
        self.finalTopSpaceHeight = finalTopSpaceHeight
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHoldView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(DrawerViewController.panGesture))
        self.view.addGestureRecognizer(gesture)
        self.view.backgroundColor = UIColor.white
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
    }
    
    private func setupHoldView() {
        let holdView = UIView()
        holdView.backgroundColor = UIColor.lightGray
        holdView.layer.cornerRadius = 3
        holdView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(holdView)
        NSLayoutConstraint.activate([
            holdView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            holdView.widthAnchor.constraint(equalToConstant: 50),
            holdView.heightAnchor.constraint(equalToConstant: 5),
            holdView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        // gesture data analysis
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        // current Y-axis
        let currentY = y + translation.y
    
        if let finalTopY = self.finalTopY {
            // user can expand & dismiss the view
            if currentY >= finalTopY /*area which can allow user scroll*/ {
                self.view.frame = CGRect(x: 0, y: currentY, width: view.frame.width, height: view.frame.height)
            }

        } else {
            // user can dismiss the view
            if currentY >= originalY /*area which can allow user scroll*/ {
                self.view.frame = CGRect(x: 0, y: currentY, width: view.frame.width, height: view.frame.height)
            }
            
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction], animations: {
                
                if !self.shouldResizeBufferHandling(currentY) {
                    if velocity.y < 0 {
                        self.view.frame = CGRect(x: 0, y: self.finalTopSpaceHeight!, width: self.view.frame.width, height: self.view.frame.height)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            
            }, completion: nil)
        }
    }
    
    private func shouldResizeBufferHandling(_ currentY: CGFloat) -> Bool {
        
        var shouldDoResize = false
        if currentY >= self.originalY - self.resizeBuffer && currentY <= self.originalY + self.resizeBuffer {
            // undo position
            self.view.frame = CGRect(x: 0, y: self.originalY, width: self.view.frame.width, height: self.view.frame.height)
            shouldDoResize = true
        } else if let finalTopY = self.finalTopY, currentY <= finalTopY + self.resizeBuffer {
            self.view.frame = CGRect(x: 0, y: finalTopY, width: self.view.frame.width, height: self.view.frame.height)
            shouldDoResize = true
        } else {
            shouldDoResize = false
        }
        return shouldDoResize
    }

}

extension DrawerViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DrawerPresenter(presentedViewController: presented, presenting: presenting, originalYPoistion: self.originalY)
    }
    
}
