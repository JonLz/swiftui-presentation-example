//
//  ViewController.swift
//  SwiftUI Presentation Examples
//
//  Created by Jonathan Lazar on 3/22/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    private lazy var hostingVc: UIViewController = {
        UIHostingController(rootView: hostSwiftUIView)
    }()

    private let hostSwiftUIView = SwiftUIView()

    private var hostView: UIView {
        hostingVc.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hostingVc.willMove(toParent: self)
        addChild(hostingVc)
        view.addSubview(hostView)
        hostView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingVc.didMove(toParent: self)

        let presentationContext = hostSwiftUIView.getPresentationContext()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newVC = UIViewController()
            newVC.view.backgroundColor = .purple
            presentationContext.present(newVC, animated: true, completion: nil)
        }
    }
}

