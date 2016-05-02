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
        case Red = 1
        case Green = 2
        case Blue = 3
        case Yellow = 4
    }
    
    enum WhoseTurn {
        case Human
        case Computer
    }
    
    let soundName = "tick"
    var soundPlayer = AVAudioPlayer()
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBAction func Start(sender: AnyObject) {
        
        startNewGame()
        
    }
    
    @IBAction func StartButton(sender: AnyObject) {
        
        startGame()
    }
    
    // MARK: model Properties
    
    let winningNumber = 10
    var currentPlayer: WhoseTurn = .Computer
    
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
    
    
    @IBAction func buttonTouched(sender: UIButton) {
        
        
        //play sound
        let soundPath = NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")
        
        if let soundPath_2 = soundPath{
            let soundURL = NSURL.fileURLWithPath(soundPath_2)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOfURL: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.play()
            } catch {
                print("Player is not avaiable")
            }
            
        }
        
        // determine which button was touched by looking at it tag
        let buttonTag = sender.tag
        
        if let colorTouched = ButtonColor(rawValue: buttonTag) {

        
            if currentPlayer == .Computer{
                // ignore touches as long as this flag is set to true
            }
            
            
            
            if colorTouched  == inputs[indexOfNextButtonToTouch]{
                
                // the player touched the current button
                indexOfNextButtonToTouch++
                
                let button = buttonByColor(colorTouched)
                let originalColor = buttonByColor(colorTouched).backgroundColor
                UIView.animateWithDuration(
                    0.2,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {self.buttonByColor(colorTouched).backgroundColor = UIColor.whiteColor()
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
    
    
    func playSequence (index: Int, highlightTime: Double){
      
        currentPlayer = .Computer
        
         self.labelText.text = "Computer"
      // self.view.backgroundColor = UIColor.blackColor();
        
        if index == inputs.count {
            
            currentPlayer = .Human
            
            self.labelText.text = "Your move"
           // self.view.backgroundColor = UIColor.whiteColor();

          
            return
        }
    
        
        let button = buttonByColor(inputs[index])
        let originalColor = button.backgroundColor
        let highlightColor = UIColor.whiteColor()
        
        UIView.animateWithDuration(
            highlightTime,
            delay: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {button.backgroundColor = highlightColor},
            completion:
            {finished in button.backgroundColor = originalColor
            let newIndex = index + 1
            self .playSequence(newIndex, highlightTime: highlightTime)})
        
        //play sound
        let soundPath = NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")
        
        if let soundPath_2 = soundPath{
            let soundURL = NSURL.fileURLWithPath(soundPath_2)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOfURL: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.play()
            } catch {
                print("Player is not avaiable")
            }
            
        }
        
        
    }
    
    func buttonByColor (color: ButtonColor) -> UIButton {
        switch color {
            case .Red:
               return redButton
            case .Green:
               return greenButton
            case .Blue:
               return blueButton
            case .Yellow:
               return yellowButton
            
            
        }
    }
    
    
    func displayAlertWithTitle(title: String, message: String, buttonTitle: String, action: (UIAlertAction) -> ()) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: title, style: UIAlertActionStyle.Default , handler: action)
        
        alertView.addAction(action)
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    
    func playerWins () {
        
        displayAlertWithTitle("You won", message: "Congraturation", buttonTitle: "OK", action: {_ in self.startNewGame()}  )
    }
    
    func playerLoses () {
        
        displayAlertWithTitle("You lost", message: "You lost", buttonTitle: "Try again", action: {_ in self.startNewGame()}  )
    }
    
    

}

