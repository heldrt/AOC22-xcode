import SwiftUI
import SwiftGraph

extension Mine {
    func run() {
        //day1()
        //day2()
        //day3()
        day4()
        //pr("test")
    }
    
    func day4() {
        loadInput("day4")
        var totalOverlapping1 = 0
        var totalOverlapping2 = 0
        let pairs = input.components(separatedBy: "\n")
        for pair in pairs {
            let members = pair.components(separatedBy: ",")
            //pr(members[0])
            if (members.count > 1) {
                var member1Range = members[0].components(separatedBy: "-")
                var member2Range = members[1].components(separatedBy: "-")
                //pr(Int(member1Range[0]))
                var addedValue = 0
                if (Int(member1Range[0]) ?? 0 == Int(member2Range[0]) ?? 0) {
                    addedValue = 1
                } else if (Int(member1Range[1]) ?? 0 == Int(member2Range[1]) ?? 0) {
                    addedValue = 1
                } else if (Int(member1Range[0]) ?? 0 < Int(member2Range[0]) ?? 0) {
                    if (Int(member2Range[1]) ?? 0 <= Int(member1Range[1]) ?? 0) {
                        addedValue = 1
                    }
                } else if (Int(member2Range[0]) ?? 0 < Int(member1Range[0]) ?? 0) {
                    if (Int(member1Range[1]) ?? 0 <= Int(member2Range[1]) ?? 0) {
                        addedValue = 1
                    }
                }
                totalOverlapping1 = totalOverlapping1 + addedValue
                
                if (addedValue == 1) {
                    totalOverlapping2 = totalOverlapping2 + addedValue
                } else if !((Int(member1Range[0]) ?? 0 > Int(member2Range[1]) ?? 0) ||
                            (Int(member2Range[0]) ?? 0 > Int(member1Range[1]) ?? 0)){
                    totalOverlapping2 = totalOverlapping2 + 1
                }
            }
        }
        pr(totalOverlapping1)
        pr(totalOverlapping2)
    }
    
    func day3() {
        loadInput("day3")
        let charValues = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                          "u", "v", "w","x", "y", "z"]
        let sacks = input.components(separatedBy: "\n")
        var totalScore = 0
        pr(sacks.count)
        for sack in sacks {
            let sackLength = sack.count
            let compartment1 = sack.prefix(sackLength/2)
            let compartment2 = sack.suffix(sackLength/2)
            for i in 0..<compartment1.count {
                let char = compartment1[compartment1.index (compartment1.startIndex, offsetBy: i)]
                if (compartment2.firstIndex(of: char)) != nil {
                    var adder = 1
                    var modChar = String(char)
                    if char.isUppercase {
                        adder = 27
                        modChar = char.lowercased()
                    }
                    let value = adder + Int(charValues.firstIndex(of: modChar) ?? 0)
                    totalScore += value
                    break
                }
            }
        }
        pr(totalScore)
        
        var totalScore2 = 0
        for i in 0..<sacks.count/3 {
            let sack1 = sacks[i*3]
            let sack2 = sacks[i*3+1]
            let sack3 = sacks[i*3+2]
            for i in 0..<sack1.count {
                let char = sack1[sack1.index (sack1.startIndex, offsetBy: i)]
                if (sack2.firstIndex(of: char)) != nil {
                    if (sack3.firstIndex(of: char)) != nil {
                        var adder = 1
                        var modChar = String(char)
                        if char.isUppercase {
                            adder = 27
                            modChar = char.lowercased()
                        }
                        let value = adder + Int(charValues.firstIndex(of: modChar) ?? 0)
                        totalScore2 += value
                        break
                    }
                }
            }
        }
        pr(totalScore2)

    }
    
    func day2() {
        loadInput("day2")
        let opponentOptions = ["A", "B", "C"]
        let playerOptions = ["X", "Y", "Z"]
        let rounds = input.components(separatedBy: "\n")
        var totalScore = 0
        for round in rounds {
            let choices = round.components(separatedBy: " ")
            if (choices.count >= 2) {
                var choice = choices[1]
                switch (choices[1]) {
                case "X":
                    var playerIndex = (opponentOptions.firstIndex(of: choices[0]) ?? 0) - 1
                    if (playerIndex < 0) {playerIndex = 2}
                    choice = playerOptions[playerIndex]
                case "Y":
                    var playerIndex = (opponentOptions.firstIndex(of: choices[0]) ?? 0)
                    choice = playerOptions[playerIndex]
                case "Z":
                    var playerIndex = (opponentOptions.firstIndex(of: choices[0]) ?? 0) + 1
                    if (playerIndex > 2) {playerIndex = 0}
                    choice = playerOptions[playerIndex]
                default:
                    choice = choices[1]
                }
                let roundScore = determineOutcome(choices[0], choice)
                totalScore += roundScore
            }
        }
        pr(totalScore)
    }
    
    func determineOutcome(_ opponent: String, _ choice: String) -> Int {
        var score = 0
        switch choice {
        case "X":
            score += 1
            switch opponent {
            case "A":
                score += 3
            case "C":
                score += 6
            default:
                score += 0
            }
        case "Y":
            score += 2
            switch opponent {
            case "B":
                score += 3
            case "A":
                score += 6
            default:
                score += 0
            }
        case "Z":
            score += 3
            switch opponent {
            case "C":
                score += 3
            case "B":
                score += 6
            default:
                score += 0
            }
        default:
            score += 0
        }
        return score
    }
    
    func day1() {
        loadInput("day1")
        let components = input.components(separatedBy: "\n\n")
        var maxValue = 0
        var totals = [Int]()
        for chunk in components {
            let numberStrings = chunk.components(separatedBy: "\n")
            var total = 0
            for num in numberStrings {
                total += Int(num) ?? 0
            }
            totals.append(total)
            if (total > maxValue) {
                maxValue = total
            }
        }
        let sortedTotals = totals.sorted{ $0 > $1 }
        pr(maxValue)
        pr(sortedTotals[0] + sortedTotals[1] + sortedTotals[2])
    }
}

struct ContentView: View {
    let mine = Mine()
    init () {
        mine.run()
        let _ = print("hi?")
    }
    var body: some View {
        VStack {
            Text(mine.str).bold().Print(mine.str)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}

class Mine {
    func pr(_ str: Any) {
        self.str += "\n" + "\(str)"
    }

    func loadInput(_ inputName: String) {
        if let filepath = Bundle.main.path(forResource: inputName, ofType: "txt") {
            input = try! String(contentsOfFile: filepath)
        } else {
            pr("ERROR \(inputName).txt not found")
        }
    }
    public var str = ""
    public var input = ""
}

extension View {
    func Print(_ item: Any) -> some View {
        #if DEBUG
            print(item)
        #endif
        return self
    }
}

// split into tokens, parse into things
// let items = lines[i].components(separatedBy: CharacterSet(charactersIn: " \t")).compactMap { Int($0) }
