//
//  ViewController.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2019/9/29.
//  Copyright © 2019 H.W. Hsiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isAiMode: Bool = true
    var isAiTurn: Bool = false
    var hitTheButton: Int = 0
    var aiNumberToUser: Int = 0
    var totalLine = 0
    var aiTotalLine = 0
    
    var isSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    var isAiSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    var h1 = [false, false, false, false, false] //tag1~5
    var h2 = [false, false, false, false, false] //tag6~10
    var h3 = [false, false, false, false, false] //tag11~15
    var h4 = [false, false, false, false, false] //tag16~20
    var h5 = [false, false, false, false, false] //tag21~25
    var aih1 = [false, false, false, false, false] //tag1~5
    var aih2 = [false, false, false, false, false] //tag6~10
    var aih3 = [false, false, false, false, false] //tag11~15
    var aih4 = [false, false, false, false, false] //tag16~20
    var aih5 = [false, false, false, false, false] //tag21~25
    
    var hTrue = [false, false, false, false, false]
    var vTrue = [false, false, false, false, false]
    var slashTrue = [false, false]
    var aihTrue = [false, false, false, false, false]
    var aivTrue = [false, false, false, false, false]
    var aiSlashTrue = [false, false]
    
    var hLine = 0
    var vLine = 0
    var slashLine = 0
    var aihLine = 0
    var aivLine = 0
    var aiSlashLine = 0
    
    
    
    @IBAction func restart(_ sender: UIBarButtonItem) {
        restart()
    }
    
    @IBOutlet weak var modeSegment: UISegmentedControl!
    @IBAction func mode(_ sender: UISegmentedControl) {
        let modeNoti = UIAlertController(title: "模式更改", message: "變更模式後，進行中的遊戲將會被清除並重啟局盤，確定要變更嗎？", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "確定", style: .destructive) { (yesAction) in
            let index = sender.selectedSegmentIndex
            switch index {
            case 0:
                self.isAiMode = true
            case 1:
                self.isAiMode = false
            default:
                return
            }
            self.restart()
        }
        let noAction = UIAlertAction(title: "取消", style: .default, handler: .init({ (noAction) in
            let index = sender.selectedSegmentIndex
            if index == 0 {
                self.modeSegment.selectedSegmentIndex = 1
                self.isAiMode = false
            } else {
                self.modeSegment.selectedSegmentIndex = 0
                self.isAiMode = true
            }
        }))
        modeNoti.addAction(yesAction)
        modeNoti.addAction(noAction)
        self.present(modeNoti, animated: true, completion: nil)
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet var numberButton: [UIButton]!
    @IBAction func numberActionButton(_ sender: UIButton) {
        let currentTag = sender.tag
        if isAiMode == false {
            if isSelected[currentTag-1] == false {
                numberButton[currentTag-1].isSelected = true
                isSelected[currentTag-1] = true
            } else {
                numberButton[currentTag-1].isSelected = false
                isSelected[currentTag-1] = false
            }
            updateH(currentTag: currentTag)
            userCheck(currentTag: currentTag)
        } else if isAiMode == true {
            if isSelected[currentTag-1] == false {
                numberButton[currentTag-1].isSelected = true
                isSelected[currentTag-1] = true
                hitTheButton += 1
            } else {
                numberButton[currentTag-1].isSelected = false
                isSelected[currentTag-1] = false
                hitTheButton -= 1
            }
            updateH(currentTag: currentTag)
            userCheck(currentTag: currentTag)
            
            //AI模式時，將使用者點選的數字存入變數userNumberToAi，接著呼叫scan function
            if hitTheButton == 1 {
                if let userNumberToAi = sender.currentTitle {
                    scanAiButtonTitle(target: userNumberToAi)
                }
            }
            
            aiTurn()
            
//
            
            //將hitTheButton歸零
            if hitTheButton == 2 {
                hitTheButton = 0
            }
        }
        
        //決定messageTextField顯示的文字
        if isAiMode == true {
            if aiNumberToUser == 0 {
                    messageTextField.text = howManyLines()
            } else {
                let line1 = howManyUserLines()
                let line2 = howManyAiLines()
                if line1 == 5 || line2 == 5 {
                messageTextField.text = "\(howManyLines())"
                } else {
                    messageTextField.text = "\(howManyLines())，AI數字：\(aiNumberToUser)"
                }
            }
        } else if isAiMode == false {
            messageTextField.text = howManyLines()
        }
    }
    
    //電腦的賓果盤
    @IBOutlet var aiButton: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generate(mode: isAiMode)
        
    }

    
    func restart() {
        totalLine = 0
        aiTotalLine = 0
        hitTheButton = 0
        for i in 0 ... isSelected.count - 1 {
            isSelected[i] = false
            isAiSelected[i] = false
            numberButton[i].isSelected = false
            aiButton[i].isSelected = false
            messageTextField.text = ""
        }
        for i in 0 ... 4 {
            h1[i] = false
            aih1[i] = false
            h2[i] = false
            aih2[i] = false
            h3[i] = false
            aih3[i] = false
            h4[i] = false
            aih4[i] = false
            h5[i] = false
            aih5[i] = false
            hTrue[i] = false
            aihTrue[i] = false
            vTrue[i] = false
            aivTrue[i] = false
        }
        for i in 0 ... 1 {
            slashTrue[i] = false
            aiSlashTrue[i] = false
        }
        generate(mode: isAiMode)
    }

    
    func generate(mode: Bool) -> () {
        //ai模式
        if mode == true {
            var number = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
            var number2 = [25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
            for i in 0 ... number.count - 1 {
                let index = Int.random(in: 0 ... number.count - 1)
                let userButtonNumber = number[index]
                let aiButtonNumber = number2[index]
                numberButton[i].setTitle("\(userButtonNumber)", for: .normal)
                aiButton[i].setTitle("\(aiButtonNumber)", for: .normal)
                number.remove(at: index)
                number2.remove(at: index)
            }
        } else {
            //user模式
            var number = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
            for i in 0 ... number.count - 1 {
                let index = Int.random(in: 0 ... number.count - 1)
                let aNumber = number[index]
                numberButton[i].setTitle("\(aNumber)", for: .normal)
                aiButton[i].setTitle("", for: .normal)
                number.remove(at: index)
            }
        }
    }
    
    
    func updateH(currentTag: Int) {
        if currentTag <= 5 {
            //確認是h1
            h1[currentTag-1] = isSelected[currentTag-1]
        } else if currentTag <= 10 {
            //確認是h2
            let r = currentTag%5
            if r != 0{
                h2[r-1] = isSelected[currentTag-1]
            } else {
                h2[4] = isSelected[currentTag-1]
            }
        } else if currentTag <= 15 {
            //確認是h3
            let r = currentTag%5
            if r != 0{
                h3[r-1] = isSelected[currentTag-1]
            } else {
                h3[4] = isSelected[currentTag-1]
            }
        } else if currentTag <= 20 {
            //確認是h4
            let r = currentTag%5
            if r != 0{
                h4[r-1] = isSelected[currentTag-1]
            } else {
                h4[4] = isSelected[currentTag-1]
            }
        } else {
            //確認是h5
            let r = currentTag%5
            if r != 0{
                h5[r-1] = isSelected[currentTag-1]
            } else {
                h5[4] = isSelected[currentTag-1]
            }
        }
    }
    
    
    func updateAiH(currentTag: Int) {
        if currentTag <= 5 {
            //確認是aih1
            aih1[currentTag-1] = isAiSelected[currentTag-1]
        } else if currentTag <= 10 {
            //確認是aih2
            let r = currentTag%5
            if r != 0 {
                aih2[r-1] = isAiSelected[currentTag-1]
            } else {
                aih2[4] = isAiSelected[currentTag-1]
            }
        } else if currentTag <= 15 {
            //確認是aih3
            let r = currentTag%5
            if r != 0 {
                aih3[r-1] = isAiSelected[currentTag-1]
            } else {
                aih3[4] = isAiSelected[currentTag-1]
            }
        } else if currentTag <= 20 {
            //確認是aih4
            let r = currentTag%5
            if r != 0 {
                aih4[r-1] = isAiSelected[currentTag-1]
            } else {
                aih4[4] = isAiSelected[currentTag-1]
            }
        } else {
            //確認是aih5
            let r = currentTag%5
            if r != 0 {
                aih5[r-1] = isAiSelected[currentTag-1]
            } else {
                aih5[4] = isAiSelected[currentTag-1]
            }
        }
    }
    
    
    func userCheck(currentTag: Int) {
        //檢查橫向
        if h1[0] == true && h1[1] == true && h1[2] == true && h1[3] == true && h1[4] == true {
            hTrue[0] = true
        } else {
            hTrue[0] = false
        }
        
        if h2[0] == true && h2[1] == true && h2[2] == true && h2[3] == true && h2[4] == true {
            hTrue[1] = true
        } else {
            hTrue[1] = false
        }
        
        if h3[0] == true && h3[1] == true && h3[2] == true && h3[3] == true && h3[4] == true {
            hTrue[2] = true
        } else {
            hTrue[2] = false
        }
        
        if h4[0] == true && h4[1] == true && h4[2] == true && h4[3] == true && h4[4] == true {
            hTrue[3] = true
        } else {
            hTrue[3] = false
        }
        
        if h5[0] == true && h5[1] == true && h5[2] == true && h5[3] == true && h5[4] == true {
            hTrue[4] = true
        } else {
            hTrue[4] = false
        }
        
        //檢查直向
        let r = currentTag%5
        if r != 0 {
            if h1[r-1] == true && h2[r-1] == true && h3[r-1] == true && h4[r-1] == true && h5[r-1] == true {
                vTrue[r-1] = true
            } else {
                vTrue[r-1] = false
            }
        } else {
            if h1[4] == true && h2[4] == true && h3[4] == true && h4[4] == true && h5[4] == true {
                vTrue[4] = true
            } else {
                vTrue[4] = false
            }
        }
        
        //檢查斜線
        if h1[0] == true && h2[1] == true && h3[2] == true && h4[3] == true && h5[4] == true {
            slashTrue[0] = true
        } else {
            slashTrue[0] = false
        }
        if h1[4] == true && h2[3] == true && h3[2] == true && h4[1] == true && h5[0] == true {
            slashTrue[1] = true
        } else {
            slashTrue[1] = false
        }
    }
    
    
    func aiCheck(currentTag: Int) {
        //檢查橫向
        if aih1[0] == true && aih1[1] == true && aih1[2] == true && aih1[3] == true && aih1[4] == true {
            aihTrue[0] = true
        } else {
            aihTrue[0] = false
        }
        
        if aih2[0] == true && aih2[1] == true && aih2[2] == true && aih2[3] == true && aih2[4] == true {
            aihTrue[1] = true
        } else {
            aihTrue[1] = false
        }
        
        if aih3[0] == true && aih3[1] == true && aih3[2] == true && aih3[3] == true && aih3[4] == true {
            aihTrue[2] = true
        } else {
            aihTrue[2] = false
        }
        
        if aih4[0] == true && aih4[1] == true && aih4[2] == true && aih4[3] == true && aih4[4] == true {
            aihTrue[3] = true
        } else {
            aihTrue[3] = false
        }
        
        if aih5[0] == true && aih5[1] == true && aih5[2] == true && aih5[3] == true && aih5[4] == true {
            aihTrue[4] = true
        } else {
            aihTrue[4] = false
        }
        
        //檢查直向
        let r = currentTag%5
        if r != 0 {
            if aih1[r-1] == true && aih2[r-1] == true && aih3[r-1] == true && aih4[r-1] == true && aih5[r-1] == true {
                aivTrue[r-1] = true
            } else {
                aivTrue[r-1] = false
            }
        } else {
            if aih1[4] == true && aih2[4] == true && aih3[4] == true && aih4[4] == true && aih5[4] == true {
                aivTrue[4] = true
            } else {
                aivTrue[4] = false
            }
        }
        
        //檢查斜線
        if aih1[0] == true && aih2[1] == true && aih3[2] == true && aih4[3] == true && aih5[4] == true {
            aiSlashTrue[0] = true
        } else {
            aiSlashTrue[0] = false
        }
        if aih1[4] == true && aih2[3] == true && aih3[2] == true && aih4[1] == true && aih5[0] == true {
            aiSlashTrue[1] = true
        } else {
            aiSlashTrue[1] = false
        }
    }
    
    
    func check(currentTag: Int) {
        if isAiMode == false {
            //只需檢查使用者的賓果盤
            userCheck(currentTag: currentTag)
        } else {
            //使用者、電腦的賓果盤都要檢查
            userCheck(currentTag: currentTag)
            aiCheck(currentTag: currentTag)
        }
    }
    
    
    func howManyUserLines() -> Int {
        //檢查橫向
        hLine =  0
        for i in 0 ... 4{
            if hTrue[i] == true {
                hLine += 1
            }
        }
        //檢查直向
        vLine = 0
        for i in 0 ... 4{
            if vTrue[i] == true {
                vLine += 1
            }
        }
        //檢查斜線
        slashLine = 0
        for i in 0 ... 1 {
            if slashTrue[i] == true {
                slashLine += 1
            }
        }
        return hLine + vLine + slashLine
    }
    
    
    func howManyAiLines() -> Int {
        //檢查橫向
        aihLine =  0
        for i in 0 ... 4{
            if aihTrue[i] == true {
                aihLine += 1
            }
        }
        //檢查直向
        aivLine = 0
        for i in 0 ... 4{
            if aivTrue[i] == true {
                aivLine += 1
            }
        }
        //檢查斜線
        aiSlashLine = 0
        for i in 0 ... 1 {
            if aiSlashTrue[i] == true {
                aiSlashLine += 1
            }
        }
        return aihLine + aivLine + aiSlashLine
    }

    
    func howManyLines() -> String {
        if isAiMode == false {
            totalLine = howManyUserLines()
            if totalLine == 0 {
                return "目前還沒有連線喔"
            } else if totalLine == 1 || totalLine == 2 || totalLine == 3 || totalLine == 4 {
                return "目前有\(totalLine)條連線囉"
            }
            return "🎉You win~ Bingo! Bingo!🎉"
        } else if isAiMode == true {
            totalLine = howManyUserLines()
            aiTotalLine = howManyAiLines()
            if aiTotalLine == 5 {
                if totalLine == 5 {
                    return "這一局雙方平手囉！"
                } else if totalLine != 5 {
                    return "😩oops... AI wins!😩"
                }
            } else {
                if totalLine == 5 {
                    return "🎉You win~ Bingo! Bingo!🎉"
                } else if totalLine == 1 || totalLine == 2 || totalLine == 3 || totalLine == 4 {
                    return "目前有\(totalLine)條連線囉"
                }
            }
        }
        return "目前還沒有連線喔"
    }
    
    
    func scanAiButtonTitle(target: String) {
        print("user number to ai: \(target)")
        for i in 0 ... 24 {
            if aiButton[i].currentTitle == target {
                if isAiSelected[i] == false {
                    isAiSelected[i] = true
                    aiButton[i].isSelected = true
                    let index = i + 1
                    updateAiH(currentTag: index)
                    aiCheck(currentTag: index)
                } else {
                    isAiSelected[i] = false
                    aiButton[i].isSelected = false
                    let index = i + 1
                    updateAiH(currentTag: index)
                    aiCheck(currentTag: index)
                }
            }
        }
        isAiTurn = true
    }
    
    
    func random() -> Int {
        let number = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
        let index = Int.random(in: 0 ... number.count - 1)
        return number[index]
    }
    
    
    func aiTurn() {
        let aiNumber = random()
        if isAiTurn == true {
            for i in 0 ... 24 {
                if aiButton[i].currentTitle == "\(aiNumber)" {
                    if isAiSelected[i] == false {
                        aiButton[i].isSelected = true
                        isAiSelected[i] = true
                        aiNumberToUser = aiNumber
                        let aiCurrentTag = i + 1
                        updateAiH(currentTag: aiCurrentTag)
                        aiCheck(currentTag: aiCurrentTag)
                        print("aiNumberToUser:\(aiNumberToUser)")
                        isAiTurn = false
                        break
                    } else if isAiSelected[i] == true {
                        //重新產生aiNumber(--556行)，並且重新檢驗此數值是否被選取過(--即此段程式的for i in 0... 24以下開始)
                        aiTurn()
                        }
                    }
                }
            } else if isAiTurn == false {
            aiNumberToUser = 0
        }
    }
    
}
