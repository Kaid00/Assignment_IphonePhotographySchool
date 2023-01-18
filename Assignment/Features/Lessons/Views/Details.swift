//
//  MyView.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 18/01/2023.
//

import UIKit

class Details: UIView {
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "The Key To Success In iPhone Photography"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "What’s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there’s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!"
        return label
    }()
    
    private let nextLesson: UIButton = {
       
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.right")

        let imageString = NSMutableAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: "Next lesson")
        imageString.append(textString)

        let label = UILabel()
        label.attributedText = imageString
        label.sizeToFit()
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
//        button.setTitle("Next lesson", for: .normal)
        button.setAttributedTitle(imageString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()

    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "background")
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(nextLesson)
        
        configureConstraints()

    }
    
    func configureConstraints() {

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        let nextLessonConstraints = [
            nextLesson.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 200),
            nextLesson.widthAnchor.constraint(equalToConstant: 140),
            nextLesson.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(nextLessonConstraints)
        
    }

    public func configure(with model: LessonObj) {
        titleLabel.text = model.name
        descriptionLabel.text = model.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init")
    }
}
