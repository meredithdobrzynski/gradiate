//
//  CollectionViewCell.swift
//  Gradiate
//
//  Created by Nainika D'Souza on 11/29/18.
//  Copyright © 2018 Gradiate. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var photoImageView: UIImageView!
    let padding: CGFloat = 10
    
    override var isSelected: Bool{
        didSet {
            if (isSelected) {
                photoImageView.layer.borderWidth = 3
            } else {
                photoImageView.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        
        photoImageView = UIImageView(frame: .zero)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleToFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.borderWidth = 0
        photoImageView.layer.borderColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1).cgColor
        
        contentView.addSubview(photoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateConstraints(){
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        super.updateConstraints()
        
    }
    func configure(with gradient: UIImage){
        photoImageView.image = gradient
        
    }
}

