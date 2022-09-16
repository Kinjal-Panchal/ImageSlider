//
//  ViewController.swift
//  ImageSlider
//
//  Created by Gaurang Vyas on 24/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var thumbCollectionView: UICollectionView!
    
    
    var mainImages: [UIImage] = []
    var thumbImages: [UIImage] = []
    var mainImageWidth: CGFloat = 0
    var thumbImageWidth: CGFloat = 0
    var thumbHorizontalOffSet: CGFloat = 0
    let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainCollectionView()
        setupThumbCollectionView()
    }
    
    private func setupMainCollectionView() {
        mainImages = Array(0...5).compactMap({
            UIImage(named: "image\($0)")
        })
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.layoutIfNeeded()
        collectionView.contentInset = .zero
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        mainImageWidth = collectionView.bounds.width
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isPagingEnabled = true
        collectionView.reloadData()
    }
    
    private func setupThumbCollectionView() {
        thumbImages = Array(6...10).compactMap({
            UIImage(named: "image\($0)")
        })
        thumbCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "thumb_cell")
        thumbCollectionView.layoutIfNeeded()
        guard let layout = thumbCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        var size = thumbCollectionView.bounds.size
        let width = ((mainImageWidth) / 2) - (itemSpacing * 2)
        thumbHorizontalOffSet = (width / 2) + (itemSpacing * 2)
        size.width = width
        thumbImageWidth = size.width
        thumbCollectionView.contentInset.left = thumbHorizontalOffSet
        thumbCollectionView.contentInset.right = thumbHorizontalOffSet
        layout.itemSize = size
        layout.minimumLineSpacing = itemSpacing
        thumbCollectionView.isPagingEnabled = false
        thumbCollectionView.reloadData()
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.thumbCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return mainImages.count
        } else {
            return thumbImages.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionCell
            cell.imageView.image = mainImages[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumb_cell", for: indexPath) as! ImageCollectionCell
            cell.imageView.image = thumbImages[indexPath.item]
            return cell
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else {
            return
        }
        let page = scrollView.contentOffset.x / mainImageWidth
        print(page)
        let pointX = ((page * thumbImageWidth) + (page * itemSpacing)) - thumbHorizontalOffSet
        thumbCollectionView.contentOffset = .init(x: pointX, y: 0)
    }
    
    
}
