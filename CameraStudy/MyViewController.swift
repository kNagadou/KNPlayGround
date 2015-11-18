//
//  MyViewController.swift
//  CameraStudy
//
//  Created by k_nagadou on 2015/10/27.
//  Copyright © 2015年 dreamarts.co.jp. All rights reserved.
//

// Swiftのベース
import Foundation
// UI関連のライブラリ
import UIKit

class MyViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!

    var images:[UIImage] = Array()
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myImageCell", forIndexPath: indexPath) as! ImageTableViewCell
        
        cell.myImageView.image = images[indexPath.row]
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath)
//    ==> 上記のタイプミスをすると、Error!にならないからわかりにくい！
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier("openImageSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openImageSegue" {
            let vc = segue.destinationViewController as! DetailImageViewController
            vc.image = images[selectedRow!]
        }
        
    }
    
    @IBAction func didTouchButton(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let jpegData:NSData = UIImageJPEGRepresentation(image, 0.5)!
            let base64Encoded:String = jpegData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
            
            // TODO:サーバにPOSTリクエスト。
            let params:Dictionary<String, String> = [
                "image": base64Encoded
            ]
            
            let session = AFHTTPSessionManager()
            session.responseSerializer = AFImageResponseSerializer()
            session.POST("https://support.shoprun.jp/club/image/stamp",
                parameters: params,
                success: {
                    // ブロックを書いたら、weak参照（弱参照）
                    [weak self](task, responseData) in
                    let image = responseData as! UIImage
                    
                    if let wself = self {
                        wself.images.append(image)
                        wself.myTableView.reloadData()
                    }
                },
                failure: nil)
            
            images.append(image as UIImage)
            myTableView.reloadData()
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
}

class DetailImageViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    weak var image: UIImage?
    
    override func viewDidLoad() {
        detailImageView.image = image
    }
}