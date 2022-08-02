//
//  ViewController.swift
//  Milestone 28-30
//
//  Created by Jose Blanco on 7/27/22.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var instructionsLabel: UILabel!
    var activatedButtons = [UIButton]()
    var letterButtons = [UIButton]()
    var cards = [String]()
    var dictionaryKeys = [Answers]()
    
    var correct = 0
    var incorrectAttempts = 0 {
        didSet {
            DispatchQueue.main.async {
                self.scoreLabel.text = "Incorrect guesses: \(self.incorrectAttempts)"
            }
        }
    }
    
    var buttonsTapped = 0
    
    var firstWord: String!
    var secondWord: String!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Incorrect guesses: 0"
        view.addSubview(scoreLabel)
        
        instructionsLabel = UILabel()
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = """
                                Welcome to matcha French!
                                Start making guesses by pressing the cards below.
                                """
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(instructionsLabel)

        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
    
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 700),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 0),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0),
            instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            instructionsLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0)
            
        ])
        
        let width = 195
        let height = 70
        var tag = 0
        for row in 0..<9 {
            for column in 0..<2 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                letterButton.layer.borderWidth = 2
                letterButton.layer.borderColor = UIColor.gray.cgColor
                letterButton.layer.cornerRadius = 10
                letterButton.titleLabel?.textAlignment = .center
                
                letterButton.setTitleColor(.black, for: .normal)
                letterButton.setTitle("X", for: .normal)
               
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.tag = tag
                tag += 1
                let frame = CGRect(x: column * (10 + width), y: row * (height + 10), width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
//        cards.append("Hello")
//        cards.append("Goodbye")
//        cards.append("That's life")
//        cards.append("See you soon")
//        cards.append("To go")
//        cards.append("To eat")
//        cards.append("To walk")
//        cards.append("To climb")
//        cards.append("To speak")
//        cards.append("Bonjour")
//        cards.append("Au Revoir")
//        cards.append("C'est la vie")
//        cards.append("À bientôt")
//        cards.append("Aller")
//        cards.append("Manger")
//        cards.append("Marcher")
//        cards.append("Grimper")
//        cards.append("Parler")
//        cards.shuffle()
//        
//        dictionaryKeys.append(Answers(English: "Hello", French: "Bonjour"))
//        dictionaryKeys.append(Answers(English: "Goodbye",French: "Au Revoir"))
//        dictionaryKeys.append(Answers(English: "That's life",French: "C'est la vie"))
//        dictionaryKeys.append(Answers(English: "See you soon",French: "À bientôt"))
//        dictionaryKeys.append(Answers(English: "To go",French: "Aller"))
//        dictionaryKeys.append(Answers(English: "To eat",French: "Manger"))
//        dictionaryKeys.append(Answers(English: "To walk",French: "Marcher"))
//        dictionaryKeys.append(Answers(English: "To climb",French: "Grimper"))
//        dictionaryKeys.append(Answers(English: "To speak",French: "Parler"))
        
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(reload))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "View all Cards", style: .plain, target: self, action: #selector(allCards))
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "cards") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                cards = try jsonDecoder.decode([String].self, from: savedData)
            } catch {
                print("Failed to load cards.")
            }
        }
        
        if let savedDict = defaults.object(forKey: "dictionary") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                dictionaryKeys = try jsonDecoder.decode([Answers].self, from: savedDict)
            } catch {
                print("Failed to load dictionary")
            }
        }
    }

    //Whenever a button is tapped, check if more than 2 buttons have been tapped, set title.
    @objc func letterTapped(_ sender: UIButton) {
        
        
        for button in letterButtons {
            if sender.tag == button.tag {
                activatedButtons.append(sender)
                UIView.transition(with: sender, duration: 0.7, options: [.transitionFlipFromRight], animations: nil)
                
                    sender.setTitle(cards[sender.tag], for: .normal)
                    buttonsTapped += 1
                if buttonsTapped == 1 {
                    firstWord = sender.currentTitle ?? ""
                } else if buttonsTapped == 2 {
                    secondWord = sender.currentTitle ?? ""
                        view.isUserInteractionEnabled = false
                        checkCards(first: firstWord, second: secondWord)
                    }
                }
            }
        }
       
    
    func checkCards(first word1: String, second word2: String) {
        print(buttonsTapped)
        print(word1)
        print(word2)
        
        if dictionaryKeys.contains(where: {(($0.English == word1) && ($0.French == word2))}){
            for button in self.activatedButtons.reversed() {
                UIView.transition(with: button, duration: 0.7, options: [.transitionCurlUp], animations: {
            
                })
                    self.activatedButtons.removeLast()
            }
            
            
            view.isUserInteractionEnabled = true
            buttonsTapped = 0
            correct += 1
            if correct == 9 {
                scoreLabel.text = "YOU WIN!"
                instructionsLabel.text = "You had \(incorrectAttempts) incorrect guesses."
            }
            
        } else if dictionaryKeys.contains(where: {(($0.English == word2) && ($0.French == word1))}){
            for button in self.activatedButtons.reversed() {
                UIView.transition(with: button, duration: 0.7, options: [.transitionCurlUp], animations: {
            
                })
                    self.activatedButtons.removeLast()
            }
            
            
            view.isUserInteractionEnabled = true
            buttonsTapped = 0
            correct += 1
            if correct == 9 {
                
            }
            
        } else {
            let secondsToDelay = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                for button in self.activatedButtons.reversed() {
                    UIView.transition(with: button, duration: 0.7, options: [.transitionFlipFromLeft], animations: nil)
                    button.setTitle("X", for: .normal)
            
            
                }
                self.incorrectAttempts += 1
                self.activatedButtons.removeAll()
                self.view.isUserInteractionEnabled = true
                self.buttonsTapped = 0
            }
        }
    }
    
    @objc func reload(){
        cards.shuffle()
        
        for button in letterButtons {
            UIView.transition(with: button, duration: 0.7, options: [.transitionFlipFromLeft], animations: nil)
            button.setTitle("X", for: .normal)
        }
        
        
        incorrectAttempts = 0
        instructionsLabel.text = """
                                Welcome to matcha French!
                                Start making guesses by pressing the cards below.
                                """
    }
    
    @objc func allCards(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            navigationController?.present(vc, animated: true){
            
                for card in self.dictionaryKeys {
                    vc.string += "\(card.English), \(card.French) \n"
            }
        
        }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(cards) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "cards")
        } else {
            print("Failed to save words.")
        }
    }
    
    func save2() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(dictionaryKeys) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "dictionary")
        } else {
            print("Failed to save dictionary.")
        }
    }
}

//for button in self.activatedButtons.reversed() {
//    UIView.transition(with: button, duration: 0.7, options: [.transitionCurlUp], animations: {
//
//    })
//        self.activatedButtons.removeLast()
//}
//
//
//view.isUserInteractionEnabled = true
//buttonsTapped = 0

    
//    for button in activatedButtons.reversed() {
//        UIView.transition(with: button, duration: 0.7, options: [.transitionFlipFromLeft], animations: nil)
//        button.setTitle("X", for: .normal)
//
//
//    }
//    activatedButtons.removeAll()
//    view.isUserInteractionEnabled = true
//    buttonsTapped = 0
