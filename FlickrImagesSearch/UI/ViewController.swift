//
//  ViewController.swift
//  FlickrImagesSearch
//
//  Created by Вика on 10/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var images: [UIImage] = []
    let reuseId = "UITableViewCellreuseId"
    let presenter: PresenterInput
    
    let spinner = UIActivityIndicatorView(style: .gray)
    let emptyFooter = UIView()
    
    init(presenter: PresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Метод не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        showLoadingIndicator(false)
        
        self.presenter.loadFirstPage(searchString: "cat")
        
        navigationItem.title = "Китики"
    }
}

extension ViewController: PresenterOutput {
    
    func show(images: [UIImage], firstPage: Bool) {
        if firstPage {
            self.images = images
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.adjustedContentInset.top),
                                       animated: true)
        } else {
            let indexes = self.images.count..<self.images.count+images.count
            self.images += images
            tableView.insertRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        }
    }
    
    func showLoadingIndicator(_ show: Bool) {
        tableView.tableFooterView = show ? spinner : emptyFooter
        spinner.startAnimating()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.imageView?.image = images[indexPath.row]
        
        if indexPath.row == images.count - 1 {
            presenter.loadNextPage()
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let image = images[indexPath.row]
        self.navigationController?.pushViewController(ImageViewController(image: image), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/5.5
    }
}
