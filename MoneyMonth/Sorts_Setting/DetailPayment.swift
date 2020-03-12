//
//  DetailPayment.swift
//  MPC
//
//  Created by Nekokichi on 2020/02/25.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class DetailPayment: UIViewController {
    

    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var paymentSpan1: UILabel!
    @IBOutlet weak var paymentSpan2: UILabel!
    @IBOutlet weak var paymentDay: UILabel!
    @IBOutlet weak var paymentPrice: UILabel!
    
    //Setting.swiftで選択したセルのindexPath.rowを保持する
    var indexpath = Int()
    //UserDefault
    let ud = UserDefaults.standard
    //UDのデータ
    var ud_data = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //UDのデータを取得
        if let data = ud.object(forKey: "paymentData") {
            ud_data = data as! [[Any]]
        }
        //label.textに代入していく
        paymentName.text = (ud_data[indexpath][0] as! String)
        paymentSpan1.text = "\(ud_data[indexpath][1])/\(ud_data[indexpath][2])"
        paymentSpan2.text = "\(ud_data[indexpath][3])/\(ud_data[indexpath][4])"
        paymentDay.text = "\(ud_data[indexpath][5])日"
        paymentPrice.text = "¥\(ud_data[indexpath][6])"

    }
    
    //アラーム
    func alert(_ style: UIAlertController.Style, _ message:String) {
        //アラートを生成
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: style)
        //OK
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            //UDのindexpath番目のデータを削除
            self.ud_data.remove(at: self.indexpath)
            //UDに現在のud_dataを保存する
            self.ud.set(self.ud_data, forKey: "paymentData")
            //戻る
            self.dismiss(animated: true, completion: nil)
        }
        //キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //追加
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        //アラートを表示する
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        //アラート
        alert(.alert, "\(ud_data[indexpath][0])のデータを削除しますか？")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
