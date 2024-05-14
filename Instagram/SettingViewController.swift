//
//  SettingViewController.swift
//  Instagram
//
//  Created by 中村 行汰 on 2024/05/13.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 表示名を取得してTextFieldに設定する
        if let user = Auth.auth().currentUser {
            displayNameTextField.text = user.displayName
        }else{
            SVProgressHUD.showError(withStatus: "再ログインしてください")
            do {
                try Auth.auth().signOut()
            }catch{
                print(error)
            }
            // ログイン画面を表示する
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)

            // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
            tabBarController?.selectedIndex = 0
        }
    }

    // 表示名変更ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleChangeButton(_ sender: Any) {
        guard let displayName = displayNameTextField.text else {
            return
        }
        // 表示名が入力されていない時はHUDを出して何もしない
        if displayName.isEmpty {
            SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
            return
        }

        // 表示名を設定する
        guard let user = Auth.auth().currentUser else {
            print("DEBUG_PRINT: ユーザーがnilです。")
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.commitChanges { error in
            if let error = error {
                SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                print("DEBUG_PRINT: " + error.localizedDescription)
                return
            }
            print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

            // HUDで完了を知らせる
            SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
        
        }
        
        // キーボードを閉じる
        self.view.endEditing(true)
    }

    // ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        do {
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)

        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
