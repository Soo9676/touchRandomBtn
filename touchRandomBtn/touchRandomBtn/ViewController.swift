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
    @IBOutlet weak var timerButton: UIButton!
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    var originalArray: Array<Int> = [1,2,3,4,5,6,7,8,9]
    var derivedArray: Array<Int> = [1,2,3,4,5,6,7,8,9]
    var nthTab: Int = 1
    
    var timer: Timer?
    var timerNum: Int = 0
    
    func startTimer() {
        if timer != nil, timer!.isValid {
            timer!.invalidate()
        }
        
        timerNum = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallBack() {
        self.timerButton.setTitle("\(timerNum)", for: .normal)
        //cell들을 배열에 담음
        let cells = self.collectionView.visibleCells
        //각 cell들의 indexPath를 받아옴
        let indexPaths = self.collectionView.indexPath(for: cells[0])
        
        
        for i in 0...8 {
            if i == timerNum {
                for cell in cells {
                    guard let cell = cell as? MyCollectionViewCell else {return}
                    if cell.myButton.titleLabel?.text == String(timerNum + 1) {
                        cell.contentView.isHidden = false
                    } else {
                        cell.contentView.isHidden = true
                    }
                }
            }
        }
//        switch timerNum {
//        case 0:
//            
//        case 1:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 2:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 3:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 4:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 5:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 6:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 7:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        case 8:
//            for cell in cells {
//                guard let cell = cell as? MyCollectionViewCell else {return}
//                if cell.myButton.titleLabel?.text == String(timerNum + 1) {
//                    cell.contentView.isHidden = false
//                } else {
//                    cell.contentView.isHidden = true
//                }
//            }
//        
//        default:
//            print("cannot update cell")
//        }
        
        timerNum += 1
        
        if timerNum == 10 {
            for cell in cells {
                guard let cell = cell as? MyCollectionViewCell else {return}
                cell.contentView.isHidden = true
            }
            timer?.invalidate()
            timer = nil
        }
    }
    func showButtonsInOrder() {
        for (index, element) in derivedArray.enumerated(){
            print("\(index)번째 element of derivedArray \(element) appeared")
            //cell 업데이트
        }
    }
    
    func resetNthTab() {
        nthTab = 1
    }
    
//    func resetButtonsOrder() {
//        derivedArray = originalArray
//        collectionView.reloadData()
//    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        let cells = self.collectionView.visibleCells
        for cell in cells {
            guard let cell = cell as? MyCollectionViewCell else {return}
            cell.contentView.isHidden = true
        }
        derivedArray = originalArray.shuffled()
        collectionView.reloadData()
        nthTab = 1
        showButtonsInOrder()
        startTimer()
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // collectionView 에서 cell 을 가지고 옴. Optional 주의
        guard let cell =  collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else {
            return
        }
        // cell 에서 텍스트가 있는지 확인
        guard let buttonText = cell.myButton.titleLabel?.text else {
            return
        }
        //섞이지 않으면 경고창 띄우기
        guard !(derivedArray == originalArray) else {
            let alert = UIAlertController(title: "경고", message: "아직 섞이지 않음\n버튼을 섞어 게임을 시작하시겠습니까?🕹", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: tapStartButton(_:))
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        
        //몇번쨰 탭인지 비교
        if Int(buttonText) == nthTab {
            //선택한 셀이 마지막 셀이면 성공화면, 틀리면 실패화면, 순서는 맞지만 마지막이 아니라면 nthTab 1 증가시킨 후 통과
            guard Int(buttonText) == derivedArray.count else {
                nthTab += 1
                cell.myButton.backgroundColor = .yellow
                cell.contentView.isHidden = false
                return
            }
            cell.myButton.backgroundColor = .blue
            let alert = UIAlertController(title: "성공", message: "순서 맞추기 성공🥳", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            cell.myButton.backgroundColor = .red
            let alert = UIAlertController(title: "실패", message: "순서 맞추기 실패🥲\n리셋하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "새로", style: .destructive, handler: tapStartButton(_:))
            let cancelAction = UIAlertAction(title: "이어서", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
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
        cell.myButton.backgroundColor = .clear
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


