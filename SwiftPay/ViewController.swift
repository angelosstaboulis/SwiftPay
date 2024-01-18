//
//  ViewController.swift
//  SwiftPay
//
//  Created by Angelos Staboulis on 18/1/24.
//

import UIKit
import PassKit
class ViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var txtCurrencyCode: UITextField!
    
    @IBOutlet weak var txtAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let guide = view.safeAreaLayoutGuide
       
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
                paymentRequest.modalPresentationStyle = .fullScreen
                self.present(paymentRequest, animated: true)
            }
        }catch{
            debugPrint("something went wrong!!!!")
        }
    }
}

