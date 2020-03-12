//
//  InputPayment.swift
//  MPC
//
//  Created by Nekokichi on 2020/02/25.
//  Copyright © 2020 Nekokichi. All rights reserved.
//
//datepickerで年月だけを表示させたい
//

import UIKit

class InputPayment: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //それぞれ、TextField,PickerView..,TextField、で入力する
    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentSpan1: UITextField!
    @IBOutlet weak var paymentSpan2: UITextField!
    @IBOutlet weak var paymentDay: UITextField!
    @IBOutlet weak var paymentPrice: UITextField!
    
    //pickerView用で表示させる月と日の変数
    let year = Array<Int>(2000...2050)
    let month = Array<Int>(1...12)
    let day = Array<Int>(1...31)
    //期間、支払日用のpickerView
    var pickerView = UIPickerView()
    //ツールバー用の仮変数
    var toolbar = UIToolbar()
    //textFieldを識別する変数
    var flag_textField = 1
    //入力した値を一時保存する変数
    //(名前)
    var name_input = ""
    //(期間1・期間2、支払日、月額料金)
    var value_input = [0,0,0,0,0,0]
    //UserDefault
    var ud = UserDefaults.standard
    //UDのデータを保持する変数
    var ud_data = [[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UDのデータを読み込む
        if let data = ud.object(forKey: "paymentData") {
            ud_data = data as! [[Any]]
        }
        
        //delegate,datasource
        //pickerViewの
        pickerView.delegate = self
        pickerView.dataSource = self
        //textFieldの
        paymentName.delegate = self
        paymentSpan1.delegate = self
        paymentSpan2.delegate = self
        paymentDay.delegate = self
        paymentPrice.delegate = self
        
        //ツールバー
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        //空白（スペース）
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        //完了ボタン
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        //空白と完了ボタンをツールバーにセット
        toolbar.setItems([spacelItem, doneItem], animated: true)
        //textFieldにpickerViewをセット
        paymentSpan1.inputView = pickerView
        paymentSpan2.inputView = pickerView
        paymentDay.inputView = pickerView
        //ツールバーをTextFiledに設定
        paymentName.inputAccessoryView = toolbar
        paymentSpan1.inputAccessoryView = toolbar
        paymentSpan2.inputAccessoryView = toolbar
        paymentDay.inputAccessoryView = toolbar
        paymentPrice.inputAccessoryView = toolbar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch flag_textField {
        case 1,2:
            return 2
        case 3:
            return 1
        default:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch flag_textField {
        case 1,2:
            switch component {
            case 0:
                return year.count
            case 1:
                return month.count
            default:
                return 0
            }
        case 3:
            return day.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch flag_textField {
        case 1,2:
            switch component {
            case 0:
                return "\(year[row])年"
            case 1:
                return "\(month[row])月"
            default:
                return nil
            }
        case 3:
            return "\(day[row])日"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var beta_year = 2020
        var beta_month = 1
        var beta_day = 1
        switch flag_textField {
        case 1,2:
            beta_year = pickerView.selectedRow(inComponent: 0)
            beta_month = pickerView.selectedRow(inComponent: 1)
        case 3:
            beta_day = pickerView.selectedRow(inComponent: 0)
        default: break
        }
        //選択した月日のデータを代入
        switch flag_textField {
        //期間1
        case 1:
            value_input[0] = year[beta_year]
            value_input[1] = month[beta_month]
        //期間2
        case 2:
            value_input[2] = year[beta_year]
            value_input[3] = month[beta_month]
        case 3:
            value_input[4] = day[beta_day]
        default: break
        }
    }
    
    //doneボタンを押下
    //tagでどのTextFieldかを判別
    @objc func doneButton(_ tag: Int) {
        //各textFieldをに入力可能にする
        paymentName.isEnabled = true
        paymentSpan1.isEnabled = true
        paymentSpan2.isEnabled = true
        paymentDay.isEnabled = true
        paymentPrice.isEnabled = true
        print(value_input)
        //入力した内容をvalue_inputに入れる
        switch flag_textField {
        case 0:
            name_input = paymentName.text!
        case 1:
            //右の項目（期間）より前の年月かを判別
            //片方は未入力？
            if value_input[2] != 0 {
                //左右の期間を判別(年)
                //年が同じ場合
                if value_input[0] == value_input[2] {
                    //左右の期間を判別(月)
                    if value_input[1] <= value_input[3] {
                        paymentSpan1.text = "\(value_input[0])/\(value_input[1])"
                    } else {
                        //アラート
                        alert(.alert, "終了年月より前の年月を設定してください")
                        //value_input、textFieldの値、を初期化する
                        value_input[0] = 0
                        value_input[1] = 0
                        paymentSpan1.text = ""
                    }
                //年が違う場合
                } else if value_input[0] < value_input[2] {
                    paymentSpan1.text = "\(value_input[0])/\(value_input[1])"
                } else {
                    //アラート
                    alert(.alert, "終了年月より前の年月を設定してください")
                    //value_input、textFieldの値、を初期化する
                    value_input[0] = 0
                    value_input[1] = 0
                    paymentSpan1.text = ""
                }
            } else {
                if value_input[0] != 0 && value_input[1] != 0 {
                    paymentSpan1.text = "\(value_input[0])/\(value_input[1])"
                }
            }
        case 2:
            //左の項目（期間）より後の年月かを判別
            //片方は未入力？
            if value_input[0] != 0 {
                //左右の期間を判別(年)
                //年が同じ場合
                if value_input[0] == value_input[2] {
                    //左右の期間を判別(月)
                    if value_input[1] <= value_input[3] {
                        paymentSpan2.text = "\(value_input[2])/\(value_input[3])"
                    } else {
                        //アラート
                        alert(.alert, "開始年月より後の年月を設定してください")
                        //value_input、textFieldの値、を初期化する
                        value_input[2] = 0
                        value_input[3] = 0
                        paymentSpan2.text = ""
                    }
                //年が違う場合
                //左の年 < 右の年
                } else if value_input[0] < value_input[2] {
                    paymentSpan2.text = "\(value_input[2])/\(value_input[3])"
                //左の年 > 右の年
                } else {
                    //アラート
                    alert(.alert, "開始年月より後の年月を設定してください")
                    value_input[2] = 0
                    value_input[3] = 0
                    paymentSpan2.text = ""
                }
            } else {
                if value_input[2] != 0 && value_input[3] != 0 {
                    paymentSpan1.text = "\(value_input[2])/\(value_input[3])"
                }
            }
        case 3:
            if value_input[4] != 0 {
                paymentDay.text = "\(value_input[4])"
            }
        case 4:
            //入力値は正の整数？
            if let value = Int(paymentPrice.text!) {
                //正の整数？
                if value > 0 {
                    value_input[5] = value
                    //１番上の桁が0の場合、textFieldの文字を整数に直す
                    paymentPrice.text = "\(value)"
                } else {
                    //アラーム
                    alert(.alert,"¥1以上の金額を入力してください")
                    //入力値を初期化
                    paymentPrice.text! = ""
                }
            } else {
                //アラーム
                alert(.alert,"¥1以上の金額を入力してください")
                //入力値を初期化
                paymentPrice.text! = ""
            }
        default: break
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    //アラーム
    func alert(_ style: UIAlertController.Style, _ message:String) {
        //アラートを生成
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: style)
        //OK
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        //アラートを表示する
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //選択したtextField以外のそれをOFFにする
        conrol_textField_switch(textField.tag)
        //textFieldを識別、datepickerの設定
        flag_textField = textField.tag
        return true
    }
    
    func conrol_textField_switch(_ tag: Int) {
        switch tag {
        case 0:
            paymentSpan1.isEnabled = false
            paymentSpan2.isEnabled = false
            paymentDay.isEnabled = false
            paymentPrice.isEnabled = false
        case 1:
            paymentName.isEnabled = false
            paymentSpan2.isEnabled = false
            paymentDay.isEnabled = false
            paymentPrice.isEnabled = false
        case 2:
            paymentName.isEnabled = false
            paymentSpan1.isEnabled = false
            paymentDay.isEnabled = false
            paymentPrice.isEnabled = false
        case 3:
            paymentName.isEnabled = false
            paymentSpan1.isEnabled = false
            paymentSpan2.isEnabled = false
            paymentPrice.isEnabled = false
        case 4:
            paymentName.isEnabled = false
            paymentSpan1.isEnabled = false
            paymentSpan2.isEnabled = false
            paymentDay.isEnabled = false
        default: break
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        //もし１つでも未入力の項目があれば、アラート
        //value_inputの要素をチェック
        for_loop: for i in 0...5 {
            //i番目の要素は値がある？
            if value_input[i] != 0 {
                if i == 5 {
                    //UDに保存
                    //名前、開始年、開始月、終了年、終了月、支払日、月額料金
                    //既にUDにデータが保存されてるなら追加、出なければ登録
                    print(name_input)
                    ud_data.append([name_input,value_input[0],value_input[1],value_input[2],value_input[3],value_input[4],value_input[5]])
                    ud.set(ud_data, forKey: "paymentData")
                    //value_inputを初期化
                    value_input = [0,0,0,0,0,0]
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                //アラート
                alert(.alert, "未入力の項目があります")
                break for_loop
            }
        }
    }
    
}
