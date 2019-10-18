//
//  ViewController.swift
//  RandomFace
//
//  Created by TrungNV on 10/15/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import UIKit
import DTPhotoViewerController

class ViewController: UIViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var listWinnerView: UIView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var winnerTableView: UITableView!
    @IBOutlet weak var lblNumberOfWinner: UILabel!
    
    @IBOutlet weak var widthOfCollectionview: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    let banerPerson = PersonBO(name: "Chúc mừng ngày 20/10", timeTamp: "banner", image: UIImage(named: "img_baner") ?? UIImage())
    let lstSpeedEnd = [0.1, 0.2, 0.3, 0.4, 0.5, 1.0, 1.4, 1.8, 2.1, 2.3] // 3 -> 0.5
    let lstSpeedStart = [0.1, 0.2, 0.4, 0.6, 0.8] // 1.5 -> 0.5
    var lstOriginImages = [PersonBO]()
    var lstOriginClone = [PersonBO]()
    var lstCloneImages = [PersonBO]()
    var lstWinner = [PersonBO]()
    var lastIndex: Int?
    var isFirstShow: Bool = true
    
    var isPlaying: Bool = false{
        willSet{
            btnStart.isEnabled = !newValue
            winnerTableView.isUserInteractionEnabled = !newValue
            btnBack.isEnabled = !newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        cloneOriginImages()
        createShowImages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstShow{
            reloadCollectionView()
            reloadTableView()
            isFirstShow = false
        }
    }
    
    // MARK: - init functions
    func initData(){
        lstOriginImages = Constant.getLstPerson()
    }
    
    func cloneOriginImages(){
        lstOriginClone.removeAll()
        for item in lstOriginImages{
            lstOriginClone.append(item.clone())
        }
    }
    
    func createShowImages(){
        lstCloneImages.removeAll()
        
        if lstOriginClone.count > 0{
            for _ in 0...19{
                let randPerson = lstOriginClone[Int.random(in: 0..<lstOriginClone.count)]
                lstCloneImages.append(randPerson)
            }
        }
        
        lstCloneImages.insert(banerPerson, at: 0)
    }
    
    
    func reloadTableView(){
        lblNumberOfWinner.text = "(\(lstWinner.count))"
        winnerTableView.reloadData()
    }
    
    func reloadCollectionView(){
        widthOfCollectionview.constant = scrollView.frame.width * CGFloat(lstCloneImages.count)
        mainCollectionView.reloadData()
        UIView.animate(withDuration: 0.01) {
            self.scrollView.contentOffset.x = 0
            self.mainCollectionView.contentOffset.x = 0
        }
    }
    
    
    func initUI(){
        btnStart.setRadius(btnStart.frame.height / 2)
        listWinnerView.setRadius(8.0)
        listWinnerView.createShadow()
        mainCollectionView.setRadius(8.0)
        initCollectionView()
        initTableView()
    }
    
    
    func initCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
    }
    
    func initTableView(){
        winnerTableView.delegate = self
        winnerTableView.dataSource = self
        winnerTableView.register(UINib(nibName: "WinersCell", bundle: nil), forCellReuseIdentifier: "WinersCell")
    }
    
    //MARK: - Actions
    @IBAction func startAction(_ sender: Any) {
        
        if lstOriginClone.count < 2{
            return
        }
        if let last = lastIndex{
            lstOriginClone = lstOriginClone.filter{$0.timeTamp != lstCloneImages[last].timeTamp}
            createShowImages()
            lastIndex = nil
            reloadCollectionView()
            
            if lstOriginClone.count < 1{
                return
            }
        }
        
        // random number
        let randWinner = lstOriginClone[Int.random(in: 0..<lstOriginClone.count)].clone()
        lstCloneImages.append(randWinner)
        isPlaying = true
        scrollTo(currentIndex: 1, maxIndex: lstCloneImages.count - 1)
    }
    
    func scrollTo(currentIndex: Int,maxIndex: Int) {
        var duration: CGFloat = 0.5
        let bottomEdge = lstSpeedStart.count - 1
        let topEdge = maxIndex - lstSpeedEnd.count
        if lstCloneImages.count >  (lstSpeedStart.count + lstSpeedEnd.count + 2){
            if currentIndex < bottomEdge{
                duration = CGFloat(1.5 - lstSpeedStart[currentIndex])
            }
            
            if currentIndex > topEdge{
                duration = CGFloat( 3 - lstSpeedEnd[maxIndex - currentIndex])
            }
        }
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.scrollView.contentOffset.x = CGFloat(currentIndex) * self.scrollView.frame.width
        }) { (complete) in
            if currentIndex < (maxIndex - 1){
                self.scrollTo(currentIndex: currentIndex + 1, maxIndex: maxIndex)
            }else{
                // add winner to winner list
                self.lastIndex = currentIndex
                if currentIndex <= self.lstCloneImages.count - 1{
                    self.lstWinner.insert(self.lstCloneImages[currentIndex], at: 0)
                }
                self.reloadTableView()
                self.isPlaying = false
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstCloneImages.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell
        cell!.imgMain.image = lstCloneImages[indexPath.row].image
        cell?.lblName.text = lstCloneImages[indexPath.row].name
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstWinner.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = winnerTableView.dequeueReusableCell(withIdentifier: "WinersCell", for: indexPath) as? WinersCell
        cell?.configCell(lstWinner[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // swipe to delete cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let last = lastIndex{
            lstOriginClone = lstOriginClone.filter{$0.timeTamp != lstCloneImages[last].timeTamp}
            createShowImages()
            lastIndex = nil
            reloadCollectionView()
        }
        
        // remove collectionview data
        lstOriginClone.append(lstWinner[indexPath.row])
        createShowImages()
        reloadCollectionView()
        
        winnerTableView.beginUpdates()
        lstWinner.remove(at: indexPath.row)
        winnerTableView.deleteRows(at: [indexPath], with: .none)
        winnerTableView.endUpdates()
        
        lblNumberOfWinner.text = "(\(lstWinner.count))"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? WinersCell
        let viewController = DTPhotoViewerController(referencedView: cell?.img_avatar, image: lstWinner[indexPath.row].image)
        self.present(viewController, animated: true, completion: nil)
    }
}

