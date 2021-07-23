//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendProfileOKDelegate{
    
    
    
    
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var sendToDBModel = SendToDBModel()
    
    var urlString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        sendToDBModel.sendProfileOKDelegate = self
        
        
    }
    
    func SendProfileOKDelegate(url: String) {
        urlString = url
        //urlが返ってきているかどうか？
        if urlString.isEmpty != true {
            //画面が遷移
            self.performSegue(withIdentifier: "chat", sender: nil)
        }
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        //カメラからアルバムから？
        
        //アラートを出す
        showAlert()
        
    }
    @IBAction func register(_ sender: Any) {
        //emailtextfield,passwordtextfieldが空でない、
        if emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true, let image = profileImageView.image {
            
            //アカウントを作成する　クロージャーは一旦後ろがよばれて結果がresultに入る
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result,error ) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                //jpegデータに変換している
                let data = image.jpegData(compressionQuality: 1.0)
                
                self.sendToDBModel.sendProfileImageData(data: data!)
            }
            
        }
        
        //登録
        
        //emailtextfield,profileimage値
    }
    
    //カメラ立ち上げメソッド
    
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    //アルバム
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    //カメラ機能が終了した時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectedImage = info[.originalImage] as! UIImage
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    //カメラがキャンセルされた時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //アラート
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
            
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
            
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
