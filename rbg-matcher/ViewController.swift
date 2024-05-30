//
//  ViewController.swift
//  rbg-matcher
//
//  Created by Ueta, Lucas T on 10/25/23.
//

import UIKit

class ViewController: UIViewController {
    
    // circles
    let circleStack = UIStackView(),
        topCircle = UIView(),
        bottomCircle = UIView(),
        // header labels
        highScoreLabel = UILabel(),
        timerLabel = UILabel(),
        // sliders
        sliderStack = UIStackView(),
        redSlider = UISlider(),
        greenSlider = UISlider(),
        blueSlider = UISlider(),
        // miscellaneous
        contentStack = UIStackView(),
        font = UIFont(name: "Avenir", size: 32)
        
    // guess colours
    var guessRed = 127 { didSet {
        updateGuess()
        redSlider.setValue(Float(guessRed), animated: true)
    }}
    var guessGreen = 127 { didSet {
        updateGuess()
        greenSlider.setValue(Float(guessGreen), animated: true)
    }}
    var guessBlue = 127 { didSet {
        updateGuess()
        blueSlider.setValue(Float(guessBlue), animated: true)
    }}
    
    // real colours
    var realRed = 0,
        realGreen = 0,
        realBlue = 0
    
    // timer
    var time = 5 { didSet { timerLabel.text = formatNumber(time) }}
    var timer: Timer?

    // styling
    var wideConstraints: [NSLayoutConstraint] = [],
        narrowConstraints: [NSLayoutConstraint] = []
    
    var flexibleAxes: [UIStackView] = []

    var highScore = 0 { didSet { highScoreLabel.text = formatNumber(highScore)}}
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // stack
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 50
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        narrowConstraints.append(stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        wideConstraints.append(stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28))
        
