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
    if answers.count > 0 {
      answerButton0.setTitle(answers[0], for: .normal)
    }
    if answers.count > 1 {
      answerButton1.setTitle(answers[1], for: .normal)
      answerButton1.isHidden = false
    }
    if answers.count > 2 {
      answerButton2.setTitle(answers[2], for: .normal)
      answerButton2.isHidden = false
    }
    if answers.count > 3 {
      answerButton3.setTitle(answers[3], for: .normal)
      answerButton3.isHidden = false
    }
  }
  
    //updateToNextQuestion Method start
    private func updateToNextQuestion(answer: String) {
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
        let score = Double(numCorrectQuestions) / Double(questions.count) * 100
        let alertController = UIAlertController(title: "Game over!",
                                                message: "You scored \(numCorrectQuestions) out of \(questions.count). Your score is \(String(format: "%.2f", score))%",
                                                preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            self.resetGame()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(restartAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //showFinalScore Method end

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