//
//  ViewController.swift
//  SwiftStudy
//
//  Created by Minkyeong Ko on 2023/02/25.
//

import UIKit

import SnapKit

let urls = ["https://images.unsplash.com/photo-1677247191557-4abd28b7c387?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3131&q=80", "https://images.unsplash.com/photo-1677040628614-53936ff66632?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80", "https://images.unsplash.com/photo-1676846631735-e10bf09d49d8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80", "https://images.unsplash.com/photo-1676765374032-57d90e318b8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80", "https://images.unsplash.com/photo-1676809730209-7600c5132931?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80"]

class ViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var loadImageViews: [LoadImageView] = []
    
    private var stackView: UIStackView = {
        var stackView = UIStackView()
        for idx in 0..<5 {
            stackView.addArrangedSubview(LoadImageView(idx: idx))
        }
        stackView.axis = .vertical
        return stackView
    }()
    
    private var imageLoadButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.setTitle("Load all Images", for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        render()
    }

    func render() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(imageLoadButton)
        imageLoadButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Func
    
    func addTargets() {
        imageLoadButton.addTarget(self, action: #selector(loadAllImages), for: .touchUpInside)
    }
    
    @objc func loadAllImages() {
        stackView.arrangedSubviews.enumerated().forEach {
            let imageView = $0.element as! LoadImageView
            imageView.imageDownload(url: URL(string: urls[$0.offset])!)
        }
    }
}

