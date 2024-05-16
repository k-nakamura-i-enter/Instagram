//
//  InputCommentViewController.swift
//  Instagram
//
//  Created by 中村 行汰 on 2024/05/14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commenterNameLabel: UILabel!
    
    var postArray:[PostData] = []
    var indexPath:IndexPath!
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if let userName = Auth.auth().currentUser {
            self.commenterNameLabel.text = "\(userName.displayName!) : "
            
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    let postData = PostData(document: document)
                    print("DEBUG_PRINT: \(postData)")
                    return postData
                }
                
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray[self.indexPath.row].comment.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "\(self.postArray[self.indexPath.row].comment[indexPath.row])\(self.postArray[self.indexPath.row].comment[indexPath.row].comment)"
        return cell
    }
    
    @IBAction func handleCommentButton(_ sender: UIButton) {
        guard let commentContent = commentField.text else {
            return
        }
        if commentContent.isEmpty {
            return
        }
        
        let postData = postArray[indexPath!.row]
        
//        var commentDateValue: FieldValue
//        var commenterNameValue: FieldValue
//        var commentValue: FieldValue
//        var commentContentValue: FieldValue
        
        let name = Auth.auth().currentUser?.displayName
        
        let map: [String: Any] = [/*"commentDate": FieldValue.serverTimestamp(),*/
                                  "commenterName": name!,
                                  "comment": commentContent]
//        commentDateValue = FieldValue.arrayUnion(])
//        commenterNameValue = FieldValue.arrayUnion([name!])
//        commentValue = FieldValue.arrayUnion([commentContent])
//        commentContentValue = FieldValue.arrayUnion([map])
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        
//        postRef.setData(["comment": commentContentValue])
//        postRef.updateData(["comment.commentDate": FieldValue.serverTimestamp(),
//                            "comment.commenterName": name!,
//                            "comment.comment": commentContent])
//        postRef.updateData([
//            "comment.commentDate": FieldValue.arrayUnion([""])
//        ])
        postRef.setData([
          "comments": FieldValue.arrayUnion([map])
        ])
        
        commentField.text = ""
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
