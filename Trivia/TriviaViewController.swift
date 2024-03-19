import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]() // Corrected syntax: Added parentheses to initialize an empty array
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private var isGameOver = false
  let letterChoices = ["A", "B", "C", "D"]
    
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    
    // Fetch trivia questions
    TriviaQuestionService.shared.fetchQuestions { [weak self] result in // Use weak self to avoid retain cycles
      guard let self = self else { return }
      switch result {
      case .success(let questions):
        DispatchQueue.main.async {
          self.questions = questions // Update questions array
          self.updateQuestion(withQuestionIndex: self.currQuestionIndex) // Display first question
        }
      case .failure(let error):
        print("Error fetching trivia questions: \(error)")
      }
    }
  }
  
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        
        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        for (index, answerButton) in [answerButton0, answerButton1, answerButton2, answerButton3].enumerated() {
            guard let button = answerButton else { continue }
            let letterChoice = letterChoices[index]
            if index < answers.count {
                button.titleLabel?.numberOfLines = 0
                button.titleLabel?.lineBreakMode = .byWordWrapping
                button.contentHorizontalAlignment = .left
                button.setTitle("\(letterChoice) - \(answers[index])", for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }



  
    //updateToNextQuestion Method start
    private func updateToNextQuestion(answer: String) {
        // Check if the game is over (i.e., all questions have been answered)
        guard currQuestionIndex < questions.count else {
            // Show final score if all questions have been answered
            showFinalScore()
            return
        }
        
        // Check if the user canceled the game over alert without restarting
        guard !isGameOver else {
            return
        }
        
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }


    //updateToNextQuestion Method end
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  //showFinalScore Method start
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            updateQuestion(withQuestionIndex: currQuestionIndex)
            // Reset isGameOver to false when the user restarts the game
            self.isGameOver = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            // Set isGameOver to true when the user cancels the game over alert
            self.isGameOver = true
        }
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    //showFinalScore Method end

    //This method will handle the case if the user chooses cancel instead of restart after the game completes.
    private func restartGame() {
        currQuestionIndex = 0
        numCorrectQuestions = 0
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }

    
    

    private func resetGame() {
        currQuestionIndex = 0
        numCorrectQuestions = 0
        questions.removeAll() // Remove existing questions
        fetchNewQuestions() // Fetch new questions
    }

    private func fetchNewQuestions() {
        TriviaQuestionService.shared.fetchQuestions { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let questions):
                DispatchQueue.main.async {
                    self.questions = questions
                    self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                }
            case .failure(let error):
                print("Error fetching trivia questions: \(error)")
            }
        }
    }

  //showFinalScore Method end
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}
