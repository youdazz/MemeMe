//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Youda Zhou on 9/11/23.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage.image = meme.originalImage
        memedImage.image = meme.memedImage
        topText.text = meme.topText
        bottomText.text = meme.bottomText
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMeme" {
            guard let memeEditor = segue.destination as? MemeEditorViewController else { return }
            memeEditor.meme = meme
        }
    }
}
