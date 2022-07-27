//
//  ViewController.swift
//  touchRandomBtn
//
//  Created by Soo J on 2022/07/22.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        collectionView

    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    var originalArray: Array<Int> = [1,2,3,4,5,6,7,8,9]
    var derivedArray: Array<Int> = [1,2,3,4,5,6,7,8,9]
    var nthTab: Int = 1
    
    
    func showButtonsInOrder() {
        for (index, element) in derivedArray.enumerated(){
            print("\(index)번째 element of derivedArray \(element) appeared")
            
            
        }
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        derivedArray = originalArray.shuffled()
        collectionView.reloadData()
        showButtonsInOrder()
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as?
                    MyCollectionViewCell else {
            
                return
            }
        guard let buttonText = cell.myButton.titleLabel?.text else {
            cell.myButton.backgroundColor = .blue
            return
            
        }
        if Int(buttonText) == nthTab {
            guard indexPath.row == derivedArray.endIndex, derivedArray[indexPath.row] == derivedArray.last else {
                nthTab += 1
                return
            }
            cell.myButton.backgroundColor = .red
            let alert = UIAlertController(title: "성공", message: "순서 맞추기 성공", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            cell.myButton.backgroundColor = .yellow
            let alert = UIAlertController(title: "실패", message: "순서 맞추기 실패", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return originalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as?
                    MyCollectionViewCell else {
                return UICollectionViewCell()
            }
        cell.myButton.setTitle( String(derivedArray[indexPath.row]), for: .normal)
        cell.myButton.titleLabel?.textAlignment = .center
            
            return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}


