//
//  ViewController.swift
//  Gradiate
//
//  Created by Fabrice Ulysse on 11/29/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//

import UIKit

//protocol ChangeDelegate: class {
//    func changeRedButtonTitle(text: String)
//
//}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NavViewControllerDelegate {
    
    var gradientCollectionView: UICollectionView!
    var gradientsArray: [UIImage]! = []
    var imagePicker: UIImagePickerController!
    var tracker = 0
    var imageData: String!
    let CellReuseIdentifier = "CellReuseIdentifier"
    let padding: CGFloat = 10
    var selectedIndices: [Int] = []
    var savedImages: [Savedimage] = []
    
    //    weak var delegate: ChangeDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    var button: UIImageView!
    var button: UIBarButtonItem!
    var delete: UIButton!
    var save: UIButton!
    var share: UIButton!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Gradiate"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var photoButton: UIBarButtonItem!
        var uploadButton: UIBarButtonItem!

        //let dog = Gradient(imageName: "gradient")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        gradientCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gradientCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gradientCollectionView.backgroundColor = .white
        gradientCollectionView.allowsMultipleSelection = true
        gradientCollectionView.delegate = self
        gradientCollectionView.dataSource = self
        gradientCollectionView.alwaysBounceVertical = true
        //        gradientCollectionView.refreshControl = refreshControl
        gradientCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CellReuseIdentifier)
        //        restaurantCollectionView.register(FilterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: filterReuseIdentifier)
        
        Network.getGradients { (savedImages) in
            self.savedImages = savedImages
            for savedImage in savedImages{
                let data = NSData(base64Encoded: savedImage.base64)
                self.gradientsArray.append(UIImage(data: data! as Data)!)
                
            }
            self.gradientCollectionView.reloadData()
        }
        view.addSubview(gradientCollectionView)
        

        
        
        delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        let trash = UIImage(named: "trash")
        delete.setImage(trash, for: .normal)
        delete.addTarget(self, action: #selector(deletion), for: .touchUpInside)
        view.addSubview(delete)
        
        share = UIButton()
        share.translatesAutoresizingMaskIntoConstraints = false
        let shareIcon = UIImage(named: "share")
        share.setImage(shareIcon, for: .normal)
        share.addTarget(self, action: #selector(shareImageButton(_:)), for: .touchUpInside)
        view.addSubview(share)
        
        let camera = UIImage(named: "camera")
        photoButton = UIBarButtonItem(image: camera, style: .plain, target: self, action: #selector(takePhoto))

       
        
        let upload = UIImage(named: "upload")
        uploadButton = UIBarButtonItem(image: upload, style: .plain, target: self, action: #selector(openPhotoLibraryButton(sender:)))
        navigationItem.rightBarButtonItems = [photoButton, uploadButton]
        
        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gradientCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            gradientCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            delete.topAnchor.constraint(equalTo: gradientCollectionView.bottomAnchor),
            delete.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -30),
            delete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        NSLayoutConstraint.activate([
            share.topAnchor.constraint(equalTo: gradientCollectionView.bottomAnchor),
            share.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 30),
            share.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
        } else {
            print("Unable to take photo")
        }
    }
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func deletion() {
        var imageIDs: [Int] = []
        selectedIndices.forEach { (index) in
            let savedImage = savedImages[index]
            imageIDs.append(savedImage.id)
        }
        Network.deleteGradient(imageIDs: imageIDs) {
            Network.getGradients { (savedImages) in
                self.savedImages = savedImages
                self.gradientsArray = []
                for savedImage in savedImages{
                    let data = NSData(base64Encoded: savedImage.base64)
                    
                    self.gradientsArray.append(UIImage(data: data! as Data)!)
                    
                }
                self.gradientCollectionView.reloadData()
            }
        }
    }
    @IBAction func shareImageButton(_ sender: UIButton) {
        var selectedImages: [UIImage] = []
        selectedIndices.forEach { (index) in
            selectedImages.append(gradientsArray[index])
        }
        let activityViewController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //photos.append(image!)
        tracker = tracker + 1
        imageData = image?.jpegData(compressionQuality: 0.5)?.base64EncodedString()
        let navViewController = NavViewController(imageData: imageData)
        navViewController.delegate = self
        navigationController?.pushViewController(navViewController, animated: true)
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    //data source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier, for: indexPath) as! CollectionViewCell
        let gradient = gradientsArray[indexPath.item]
        cell.configure(with: gradient)
        cell.setNeedsUpdateConstraints()
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gradientCollectionView {
            return gradientsArray.count
            
        }
        return gradientsArray.count
        
    }
    //delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndices.append(indexPath.item)
        print(self.selectedIndices)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedIndices.firstIndex(of: indexPath.item) {
            selectedIndices.remove(at: index)
        }
    }
    
    //delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (gradientCollectionView.frame.width - padding*2)
        return CGSize(width: width, height: 100)
        
        
    }
    func addImage() {
        Network.getGradients { (savedImages) in
            self.savedImages = savedImages
            self.gradientsArray = []
            for savedImage in savedImages{
                let data = NSData(base64Encoded: savedImage.base64)
                self.gradientsArray.append(UIImage(data: data! as Data)!)
                
            }
            print(self.gradientsArray)
            self.gradientCollectionView.reloadData()
        }
    }
    

    
}

