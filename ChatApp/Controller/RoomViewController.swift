//
//  RoomViewController.swift
//  ChatApp
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import ViewAnimator

//viewanimatorは遷移を滑らかにする

class RoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var roomNameArray = ["誰でも話そうよ！","20代たまり場！","1人ぼっち集合","地球住み集合！！","好きなYoutuberを語ろう","大学生集合！！","高校生集合！！","中学生集合！！","暇なひと集合！","A型の人！！"]
    var roomImageStringArray = ["0","1","2","3","4","5","6","7","8","9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }

    //viewanimatorの処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        
        UIView.animate(views: tableView.visibleCells, animations: animation, completion:nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNameArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        imageView.image = UIImage(named: roomImageStringArray[indexPath.row])
        
        let label = cell.contentView.viewWithTag(2)  as! UILabel
        
        label.text = roomNameArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "roomChat", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let roomChatVC = segue.destination as! ChatViewController
        roomChatVC.roomName = roomNameArray[sender as! Int]
        
        
    }
    
}
