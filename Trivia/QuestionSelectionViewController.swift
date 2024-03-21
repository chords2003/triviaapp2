//
//  QuestionSelectionViewController.swift
//  Trivia
//
//  Created by Jack Joseph on 3/20/24.
//

import UIKit

class QuestionSelectionViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedDifficulty: String?
    
    private let categoryPicker = UIPickerView()
    private let difficultyPicker = UIPickerView()
    private let categories = ["General Knowledge", "Books", "Film", "Music", "Science"]
    private let difficulties = ["Easy", "Medium", "Hard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryPicker()
        setupDifficultyPicker()
    }
    
    private func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        view.addSubview(categoryPicker)
        // Set up constraints for the categoryPicker
    }
    
    private func setupDifficultyPicker() {
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        view.addSubview(difficultyPicker)
        // Set up constraints for the difficultyPicker
    }
}

extension QuestionSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else {
            return difficulties.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else {
            return difficulties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            selectedCategory = categories[row]
        } else {
            selectedDifficulty = difficulties[row]
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


