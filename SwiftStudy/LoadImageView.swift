//
//  LoadImageView.swift
//  SwiftStudy
//
//  Created by Minkyeong Ko on 2023/02/25.
//

import UIKit

import SnapKit

private enum Size {
    static let viewHeight = 100
}

final class LoadImageView: UIView {
    
    // MARK: - Properties
    
    var myIndex: Int?
    
    // MARK: - UI Properties
    
    private var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.snp.makeConstraints { make in
            make.height.equalTo(Size.viewHeight)
        }
        return imageView
    }()
    
    private var progressBar: UIView = {
        var progressBar = UIView()
        var progressView = UIProgressView()
        progressView.progress = 0.5
        progressBar.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.center.leading.trailing.equalToSuperview()
        }
        return progressBar
    }()
    
    private var loadButton: UIButton = {
        var button = UIButton()
        button.setTitle("Load", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageView, self.progressBar, self.loadButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    init(idx: Int) {
        super.init(frame: .zero)
        self.myIndex = idx

        addTargets()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Size.viewHeight)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Func
    
    func addTargets() {
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
    }
    
    @objc func loadImage() {
        imageDownload(url: URL(string: urls[myIndex ?? 0])!)
    }
    
    /// ??????: https://swieeft.github.io/2020/03/10/ImageDownload.html
    func imageDownload(url: URL) {
        imageView.image = UIImage(systemName: "photo")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,  // ?????? ??????
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"), // ??????????????? ??????
                let data = data, error == nil,  // ???????????? ??? ???????????????
                let image = UIImage(data: data) // ????????? ??????
            else {
                print("Download image fail : \(url)")
                return
            }

            // URLSession??? ???????????? ???????????? ???????????? ?????? ????????? ????????? ?????? ??????????????? imageView??? ???????????? ????????? ?????? ???????????? ??????????????? ????????? ?????? ?????? (UI ????????? ?????? ???????????????)
            DispatchQueue.main.async() {[weak self] in
                print("Download image success \(url)")

                self?.imageView.image = image
            }
        }.resume()
    }
}
