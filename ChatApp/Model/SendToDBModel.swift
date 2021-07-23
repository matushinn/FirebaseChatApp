//
//  SendToDBModel.swift
//  ChatApp
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import Foundation
import FirebaseStorage

protocol SendProfileOKDelegate {
    func SendProfileOKDelegate(url:String)
    
}

class SendToDBModel {
    var sendProfileOKDelegate:SendProfileOKDelegate?
    
    
    init() {
        
    }
    
    func sendProfileImageData(data:Data){
        
        //dataをUIIMage型に変換
        let image = UIImage(data: data)
        
        //0.1倍に圧縮する
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        
        //firebaseの保存先pathを決める
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //Firebase Storageに画像をおくる
        //データがあったら中身が呼ばれる。
        imageRef.putData(profileImageData!,metadata: nil) { (metaData,error ) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            //画像を読み込む(ダウンロード)
            imageRef.downloadURL { url, eroor in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                //chatで送信のため、画像のURLを保存しておく。
                UserDefaults.standard.setValue(url?.absoluteString, forKey:"userImage")
                
                //sendToDBModel.sendProfileOKDelegate = selfよりRegisterViewControllerに呼ばれる
                self.sendProfileOKDelegate?.SendProfileOKDelegate(url: url!.absoluteString)
            }
            //まずクロージャの外側が呼ばれる
        }
        
        
        
        
    }
}
