//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import Firebase
import SDWebImage


class ChatViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    //firestoreの初期化
    let db = Firestore.firestore()
    
    var roomName = String()
    
    var imageString = String()
    
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //tableViewCellの登録
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
            
        }
        
        if roomName == "" {
            roomName = "All"
        }
        
        self.navigationItem.title = roomName
        
        //メッセージをロードする
        loadMessage(roomName: roomName)
        
        
    }
    
    func loadMessage(roomName:String){
        //日付順に呼ぶ
        db.collection(roomName).order(by: "date").addSnapshotListener { (snapShot,error) in
            
            //初期化
            self.messages = []
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    //全てのデータがあるのならば
                    if let sender = data["sender"] as? String,let body = data["body"] as? String,let imageString = data["imageString"] as? String{
                        
                        let newMessage = Message(sender: sender, body: body, imageString: imageString)
                        
                        //新しいメッセージ型として保存していく。
                        self.messages.append(newMessage)
                        
                        //UIの更新
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            //順番は0からだから、配列の数とは１違う
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            
                            //一番最後に移動させている
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        
        //ラベルにメッセージを組み込む
        cell.label.text = message.body
        
        //自分だった場合？
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
            cell.rightImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.leftImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageString), completed: nil)
            cell.backView.backgroundColor = .systemTeal
            cell.label.textColor = .white
        }else{
            //相手だった場合全てが逆になる
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            
            cell.leftImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.rightImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageString), completed: nil)
            cell.backView.backgroundColor = .systemPink
            cell.label.textColor = .white
            
        }
        
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func send(_ sender: Any) {
        
        //message、現在ユーザーがいるかどうか？
        if let messagebody = messageTextField.text,let sender = Auth.auth().currentUser?.email{
            
            //データをセット
            db.collection(roomName).addDocument(data: ["sender":sender,"body":messagebody,"imageString":imageString,"date":Date().timeIntervalSince1970]) { (error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
            }
            
            //非同期処理、上の流れに沿わずこの中身を更新する　UIは迅速に更新したい
            DispatchQueue.main.async {
                //何かをしながらもUIは別で処理を行う
                //messagetextfieldは空にする
                self.messageTextField.text = ""
                //キーボードを閉じる
                self.messageTextField.resignFirstResponder()
            }
            
        }
    }
    

}
 
