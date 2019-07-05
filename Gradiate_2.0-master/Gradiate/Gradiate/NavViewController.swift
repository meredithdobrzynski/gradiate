//
//  NavViewController.swift
//  Gradiate
//
//  Created by Nainika D'Souza on 11/29/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//

import UIKit

protocol NavViewControllerDelegate {
    func addImage()
    
}

class NavViewController: UIViewController {
    var gradientImage: UIImageView!
    var imageData: String

    // these colors are hardcoded but I guess input the dominant colors here ?
    //colors have to be cgColors to work
    var color1: UIColor!
    var color2: UIColor!
    var color3: UIColor!
    var image: UIImage!
    var gradientLayer: CAGradientLayer!
    var saveButton: UIBarButtonItem!
    var delegate: NavViewControllerDelegate!
    var loadingImageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!

    init (imageData: String) {
        self.imageData = imageData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func gradiatePictures(){
        Network.gradiatePictures(image: imageData) { (colors) in

            let color1 = UIColor(displayP3Red: CGFloat(colors[0].red)/255.0, green: CGFloat(colors[0].green)/255.0, blue: CGFloat(colors[0].blue)/255.0, alpha: 1).cgColor
            let color2 = UIColor(displayP3Red: CGFloat(colors[1].red)/255.0, green: CGFloat(colors[1].green)/255.0, blue: CGFloat(colors[1].blue)/255.0, alpha: 1).cgColor
            let color3 = UIColor(displayP3Red: CGFloat(colors[2].red)/255.0, green: CGFloat(colors[2].green)/255.0, blue: CGFloat(colors[2].blue)/255.0, alpha: 1).cgColor
            
            self.gradientLayer = CAGradientLayer()
//            self.gradientLayer.frame = CGRect(x: 110, y: 150, width: 200, height: 400)
            self.gradientLayer.locations = [0.0, 0.5, 1.0]
            self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            self.gradientLayer.frame = self.view.bounds
            self.gradientLayer.colors = [color1, color2, color3]
            self.view.layer.insertSublayer(self.gradientLayer, at: 0)
            UIGraphicsBeginImageContext(CGSize(width: self.gradientLayer.frame.width, height:self.gradientLayer.frame.height))
            self.gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gradiate"
        view.backgroundColor = .white
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

        gradiatePictures()
        
        saveButton = UIBarButtonItem()
        saveButton.title = "Save Gradient"
        saveButton.target = self
        saveButton.action = #selector(savePhoto)
        navigationItem.rightBarButtonItem = saveButton
    }

    
    @IBAction func savePhoto(sender: UIBarButtonItem) {
        Network.uploadGradient(image: (self.image.jpegData(compressionQuality: 0.5)?.base64EncodedString())!) { () -> (Void) in
            self.delegate.addImage()
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.pushViewController(home_screen, animated: false)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

