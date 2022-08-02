//
//  DetailViewController.swift
//  Milestone 28-30
//
//  Created by Jose Blanco on 8/1/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    var string = "" {
        didSet {
            textView.text = "\(string)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            
    }
    
    @IBAction func newCards(_ sender: Any) {
        var front = String()
        var back = String()
        
        let ac = UIAlertController(title: "Enter Card front", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self] _ in
            guard let answer = ac.textFields?[0].text else {return}
            front = answer
            let ac2 = UIAlertController(title: "Enter Card back", message: nil, preferredStyle: .alert)
            ac2.addTextField()
            ac2.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self] _ in
                guard let answer = ac.textFields?[0].text else {return}
                back = answer
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Main") as? ViewController{
                    vc.dictionaryKeys.append(Answers(English: front, French: back))
                    vc.cards.append(front)
                    vc.cards.append(back)
                    vc.save()
                    vc.save2()
            }
            })
            self?.present(ac2, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