        // header
        let header = UIStackView()
        header.axis = .horizontal
        header.distribution = .equalSpacing
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(header)
        narrowConstraints.append(contentsOf: [
            header.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            header.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
        wideConstraints.append(contentsOf: [
            header.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            header.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        
        // left side of header
        let leftHeader = UIStackView()
        leftHeader.axis = .horizontal
        leftHeader.spacing = 10
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addArrangedSubview(leftHeader)
        
        // hr
        let hr = UILabel()
        hr.font = font
        hr.textColor = .red
        hr.text = "HR"
        
        leftHeader.addArrangedSubview(hr)
        
        // high score label
        highScoreLabel.font = font
        highScoreLabel.textColor = .green
        highScoreLabel.text = formatNumber(0)
        
        leftHeader.addArrangedSubview(highScoreLabel)
        
        // timerLabel
        timerLabel.font = font
        timerLabel.textColor = .blue
        timerLabel.text = formatNumber(5)
        
        header.addArrangedSubview(timerLabel)
        
        // content
        flexibleAxes.append(contentStack)
        contentStack.distribution = .equalSpacing
        contentStack.alignment = .center
        contentStack.spacing = 50
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(contentStack)
        
        // circle view
        let circleView = UIView()
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(circleView)
        narrowConstraints.append(contentsOf: [
            circleView.widthAnchor.constraint(equalToConstant: 176),
            circleView.heightAnchor.constraint(equalToConstant: 176 * 2 + 10)
        ])
        wideConstraints.append(contentsOf: [
            circleView.widthAnchor.constraint(equalToConstant: 176 * 2 + 10),
            circleView.heightAnchor.constraint(equalToConstant: 176)
        ])
        
        // circleStack
        flexibleAxes.append(circleStack)
        circleStack.spacing = 10
        
        circleStack.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(circleStack)
        narrowConstraints.append(circleStack.bottomAnchor.constraint(equalTo: circleView.bottomAnchor))
        wideConstraints.append(circleStack.rightAnchor.constraint(equalTo: view.centerXAnchor))
        
        // top circle
        updateGuess()
        topCircle.layer.cornerRadius = 176 / 2
        
        circleStack.addArrangedSubview(topCircle)
        NSLayoutConstraint.activate([
            topCircle.widthAnchor.constraint(equalToConstant: 176),
            topCircle.heightAnchor.constraint(equalToConstant: 176)
        ])
        
        // bottom circle
        reload()
        bottomCircle.layer.cornerRadius = 176 / 2
        
        circleStack.addArrangedSubview(bottomCircle)
        circleStack.sendSubviewToBack(bottomCircle)
        NSLayoutConstraint.activate([
            bottomCircle.widthAnchor.constraint(equalToConstant: 176),
            bottomCircle.heightAnchor.constraint(equalToConstant: 176)
        ])
        
        // slider stack
        sliderStack.axis = .vertical
        sliderStack.distribution = .equalSpacing
        sliderStack.spacing = 10
        
        contentStack.addArrangedSubview(sliderStack)
        narrowConstraints.append(contentsOf: [
            sliderStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 69),
            sliderStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -69)
        ])
        wideConstraints.append(sliderStack.widthAnchor.constraint(equalToConstant: 250))
        
        // red slider
        prepareSlider(redSlider)
        redSlider.tintColor = .red
        redSlider.tag = 0
        redSlider.addTarget(self, action: #selector(updateSlider(_:)), for: .valueChanged)
        redSlider.setValue(Float(guessRed), animated: true)
        
        sliderStack.addArrangedSubview(redSlider)
        
        // green slider
        prepareSlider(greenSlider)
        greenSlider.tintColor = .green
        greenSlider.tag = 1
        greenSlider.addTarget(self, action: #selector(updateSlider(_:)), for: .valueChanged)
        greenSlider.setValue(Float(guessGreen), animated: true)
        
        sliderStack.addArrangedSubview(greenSlider)
        
        // blue slider
        prepareSlider(blueSlider)
        blueSlider.tintColor = .blue
        blueSlider.tag = 2
        blueSlider.addTarget(self, action: #selector(updateSlider(_:)), for: .valueChanged)
        blueSlider.setValue(Float(guessBlue), animated: true)
        
        sliderStack.addArrangedSubview(blueSlider)
        
        // narrow/wide
        let isNarrow = view.frame.height > view.frame.width
        NSLayoutConstraint.activate(isNarrow ? narrowConstraints : wideConstraints)
        for stack in flexibleAxes { stack.axis = isNarrow ? .vertical : .horizontal }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                for stack in self.flexibleAxes { stack.axis = .horizontal }
                NSLayoutConstraint.deactivate(self.narrowConstraints)
                NSLayoutConstraint.activate(self.wideConstraints)
            }
            else {
                for stack in self.flexibleAxes { stack.axis = .vertical }
                NSLayoutConstraint.deactivate(self.wideConstraints)
                NSLayoutConstraint.activate(self.narrowConstraints)
    }})}

    // UI
    func prepareSlider(_ slider: UISlider) {
        slider.minimumValue = 0
        slider.maximumValue = 255
    }
    
    // calculations
    func formatNumber(_ number: Int) -> String { return number < 10 ? "0\(number)" : String(number) }
    
    func getColor(r: Int, g: Int, b: Int) -> UIColor { return UIColor(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0, alpha: 1) }
    
    func getSquareDifference(_ real: Int, from guess: Int) -> Double { return pow(Double(real - guess) / 255.0, 2.0) }
    
    func getScore() -> Int {
        let distance = sqrt(
            getSquareDifference(realRed, from: guessRed) +
            getSquareDifference(realGreen, from: guessGreen) +
            getSquareDifference(realBlue, from: guessBlue)
        )
                
        return Int((1 - distance) * 100)
    }
    
    // responsive
    func reload(alert: UIAlertAction? = UIAlertAction()) {
        time = 5
        
        // get new random colour
        realRed = Int.random(in: 0...255)
        realGreen = Int.random(in: 0...255)
        realBlue = Int.random(in: 0...255)

        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.bottomCircle.backgroundColor = self.getColor(r: self.realRed, g: self.realGreen, b: self.realBlue)
            self.circleStack.spacing = 10
            
            for case let slider as UISlider in self.sliderStack.subviews {
                slider.isEnabled = true
            }
            
            // reset guesses
            self.guessRed = 127
            self.guessGreen = 127
            self.guessBlue = 127
        })
    }
    
    func updateGuess() { topCircle.backgroundColor = getColor(r: guessRed, g: guessGreen, b: guessBlue) }
    
    @objc func updateSlider(_ sender: UISlider) {
        // timer
        if time == 5 && (timer == nil || !timer!.isValid) { timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)}
        
        sender.setValue(sender.value.rounded(), animated: true)
                
        switch sender.tag {
            case 0:
                guessRed = Int(sender.value)
                return
            case 1:
                guessGreen = Int(sender.value)
                return
            case 2:
                guessBlue = Int(sender.value)
                return
            default:
                return
    }}
    
    @objc func tick() {
        time -= 1
        if time == 0 { timesUp() }
    }
    
    func timesUp() {
        for case let slider as UISlider in sliderStack.subviews {
            slider.isEnabled = false
        }

        timer?.invalidate() // FIX WHEN KEEP MOVING SLIDER
        

        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.circleStack.spacing = -177 * 2/3
        }, completion: { _ in self.scoreGame() })
    }
    
    func scoreGame() {
        let score = self.getScore()
        
        // high score
        var isNewHighScore = false
        if score > self.highScore {
            self.highScore = score
            isNewHighScore = true
        }
        
        let alert = UIAlertController(title: isNewHighScore ? "New High Score!" : "Time's Up", message: "Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Play again", comment: "Default action"), style: .default, handler: self.reload))
        self.present(alert, animated: true, completion: nil)
    }
}

