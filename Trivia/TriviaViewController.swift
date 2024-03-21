import UIKit

class TriviaViewController: UIViewController {
  
  // Outlets
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  @IBOutlet weak var feedBackLabel: UILabel!
  
  // Properties
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    fetchQuestions()
  }
  
  // MARK: - Helper Methods
  
  private func fetchQuestions() {
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
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
    questionLabel.text = question.question
    categoryLabel.text = question.category
    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
    answerButton0.setTitle(answers[0], for: .normal)
    answerButton1.setTitle(answers[1], for: .normal)
    answerButton2.setTitle(answers[2], for: .normal)
    answerButton3.setTitle(answers[3], for: .normal)
  }
  
  private func checkAnswer(_ selectedAnswer: String) -> Bool {
    let correctAnswer = questions[currQuestionIndex].correctAnswer
    return selectedAnswer == correctAnswer
  }
  
  private func showFeedback(_ isCorrect: Bool) {
    feedBackLabel.text = isCorrect ? "Correct!" : "Incorrect!"
    feedBackLabel.textColor = isCorrect ? .green : .red
  }
  
  private func showFinalScore() {
    let percentage = Double(numCorrectQuestions) / Double(questions.count) * 100.0
    let formattedPercentage = String(format: "%.2f", percentage)
    
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count) (\(formattedPercentage)%)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      self.restartGame()
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func restartGame() {
    currQuestionIndex = 0
    numCorrectQuestions = 0
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  // MARK: - Actions
  
    @IBAction func didTapAnswerButton(_ sender: UIButton) {
        let selectedAnswer = sender.titleLabel?.text ?? ""
        let isCorrect = checkAnswer(selectedAnswer)
        showFeedback(isCorrect)
        
        if isCorrect {
            numCorrectQuestions += 1
        }
        
        if currQuestionIndex < questions.count - 1 {
            currQuestionIndex += 1
            updateQuestion(withQuestionIndex: currQuestionIndex)
        } else {
            showFinalScore()
        }
    }

}
