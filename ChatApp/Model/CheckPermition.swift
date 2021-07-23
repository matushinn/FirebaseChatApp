//
//  CheckPermition.swift
//  ChatApp
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import Foundation
import Photos

class CheckPermission {
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
                
            case .authorized:
                print("許可されてますよ")

            case .denied:
                    print("拒否")

            case .notDetermined:
                        print("notDetermined")
                
            case .restricted:
                        print("restricted")
                
            case .limited:
                print("limited")
            @unknown default: break
                
            }
            
        }
    }

}
