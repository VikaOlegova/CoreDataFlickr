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
    
    let searchString = "kitten"

    init(presenter: PresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("Метод не реализован")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = tableView.frame.height / 5.5
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self

        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        showLoadingIndicator(false)

        presenter.loadFirstPage(searchString: searchString)

        navigationItem.title = "Китики"

        let clear = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapClear))

        navigationItem.rightBarButtonItem = clear
    }

    @objc
    func didTapClear() {
        CoreDataStack.shared.clear {
            DispatchQueue.main.async {
                self.images = []
                self.tableView.reloadData()
                self.presenter.loadFirstPage(searchString: self.searchString)
            }
        }
    }
}

extension ViewController: PresenterOutput {
    func show(images: [UIImage], firstPage: Bool) {
        DispatchQueue.main.async {
            if firstPage {
                self.images = images
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.tableView.adjustedContentInset.top),
                                                animated: true)

                print("display first page \(images.count)")
            } else {
                let indexes = self.images.count ..< self.images.count + images.count
                self.images += images
                self.tableView.insertRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)

                print("display next page \(images.count)")
            }
        }
    }

    func showLoadingIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = show ? self.spinner : self.emptyFooter
            self.spinner.startAnimating()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.imageView?.image = images[indexPath.row]

        if indexPath.row == images.count - 1 {
            print("hit bottom")
            presenter.loadNextPage()
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let image = images[indexPath.row]
        navigationController?.pushViewController(ImageViewController(image: image), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return tableView.frame.height / 5.5
    }
}
