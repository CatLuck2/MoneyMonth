//
//  Setting.swift
//  MPC
//
//  Created by Nekokichi on 2020/02/24.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class Setting: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //UserDefault
    let ud = UserDefaults.standard
    //UDのデータ用
    var ud_data = [[Any]]()
    //支払いの名前
    var payment_name = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //userDefaultの名前をpayment_nameに格納していく
        if let data = ud.object(forKey: "paymentData") {
            ud_data = data as! [[Any]]
        }
        
        //datasource,delegate
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        
        //カスタムセルを登録
        tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil), forCellReuseIdentifier: "addCustomCell")
        
        //空のセルを非表示風に
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //viewをリロード
        self.viewDidLoad()
        //tableViewをリロード
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //末尾に”追加する”のセルを追加
        payment_name.append("+")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //末尾のセルも含めるので、+1
        return ud_data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //末尾の時は＋を表示
//        print(ud_data)
//        print(indexPath.row)
        if indexPath.row == ud_data.count  {
            cell.textLabel?.text = "＋追加する"
            cell.textLabel?.textColor = .blue
            cell.textLabel?.textAlignment = .center
        //それ以外はud_dataの名前を表示
        } else {
            cell.textLabel?.text = (ud_data[indexPath.row][0] as! String)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //+を押したら入力画面に、それ以外は編集画面に
        if indexPath.row == ud_data.count {
            performSegue(withIdentifier: "goinput", sender: nil)
        } else {
            performSegue(withIdentifier: "goedit", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //DetailPaymentに該当するindexPath.rowを渡す
        if segue.identifier == "goedit" {
            guard let vc = segue.destination as? DetailPayment else { return }
            vc.indexpath = sender as! Int
        }
    }

}
