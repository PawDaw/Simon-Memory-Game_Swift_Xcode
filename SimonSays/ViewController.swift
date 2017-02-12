//
//  ViewController.swift
//  SimonSays
//
//  Created by paw daw on 14/03/16.
//  Copyright © 2016 paw daw. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum ButtonColor: Int{
        case red = 1
        case green = 2
        case blue = 3
        case yellow = 4
    }
    
    enum WhoseTurn {
        case human
        case computer
    }
    
    let soundName = "tick"
    var soundPlayer = AVAudioPlayer()
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBAction func Start(_ sender: AnyObject) {
        
        startNewGame()
        
    }
    
    @IBAction func StartButton(_ sender: AnyObject) {
        
        startGame()
    }
    
    // MARK: model Properties
    
    let winningNumber = 10
    var currentPlayer: WhoseTurn = .computer
    
    //Array of buttons
    var inputs = [ButtonColor]()
    var indexOfNextButtonToTouch = 0
    
    // flashing mechanism
    var hightlightsquareTime = 1.2
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //startGame()
        
    }

    func startGame (){
        inputs = [ButtonColor]()
        advanceGame()
    }
    
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        
        
        //play sound
        let soundPath = Bundle.main.path(forResource: soundName, ofType: "wav")
        
        if let soundPath_2 = soundPath{
            let soundURL = URL(fileURLWithPath: soundPath_2)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOf: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.play()
            } catch {
                print("Player is not avaiable")
            }
            
        }
        
        // determine which button was touched by looking at it tag
        let buttonTag = sender.tag
        
        if let colorTouched = ButtonColor(rawValue: buttonTag) {

        
            if currentPlayer == .computer{
                // ignore touches as long as this flag is set to true
            }
            
            
            
            if colorTouched  == inputs[indexOfNextButtonToTouch]{
                
                // the player touched the current button
                indexOfNextButtonToTouch += 1
                
                let button = buttonByColor(colorTouched)
                let originalColor = buttonByColor(colorTouched).backgroundColor
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseOut,
                    animations: {self.buttonByColor(colorTouched).backgroundColor = UIColor.white
                    self.view.layoutIfNeeded()},
                    completion:
                    {
                        finished in button.backgroundColor = originalColor
                        self.view.layoutIfNeeded()
                })

                
                
                // determine if there are any more buttons left in the round 
                if indexOfNextButtonToTouch == inputs.count {
                    
                    // Players has won this round 
                    if advanceGame() == false {
                        playerWins()
                        
                    }
                    indexOfNextButtonToTouch = 0
                }
                
            }
            else {
                
                // Player touchd the wrong button
                playerLoses()
                indexOfNextButtonToTouch = 0
            }
            
            
        }
        
    }
    
    
    
    func startNewGame(){
        
        inputs = [ButtonColor] ()
        // adding another color of the button in thte next level
        advanceGame()
    }
    
    
    func advanceGame() -> Bool {
        
        var result = true
        
        if inputs.count == winningNumber{
            result = false
        }
        else {
            
            // add a new random number to othe inputs list
            inputs = inputs + [randomButton()]
            
            // play the button animation sequence
           
            playSequence(0, highlightTime: hightlightsquareTime)
            
        }
       return result
    }
    
    
    func randomButton () -> ButtonColor {
        
        let v: Int = Int(arc4random_uniform(UInt32(4))) + 1
        let result = ButtonColor(rawValue: v)
        return result!
    }
    
    
    func playSequence (_ index: Int, highlightTime: Double){
      
        currentPlayer = .computer
        
         self.labelText.text = "Computer"
      // self.view.backgroundColor = UIColor.blackColor();
        
        if index == inputs.count {
            
            currentPlayer = .human
            
            self.labelText.text = "Your move"
           // self.view.backgroundColor = UIColor.whiteColor();

          
            return
        }
    
        
        let button = buttonByColor(inputs[index])
        let originalColor = button.backgroundColor
        let highlightColor = UIColor.white
        
        UIView.animate(
            withDuration: highlightTime,
            delay: 0.5,
            options: UIViewAnimationOptions(),
            animations: {button.backgroundColor = highlightColor},
            completion:
            {finished in button.backgroundColor = originalColor
            let newIndex = index + 1
            self .playSequence(newIndex, highlightTime: highlightTime)})
        
        //play sound
        let soundPath = Bundle.main.path(forResource: soundName, ofType: "wav")
        
        if let soundPath_2 = soundPath{
            let soundURL = URL(fileURLWithPath: soundPath_2)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOf: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.play()
            } catch {
                print("Player is not avaiable")
            }
            
        }
        
        
    }
    
    func buttonByColor (_ color: ButtonColor) -> UIButton {
        switch color {
            case .red:
               return redButton
            case .green:
               return greenButton
            case .blue:
               return blueButton
            case .yellow:
               return yellowButton
            
            
        }
    }
    
    
    func displayAlertWithTitle(_ title: String, message: String, buttonTitle: String, action: @escaping (UIAlertAction) -> ()) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: title, style: UIAlertActionStyle.default , handler: action)
        
        alertView.addAction(action)
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    
    func playerWins () {
        
        displayAlertWithTitle("You won", message: "Congraturation", buttonTitle: "OK", action: {_ in self.startNewGame()}  )
    }
    
    func playerLoses () {
        
        displayAlertWithTitle("You lost", message: "You lost", buttonTitle: "Try again", action: {_ in self.startNewGame()}  )
    }
    
    

}

