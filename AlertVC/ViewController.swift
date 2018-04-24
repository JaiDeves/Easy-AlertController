//
//  ViewController.swift
//  AlertVC
//
//  Created by Jai Deves on 4/24/18.
//  Copyright © 2018 Vibrant Info. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var alertTypeLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var styleSwitch: UISwitch!
    
    var style:UIAlertControllerStyle{
        return styleSwitch.isOn ? .alert : .actionSheet
    }
    
    override func viewDidLoad() {
        styleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc func switchValueChanged(){
        alertTypeLabel.text = styleSwitch.isOn ? "Alert" : "ActionSheet"
    }
    
    @IBAction func autoDismiss(_ sender: UIButton) {
        alert(title: "", message: "I'll make You laugh in 5 secs", style: style,autoDismissTime: 5.0)
        alert(title: "Alert", message: "Auto dismiss in 4 sec", autoDismissTime: 4.0)
    }
    
    @IBAction func normalOK(_ sender: UIButton) {
        alert(title: "Do you Love me?", message: "Please accept my love", style: style, autoDismissTime: nil, actionTitles: ["OK"], actions: [{ [weak self] in
                self?.outputLabel.text = "I told ya, you'll laugh"
            }], completion: nil)
    }
    
    
    @IBAction func confirmation(_ sender: UIButton) {
        alert(title: "Life is all about actions", message: "Choose your actions wisely", style: style, autoDismissTime: nil, actionTitles: ["OK","CANCEL"], actions: [{ [weak self] in
                self?.outputLabel.text = "You've choosen wisley"
            },{ [weak self] in
                self?.outputLabel.text = "Comeback again"
            }], completion: nil)
    }
    
    
    @IBAction func prompt(_ sender: UIButton) {
        var nameTextField:UITextField?
        alert(title: "Hey beautiful", message: "What's your name?", style: style, autoDismissTime: nil, actionTitles: ["This is my name","I don't know you"], actions: [{ [weak self] in
                self?.outputLabel.text = "Thanks \(nameTextField?.text ?? "") for trusting me"
            },{[weak self] in
                self?.outputLabel.text = "Let's have a cup of coffee then"
            }], prompts: [{ textfield in
                //Configure textfield
                textfield.textColor = UIColor.orange
                nameTextField = textfield
                }], completion: nil)
    }
}


extension UIViewController{
    func alert(title:String,message:String?,style:UIAlertControllerStyle = .alert,autoDismissTime:Double?,actionTitles:[String]? = nil,actions:[(()->Void)?]? = nil,prompts:[(UITextField)->Void]? = nil, completion:(()->Void)? = nil){
        
        var style = style
        // AlertStyle with texfield are not supported
        if prompts != nil,prompts!.count > 0{
            style = .alert
        }
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: style)
        if let actionTitles = actionTitles{
            for index in 0..<actionTitles.count{
                let action = UIAlertAction(title: actionTitles[index], style: .default) { (alertAction) in
                    if let nnlAction = actions?[safe:index]{  nnlAction?() }
                }
                alertVC.addAction(action)
            }
        }
        if let prompt = prompts{
            for index in 0..<prompt.count{
                alertVC.addTextField { (textField) in
                    prompt[safe:index]?(textField)
                }
            }
        }
        self.present(alertVC, animated: true, completion: completion)
        
        if let dismisTime = autoDismissTime{
            DispatchQueue.main.asyncAfter(deadline: .now() + dismisTime) {
                alertVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//To check whether an element exist at an index
extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
