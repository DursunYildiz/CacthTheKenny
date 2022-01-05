

import UIKit

class ViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var highScoreLabel: UILabel!
    var timer = Timer()
    var counter: Int = 0
    var hideTimer = Timer()
    var score: Int = 0
    var isBeginGame: Bool = false
    var highScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        imageView.addGestureRecognizer(recognizer1)
        
        timeLabel.text = "\(10)"
        scoreLabel.text = "Score: \(0)"
        highScoreLabel.text = "Highscore: \(getStoreScore())"
    }

    @objc func increaseScore() {
        if isBeginGame {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        else {
            makeInitConfig()
            isBeginGame = true
            welcomeLabel.isHidden = true
        }
    }
    
    @objc func changeKennyLocation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction) {
            let kennyWidth = self.imageView.frame.width
            let kennyHeight = self.imageView.frame.height

            let viewWidth = self.containerView.bounds.width
            let viewHeight = self.containerView.bounds.height

            let xwidth = viewWidth - kennyWidth
            let yheight = viewHeight - kennyHeight

            let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
            let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))

            self.imageView.center.x = xoffset + kennyWidth / 2
            self.imageView.center.y = yoffset + kennyHeight / 2
        }
    }

    @objc func countDown() {
        counter -= 1
        timeLabel.text = counter.description
           
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            if score > highScore {
                highScore = score
                highScoreLabel.text = "Highscore: \(highScore)"
                UserDefaults.standard.set(highScore, forKey: "highscore")
            }
            
            timeLabel.text = "Times UP"
            imageView.isHidden = true
            alertDialog()
        }
    }

    func alertDialog() {
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { _ in
            
            self.imageView.isHidden = false
            self.isBeginGame = false
            self.welcomeLabel.isHidden = false
            self.scoreLabel.text = "Score: \(0)"
            self.timeLabel.text = 10.description
        }
                    
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { _ in
                    
            self.makeInitConfig()
        }
                    
        alert.addAction(okButton)
        alert.addAction(replayButton)
        present(alert, animated: true, completion: nil)
    }

    func makeInitConfig() {
        counter = 10
        score = 0
        imageView.isHidden = false
        
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changeKennyLocation), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        timeLabel.text = counter.description
        
        scoreLabel.text = "Score: \(score)"

        highScore = getStoreScore()
        
        highScoreLabel.text = "Highscore: \(highScore)"
    }
    
    func getStoreScore() -> Int {
        if let storedHighScore = UserDefaults.standard.object(forKey: "highscore") as? Int {
            return storedHighScore
        }
        else {
            return 0
        }
    }
}
