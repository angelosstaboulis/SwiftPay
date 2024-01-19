//
//  ViewController.swift
//  SwiftPay
//
//  Created by Angelos Staboulis on 18/1/24.
//

import UIKit
import PassKit
class ViewController: UIViewController,PKPaymentAuthorizationViewControllerDelegate {
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var txtCurrencyCode: UITextField!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
    }

    
    @IBAction func btnApplePay(_ sender: Any) {
        do{
            let request = PKPaymentRequest()
            request.countryCode = txtCountryCode.text!
            request.currencyCode = txtCurrencyCode.text!
            request.supportedNetworks = [.visa,.amex]
            request.merchantIdentifier = "merchant.com.template.pay"
            let contact = PKContact()
            contact.name = try .init(txtName.text!)
            contact.emailAddress = txtEmail.text
            contact.phoneNumber = .init(stringValue: txtPhoneNumber.text!)
            request.billingContact = contact
            request.paymentSummaryItems = [.init(label: "Summary", amount:.init(decimal:try Decimal(txtAmount.text!, format: .number)))]
            request.merchantCapabilities = .credit
            if PKPaymentAuthorizationViewController.canMakePayments(){
                guard let paymentRequest = PKPaymentAuthorizationViewController(paymentRequest: request) else{
                    debugPrint("something went wrong!!!")
                    return
                }
                paymentRequest.delegate = self
                paymentRequest.modalPresentationStyle = .fullScreen
                self.present(paymentRequest, animated: true)
            }
        }catch{
            debugPrint("something went wrong!!!!")
        }
    }
}
extension ViewController{
    func setupView(){
        let guide = view.safeAreaLayoutGuide
        btnPay.translatesAutoresizingMaskIntoConstraints = false
        btnPay.layer.cornerRadius = 16
        btnPay.tintColor = .white
        btnPay.widthAnchor.constraint(equalTo:guide.widthAnchor, multiplier: 0.9).isActive = true
        btnPay.centerXAnchor.constraint(equalToSystemSpacingAfter: guide.centerXAnchor, multiplier: 0).isActive = true
        btnPay.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0.3).isActive = true
        btnPay.layer.backgroundColor = UIColor.blue.cgColor
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        debugPrint("payment was successfull")
    }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        debugPrint("payment was finished")
        controller.dismiss(animated: true)
    }
}
