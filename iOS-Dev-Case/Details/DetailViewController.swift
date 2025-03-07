//
//  DetailViewController.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    private let userNameLabel = UILabel()
    private let userUsernameLabel = UILabel()
    private let userEmailLabel = UILabel()
    private let userWebsiteLabel = UILabel()
    private let userPhoneLabel = UILabel()
    private let userAddressLabel = UILabel()
    private let userCompanyNameLabel = UILabel()
    private let userCompanyCatchPhraseLabel = UILabel()
    private let userCompanyBSLabel = UILabel()

    private var viewModel: DetailViewModel!
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBindings()
    }

    // Dependency Injection
    func configure(with viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Section Titles
        let personalInfoTitleLabel = createSectionTitleLabel(with: "Personal Information")
        let companyTitleLabel = createSectionTitleLabel(with: "Company")

        view.addSubview(personalInfoTitleLabel)
        view.addSubview(companyTitleLabel)

        // Add labels to the view
        let labels = [
            userNameLabel, userUsernameLabel, userEmailLabel,
            userWebsiteLabel, userPhoneLabel, userAddressLabel,
            userCompanyNameLabel, userCompanyCatchPhraseLabel, userCompanyBSLabel
        ]
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textColor = UIColor.label
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            view.addSubview($0)
        }

        // Layout for sections
        NSLayoutConstraint.activate([
            personalInfoTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            personalInfoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            companyTitleLabel.topAnchor.constraint(equalTo: userAddressLabel.bottomAnchor, constant: 30),
            companyTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

        // Layout for labels
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: personalInfoTitleLabel.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userUsernameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userUsernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userUsernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userEmailLabel.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor, constant: 8),
            userEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userWebsiteLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 8),
            userWebsiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userWebsiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userPhoneLabel.topAnchor.constraint(equalTo: userWebsiteLabel.bottomAnchor, constant: 8),
            userPhoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userPhoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userAddressLabel.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 8),
            userAddressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userCompanyNameLabel.topAnchor.constraint(equalTo: companyTitleLabel.bottomAnchor, constant: 8),
            userCompanyNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userCompanyNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userCompanyCatchPhraseLabel.topAnchor.constraint(equalTo: userCompanyNameLabel.bottomAnchor, constant: 8),
            userCompanyCatchPhraseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userCompanyCatchPhraseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userCompanyBSLabel.topAnchor.constraint(equalTo: userCompanyCatchPhraseLabel.bottomAnchor, constant: 8),
            userCompanyBSLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userCompanyBSLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func createSectionTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.label
        return label
    }

    private func setBindings() {
        viewModel.$name
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userNameLabel.attributedText = self?.createAttributedString(prefix: "Name", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$username
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userUsernameLabel.attributedText = self?.createAttributedString(prefix: "User Name", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$email
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userEmailLabel.attributedText = self?.createAttributedString(prefix: "Email", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$website
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userWebsiteLabel.attributedText = self?.createAttributedString(prefix: "Website", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$phone
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userPhoneLabel.attributedText = self?.createAttributedString(prefix: "Phone", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$address
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userAddressLabel.attributedText = self?.createAttributedString(prefix: "Address", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$companyName
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userCompanyNameLabel.attributedText = self?.createAttributedString(prefix: "Name", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$companyCatchPhrase
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userCompanyCatchPhraseLabel.attributedText = self?.createAttributedString(prefix: "Catch Phrase", text: text)
            }
            .store(in: &subscriptions)

        viewModel.$companyBS
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.userCompanyBSLabel.attributedText = self?.createAttributedString(prefix: "BS", text: text)
            }
            .store(in: &subscriptions)
    }
    
    private func createAttributedString(prefix: String, text: String) -> NSAttributedString {
        let fullString = "\(prefix): \(text)"
        let attributedString = NSMutableAttributedString(string: fullString)
        

        let boldRange = NSRange(location: 0, length: prefix.count + 1)
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 16, weight: .heavy),
            .foregroundColor: UIColor.label
        ], range: boldRange)
        

        let normalRange = NSRange(location: boldRange.length, length: text.count + 1)
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ], range: normalRange)
        
        return attributedString
    }
}
