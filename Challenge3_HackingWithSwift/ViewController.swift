//
//  ViewController.swift
//  Challenge3_HackingWithSwift
//
//  Created by Victoria Treue on 26/8/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - PROPERTIES
    
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
           
    var alphabetButtons = [UIButton]()
    var answerTextField: UITextField!
    var hintLabel: UILabel!
    var wrongLabel: UILabel!
    var wrongCross: UILabel!
    var underscoreLabel: UILabel!

    var scoreLabel: UILabel!
    var score = 0 { didSet { scoreLabel.text = "Score: \(score)"}}
    
    var levelLabel: UILabel!
    var level = 1 { didSet { levelLabel.text = "Level \(level)"}}
    
    var allWords = [String]()
    var wordPairs = [[String]]()
    var currentLevelWordPair = [String]()

    
    // MARK: - UI VIEWS & CONSTRAINTS
    
    override func loadView() {
        
        // ADD 'CONTAINER' VIEW FOR ALL UI ELEMENTS!!!
        view = UIView()
        view.backgroundColor = .white
        
        // MARK: score label
        scoreLabel = UILabel()
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        

        // MARK: level label
        levelLabel = UILabel()
        levelLabel.text = "LEVEL \(level)"
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        levelLabel.textAlignment = .left
        view.addSubview(levelLabel)

        
        // MARK: answer text field
        answerTextField = UITextField()
        answerTextField.translatesAutoresizingMaskIntoConstraints = false
        answerTextField.text = ""
        answerTextField.textColor = .systemGray4
        answerTextField.textAlignment = .center
        answerTextField.font = UIFont.systemFont(ofSize: 35)
        answerTextField.isEnabled = false
        view.addSubview(answerTextField)

        
        // MARK: underscore label
        underscoreLabel = UILabel()
        underscoreLabel.translatesAutoresizingMaskIntoConstraints = false
        underscoreLabel.font = UIFont.systemFont(ofSize: 35)
        underscoreLabel.textAlignment = .center
        underscoreLabel.text = ""
        view.addSubview(underscoreLabel)
        
        
        // MARK: hint label
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Hint Comes Here"
        hintLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        hintLabel.textColor = UIColor(red: 180/255, green: 120/255, blue: 140/255, alpha: 1.0)
        view.addSubview(hintLabel)
        
        
        // MARK: wrong label
        wrongLabel = UILabel()
        wrongLabel.text = "❌❌❌❌❌❌❌"
        wrongLabel.alpha = 0.15
        wrongLabel.font = UIFont.systemFont(ofSize: 40)
        wrongLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wrongLabel)
        
        
        // MARK: wrong cross
        wrongCross = UILabel()
        wrongCross.text = ""
        wrongCross.alpha = 0.8
        wrongCross.font = UIFont.systemFont(ofSize: 40)
        wrongCross.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wrongCross)
        
        
        // MARK: alphabet buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
                
        
        // MARK: - NS LAYOUT CONSTRAINTS

        NSLayoutConstraint.activate([
        
            // Left Top: Level Label
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            
            // Right Top: Score Label
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            
            // Below Score and Level Label: wrong (attempts) label
            wrongLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wrongLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 25),
            
            // Overlap 'wrong cross' with 'wrong label'
            wrongCross.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wrongCross.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 25),
            wrongCross.leadingAnchor.constraint(equalTo: wrongLabel.leadingAnchor),
            
            // Below 'wrong (attempts) label': hint label
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: answerTextField.topAnchor, constant: -25),
            
            // Below hint label: text field
            answerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerTextField.widthAnchor.constraint(equalToConstant: 300),
            answerTextField.bottomAnchor.constraint(equalTo: underscoreLabel.topAnchor, constant: 25),
            
            // Below text field: underscore label
            underscoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            underscoreLabel.widthAnchor.constraint(equalToConstant: 300),
            underscoreLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -30),
            
            // Below underscore label: buttonsView
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 360),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])

        
        // MARK: - SET UP BUTTONS
        
        let width = 60
        let height = 60
                
        
        // MARK: creating button grid
        
        gridloop: for row in 0..<6 {
            for colum in 0..<5 {
                
                let letterButton = UIButton(type: .system)
                letterButton.setTitleColor(Colors.disabledButton, for: .disabled)
                letterButton.setTitleColor(Colors.enabledButton, for: .normal)

                // alphabet.shuffle()
                let letter = alphabet.first ?? "?"
                alphabet.removeFirst()
                
                letterButton.setTitle(letter, for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
                letterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: colum * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                alphabetButtons.append(letterButton)
                            
                if colum == 0 && row == 5 { break gridloop }
            }
        }
    }
    
    
    // MARK: - LIFECYCLE HOOKS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    
    // MARK: - LOAD LEVEL ()
    
    func loadLevel() {

        // Get data and seperate it
        if level == 1 {
            if let data = Bundle.main.url(forResource: "hangmanWords", withExtension: "txt") {
                if let words = try? String(contentsOf: data) {
                    allWords = words.components(separatedBy: "\n")
                }
            }
            if allWords.last == "" { allWords.removeLast() }
        }
        
        allWords.shuffle()
        
        guard let randomElement = allWords.first else { return }

        allWords.removeFirst()

        
        let randomWordPair = randomElement.components(separatedBy: ": ")
        
        let hint = randomWordPair[0]
        let solution = randomWordPair[1]
        
        // Setting _ and ? for underscoreLabel and answerTextField based on solution
        for _ in solution {
            underscoreLabel.text! += "_ "
            answerTextField.text! += "? "
        }
        
        currentLevelWordPair = [hint, solution]
        hintLabel.text = hint
    }
    
    
    // MARK: - LETTER BUTTON TAPPED
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        sender.isEnabled = false
        
        let solutionWord = currentLevelWordPair[1]
        
        if solutionWord.contains(buttonTitle) {
                        
            var questionMarks = answerTextField.text?.components(separatedBy: " ")
            
            for (index, letter) in solutionWord.enumerated() {
                
                if String(letter) == buttonTitle {
                    // Assign letter the user pressed to the same index point of ????
                    questionMarks![index] = String(letter)
                    
                    score += 1
                    
                    let joinedWord = questionMarks?.joined(separator: " ")
                    answerTextField.text = joinedWord!
                }
            }
            
            if !(questionMarks?.contains("?"))! {
                
                let alert = UIAlertController(title: "Hangman survived!", message: "You have won. Let's go to the next level.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { [weak self] _ in
                    self?.newLevel()
                }))
                present(alert, animated: true, completion: nil)
            }
                    
        } else {
            
            // Add a read cross to "wrongCross"
            wrongCross.text! += "❌"
            
            if wrongCross.text == "❌❌❌❌❌❌❌" {
                            
                // Disable all buttons
                for button in alphabetButtons {
                    button.isEnabled = false
                }
                
                // Show alert
                let alert = UIAlertController(title: "Hangman Died!", message: "Let's try this again to go to the next level.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [self] _ in
                    
                    // Set Text Field to ?, Enable Buttons, Reset Score
                    let solution = currentLevelWordPair[1]
                    
                    answerTextField.text = ""
                    underscoreLabel.text = ""
                    
                    for _ in solution {
                        self.answerTextField.text! += "? "
                        self.underscoreLabel.text! += "_ "
                    }
                    
                    for button in alphabetButtons {
                        button.isEnabled = true
                    }
                    
                    wrongCross.text = ""
                    score = 0
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Resetting all properties to 'start level' value | Load new level
    func newLevel() {
                
        for button in alphabetButtons {
            button.isEnabled = true
        }
        
        currentLevelWordPair.removeAll()
        answerTextField.text = ""
        underscoreLabel.text = ""
        wrongCross.text = ""
        score = 0
        
        level += 1
        
        loadLevel()
    }
}


struct Colors {
    static let enabledButton = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    static let disabledButton = enabledButton.withAlphaComponent(0.3)
}
