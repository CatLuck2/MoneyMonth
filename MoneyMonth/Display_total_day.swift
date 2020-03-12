//
//  Display_total_day.swift
//  MPC
//
//  Created by Nekokichi on 2020/02/24.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class Display_total_day: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var total_price_label: UILabel!
    
    //pageControll
    var pageControll = UIPageControl()
    
    //scrollVIew用のUIView
    let vc = UIView()
    
    //現在の年月を保持する
    var year_now = Int()
    var month_now = Int()
    //今表示されている年
    var currentYear = Int()
    //今表示されている月
    var currentMonth = Int()
    //表示月の合計金額
    var total_price = 0
    //0~11：去年、12~23：今年、24~35：来年
    //[Int:[Int]],
    var allYear:[Int] = [0,0,0]
    //1~12月の数字
    var allMonth = [1,2,3,4,5,6,7,8,9,10,11,12]
    //移動前のpageNumber
    var before_pageNumber = Int()
    //移動後のpageNumber
    var current_pageNumber = Int()
    
    //UserDefault
    let ud = UserDefaults.standard
    //UDのデータ用
    var ud_data = [[Any]]()
    //表示可能なUDのデータを格納
    var applicable_data = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UDを更新
        //userDefaultの名前をpayment_nameに格納していく
        if let data = ud.object(forKey: "paymentData") {
            ud_data = data as! [[Any]]
        }
        
        //UI部品の装飾
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.layer.borderWidth = 1.0

        //デリゲート群
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセル
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        tableView.separatorColor = .black
        //空のセルを非表示風に
        tableView.tableFooterView = UIView()
        
        //現在の年月を取得
        year_now = Calendar.current.component(.year, from: Date())
        month_now = Calendar.current.component(.month, from: Date())
        //表示年を今年に設定
        currentYear = year_now
        //scrollViewに表示させる年月を確定させる
        decide_year(year_now)
        
        //scrollViewのバーを消す
        scrollView.showsHorizontalScrollIndicator = false
        //scrollViewの初期位置を設定
        scrollView.contentOffset.x = CGFloat(375 * (month_now + 11))
        //pageNumberの変数の初期値を現在位置に
        current_pageNumber  = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        before_pageNumber = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        //scrollViewに要素を配置
        horizontal()
        if ud_data.count > 0 {
            //表示されている年に該当するデータを取り出す
            //表示年が変わるたびに実行する
            check_ud_data()
            check_dataofmonth()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //UDを更新
        if let data = ud.object(forKey: "paymentData") {
            ud_data = data as! [[Any]]
        }
        if ud_data.count > 0 {
            //表示されている年に該当するデータを取り出す
            //表示年が変わるたびに実行する
            check_ud_data()
            check_dataofmonth()
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ud_data.count > 0 {
            return applicable_data.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //UDのデータがなければ、
        if ud_data.count > 0 {
            let title = cell.viewWithTag(1) as! UILabel
            let date = cell.viewWithTag(2) as! UILabel
            let price = cell.viewWithTag(3) as! UILabel
            title.text = "\(applicable_data[indexPath.row][0])"
            date.text = "\(applicable_data[indexPath.row][5])日"
            price.text = "¥\(applicable_data[indexPath.row][6])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //スクロールが終わった時
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if ud_data.count > 0 {
            //現在のpageNumberを取得
            current_pageNumber = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
            //pageNumberがどの年に位置するかを判別
            check_pageNumber(before_pageNumber,current_pageNumber)
            //新しく表示された年に該当するデータを取り出す
            check_ud_data()
            //該当する月がデータに該当するかを確認
            check_dataofmonth()
            //移動したことを確認するために移動前のpageNumberを保持
            before_pageNumber = current_pageNumber
        }
    }
    
    //現在の年月を元に、去年と来年を算出
    func decide_year(_ year_now: Int) {
        for i in 0...2 {
            switch i {
            case 0:
                allYear[0] = year_now - 1
            case 1:
                allYear[1] = year_now
            case 2:
                allYear[2] = year_now + 1
            default:
                break
            }
        }
    }
    
    //scrollViewに要素を配置する
    func horizontal()  {
        vc.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width * 36, height: 63)
        let width = Int(self.scrollView.frame.size.width)
        for i in 0...35 {
            let label = UILabel()
            label.frame = CGRect(x: width / 2 + width * i - 50, y: 0, width: 100, height: 63)
            label.font = UIFont.systemFont(ofSize: 21.0)
            label.text = setting_labeltext(i)
            label.textAlignment = .center
            vc.addSubview(label)
        }
        scrollView.addSubview(vc)
        scrollView.contentSize = vc.bounds.size
    }
    
    //ud_dataから去年~来年に当てはまるデータを取り出す
    func check_ud_data() {
        //ud_dataの各期間のデータを格納
        var span1 = Int()
        var span2 = Int()
        //初期化
        applicable_data = [[Any]]()
//        print(ud_data)
        for i in 0...ud_data.count-1 {
            span1 = ud_data[i][1] as! Int
            span2 = ud_data[i][3] as! Int
            //期間1は今年以前のもの？
            if span1 <= self.currentYear  {
                //期間2は今年以降のもの？
                if span2 >= self.currentYear {
                    //期間1<=表示年<=期間2、を満たすなら、一時保存
                    applicable_data.append(ud_data[i])
                }
            }
        }
    }
    
    //表示年が変わってないかを確認
    func check_pageNumber(_ i1:Int, _ i2:Int) {
        //各pageNumberがどの範囲に属するかを示す変数
        var num1,num2:Int!
        //befor_pageNumber
        switch i1 {
        case 0...11:num1 = 1
        case 12...23:num1 = 2
        case 24...35:num1 = 3
        default:break
        }
        //current_pageNummber
        switch i2 {
        case 0...11:num2 = 1
        case 12...23:num2 = 2
        case 24...35:num2 = 3
        default:break
        }
        //ページが移動後、年は変わった？
        if num1 != num2 {
            //年を更新
            switch num2 {
            case 1:currentYear = allYear[0]
            case 2:currentYear = allYear[1]
            case 3:currentYear = allYear[2]
            default:break
            }
            //表示年に該当するデータを取り出す
            check_ud_data()
        }
    }
    
    //表示月が該当するかを確認
    func check_dataofmonth() {
        //現在のpageNumberから表示月を出す
        switch current_pageNumber {
        case 0...11:
            currentMonth = current_pageNumber + 1
        case 12...23:
            currentMonth = current_pageNumber - 11
        case 24...35:
            currentMonth = current_pageNumber - 23
        default:break
        }
        //for文で選出される削除される要素の番号
        var remove_number = [Int]()
        //合計金額の初期化
        total_price = 0
        //現在年に該当するデータで現在月に該当するデータを探す
        if applicable_data.count > 0 {
            for i in 0...applicable_data.count-1 {
                //print(i, applicable_data)
                //その月が該当するデータ以内かを調べる
                //月が該当しなければ、applicable_dataから削除する
                //年1==現在年、年2==現在年
                if (applicable_data[i][1] as? Int)! == currentYear && (applicable_data[i][3] as? Int)! == currentYear {
                    //月1と月2を表示月と比較
                    if (applicable_data[i][2] as? Int)! <= currentMonth && currentMonth <= (applicable_data[i][4] as? Int)! {
                                
                    } else {
                        //remove_numberに追加
                        remove_number.append(i)
                    }
                        //年1==現在年、年2>現在年
                } else if (applicable_data[i][1] as? Int)! == currentYear && (applicable_data[i][3] as? Int)! > currentYear {
                            if (applicable_data[i][2] as? Int)! <= currentMonth {
                                
                            } else {
                                //remove_numberに追加
                                remove_number.append(i)
                            }
                //年1<現在年、年2==現在年
                } else if (applicable_data[i][1] as? Int)! < currentYear && (applicable_data[i][3] as? Int)! == currentYear {
                            if currentMonth <= (applicable_data[i][4] as? Int)! {
                                
                            } else {
                                //remove_numberに追加
                                remove_number.append(i)
                            }
                //年1<現在年、年2>現在年
                } else if (applicable_data[i][1] as? Int)! < currentYear && (applicable_data[i][3] as? Int)! > currentYear {
                            
                }
            }
            //ramove_numberを大...小にソート
            remove_number = remove_number.sorted(by: {$0 > $1})
            //表示月に該当しないデータを削除
            if remove_number.count > 0 {
                for i in 0...remove_number.count-1 {
                    applicable_data.remove(at: remove_number[i])
                }
            }
        }
        if applicable_data.count > 0 {
            //最後に残ったデータの合計金額を算出
            for i in 0...applicable_data.count-1 {
                //金額を追加
                total_price += applicable_data[i][6] as! Int
            }
        } else {
            total_price = 0
        }
        //合計金額を表示
        total_price_label.text = "¥\(total_price)"
        //tableViewを更新
        self.tableView.reloadData()
    }
    
    //scrollView上のlabel.textを対応した年月にする
    func setting_labeltext(_ pageNumber: Int) -> String{
        switch pageNumber {
        //去年
        case 0...11:
            return "\(allYear[0])/\(pageNumber+1)"
        //今年
        case 12...23:
            return "\(allYear[1])/\(pageNumber-11)"
        //来年
        case 24...35:
            return "\(allYear[2])/\(pageNumber-23)"
        default:
            break
        }
        return ""
    }

}
