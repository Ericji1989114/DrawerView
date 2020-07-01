//
//  DrawerPresenter.swift
//  Drawer
//
//  Created by Eric JI on 2020/06/30.
//  Copyright © 2020 ericji. All rights reserved.
//

import UIKit

class DrawerPresenter: UIPresentationController {
    
    private let originalYPoistion: CGFloat
    
    private lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapDimmingView))
        view.addGestureRecognizer(tap)
        return view
    }()

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, originalYPoistion: CGFloat) {
        
        self.originalYPoistion = originalYPoistion
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }
    
    // MARK: Presentation

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        if let containerView = containerView {
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
            UIView.animate(withDuration: 0.5) {
                self.dimmingView.alpha = 1.0
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        UIView.animate(withDuration: 0.5) {
            self.dimmingView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: originalYPoistion, width: self.containerView!.bounds.width, height: self.containerView!.bounds.height)
    }
    
    // MARK: - Private Funcs
    @objc func onTapDimmingView() {
        self.presentingViewController.dismiss(animated: true)
    }

}
