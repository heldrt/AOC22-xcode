import SwiftUI
import SwiftGraph

extension Mine {
    func run() {
        //day1()
        //day2()
        //day3()
        //day4()
        //day5()
        //day6()
        //day7()
        //day8()
        day9()
        //pr("test")
    }
    
    func day9() {
        loadInput("day9")
        let mapSideSize = 1024
        let numKnots = 10
        var knots = Array(repeating:(mapSideSize/2,mapSideSize/2), count: numKnots)
        var map = Array(repeating: Array(repeating: 0, count: mapSideSize), count: mapSideSize)
        map[knots[numKnots - 1].0][knots[numKnots - 1].1] = 1
        let lines = input.components(separatedBy: "\n")
        for line in lines {
            let components = line.components(separatedBy: " ")
            if (components.count > 1) {
                let direction = components[0]
                var distance = Int(components[1]) ?? 0
                var headMovement = (0,0)
                switch (direction) {
                case "U":
                    headMovement = (0,1)
                case "D":
                    headMovement = (0,-1)
                case "L":
                    headMovement = (-1,0)
                case "R":
                    headMovement = (1,0)
                default:
                    pr("No direction")
                }
                
                while (distance > 0){
                    knots[0].0 = knots[0].0 + headMovement.0
                    knots[0].1 = knots[0].1 + headMovement.1
                    
                    for i in 1..<numKnots {
                        if (abs(knots[i-1].1 - knots[i].1) + abs(knots[i-1].0 - knots[i].0)) == 3 {
                            knots[i].0 = knots[i].0 + (knots[i-1].0 - knots[i].0).signum()
                            knots[i].1 = knots[i].1 + (knots[i-1].1 - knots[i].1).signum()
                        } else {
                            if abs(knots[i-1].1 - knots[i].1) == 2 {
                            knots[i].1 = knots[i].1 + (knots[i-1].1 - knots[i].1).signum()
                            }
                            if abs(knots[i-1].0 - knots[i].0) == 2 {
                                knots[i].0 = knots[i].0 + (knots[i-1].0 - knots[i].0).signum()
                            }
                        }
                    }
                    map[knots[numKnots-1].0][knots[numKnots-1].1] = 1
                    distance = distance - 1
                }
            }
        }
        var totalVisited = 0
        for row in 0..<map.count {
            for column in 0..<map[row].count{
                totalVisited = totalVisited + map[row][column]
            }
        }
        pr (totalVisited)
    }
    
    func day8() {
        loadInput("day8")
        let lines = input.components(separatedBy: "\n")
        var heights = [[Int]]()
        var leftVisibility = [[Bool]]()
        var rightVisibility = [[Bool]]()
        var topVisibility = [[Bool]]()
        var bottomVisibility = [[Bool]]()
        
        // Create heights array
        for row in 0..<lines.count {
            let line = lines[row]
            var newRow = [Int]()
            for column in 0..<line.count {
                newRow.append(Int(String(line[line.index(line.startIndex, offsetBy: column)])) ?? 0)
            }
            heights.append(newRow)
        }
        
        // Check right visibility
        for row in 0..<heights.count {
            var highest = -1
            var newVisibilityRow = [Bool]()
            for column in 0..<heights[row].count {
                if heights[row][column] > highest {
                    highest = heights[row][column]
                    newVisibilityRow.append(true)
                } else {
                    newVisibilityRow.append(false)
                }
            }
            rightVisibility.append(newVisibilityRow)
        }
        
        // Check left visibility
        for row in 0..<heights.count{
            var highest = -1
            var newVisibilityRow = [Bool]()
            for column in (0..<heights[row].count).reversed() {
                if heights[row][column] > highest {
                    highest = heights[row][column]
                    newVisibilityRow.insert(true, at: 0)
                } else {
                    newVisibilityRow.insert(false, at: 0)
                }
            }
            leftVisibility.append(newVisibilityRow)
            //pr(leftVisibility[row])
        }
        
        // Prep top and bottom visibility arrays
        var emptyRow = [Bool]()
        for _ in 0..<heights[0].count {
            emptyRow.append(false)
        }
        for _ in 0..<heights.count {
            topVisibility.append(emptyRow)
            bottomVisibility.append(emptyRow)
        }

        
        // Check top visibility
        for column in 0..<heights[0].count {
            var highest = -1
            for row in 0..<heights.count {
                if (heights[row].count > 0) {
                    if heights[row][column] > highest {
                        highest = heights[row][column]
                        topVisibility[row][column] = true
                    } else {
                        topVisibility[row][column] = false
                    }
                }
            }
        }
        
        // Check bottom visibility
        for column in 0..<heights[0].count {
            var highest = -1
            for row in (0..<heights.count).reversed() {
                if (heights[row].count > 0) {
                    if heights[row][column] > highest {
                        highest = heights[row][column]
                        bottomVisibility[row][column] = true
                    } else {
                        bottomVisibility[row][column] = false
                    }
                }
            }
        }
        
        var visibilityCount = 0
        
        for row in 0..<heights.count {
            for column in 0..<heights[row].count {
                if (rightVisibility[row][column] ||
                    leftVisibility[row][column] ||
                    topVisibility[row][column] ||
                    bottomVisibility[row][column]) {
                    visibilityCount = visibilityCount + 1
                }
            }
        }
        //pr(visibilityCount)
        
        var bestScore = 0
        for row in 0..<heights.count {
            for column in 0..<heights[row].count {
                let currentTreeHeight = heights[row][column]
                var rightDistance = 0
                for c in (column + 1)..<heights[row].count {
                    if c >= heights[row].count {
                        break
                    } else if heights[row][c] < currentTreeHeight {
                        rightDistance = rightDistance + 1
                    } else {
                        rightDistance = rightDistance + 1
                        break
                    }
                }
                var leftDistance = 0
                for c in (0..<(column)).reversed() {
                    if c < 0 {
                        break
                    } else if heights[row][c] < currentTreeHeight {
                        leftDistance = leftDistance + 1
                    } else {
                        leftDistance = leftDistance + 1
                        break
                    }
                }
                var bottomDistance = 0
                for r in (row + 1)..<heights.count {
                    if r >= heights.count {
                        break
                    } else if heights[r].count == 0 {
                        break
                    } else if heights[r][column] < currentTreeHeight {
                        bottomDistance = bottomDistance + 1
                    } else {
                        bottomDistance = bottomDistance + 1
                        break
                    }
                }
                //pr(bottomDistance)
                var topDistance = 0
                for r in (0..<(row)).reversed() {
                    if r < 0 {
                        break
                    } else if heights[r][column] < currentTreeHeight {
                        topDistance = topDistance + 1
                    } else {
                        topDistance = topDistance + 1
                        break
                    }
                }
//                pr(topDistance)
                let totalScore = rightDistance * leftDistance * topDistance * bottomDistance
                if (totalScore > bestScore){
                    bestScore = totalScore
                }
            }
        }
        pr(bestScore)
    }
    
    func day7() {
        let rootNode: TreeNode = TreeNode(name: "root", size: 0)
        var currentNode = rootNode
        
        loadInput("day7")
        let lines = input.components(separatedBy: "\n")
        for line in lines {
            if line.contains("$ cd") {
                if line.contains("/") {
                    currentNode = rootNode
                } else if line.contains(".."){
                    currentNode = currentNode.getParent()
                } else {
                    let start = line.index(line.startIndex, offsetBy: 5)
                    let end = line.index(line.endIndex, offsetBy: 0)
                    let range = start..<end
                    let directoryName = String(line[range])
                    currentNode = currentNode.getChild(name: directoryName)
                }
            } else if line.contains("dir ") {
                let start = line.index(line.startIndex, offsetBy: 4)
                let end = line.index(line.endIndex, offsetBy: 0)
                let range = start..<end
                let directoryName = String(line[range])
                let newNode: TreeNode = TreeNode(name: directoryName, size: 0, parent: currentNode)
                currentNode.add(newNode)
            } else if !(line.contains("$ ls")) {
                let components = line.components(separatedBy: " ")
                if (components.count > 1) {
                    let newNode: TreeNode = TreeNode(name: components[1], size: Int(components[0]) ?? 0, parent: currentNode)
                    currentNode.add(newNode)
                }
            }
        }
        
        let amountToFree = 30000000 - (70000000 - rootNode.getSize())
        pr(rootNode.getSizeUnderMax(max: 100000))
        pr(rootNode.getSmallestDirectoryToDelete(size: amountToFree))
    
    }
    
    
    
    
    func day6() {
        loadInput("day6")
        var counts: [Character: Int] = [:]
        let markerLength = 14
        var charBuffer = [Character]()
        pr(input.count)
        if (input.count < markerLength) {
            return
        } else {
            for i in 0..<markerLength {
                charBuffer.append(input[input.index(input.startIndex, offsetBy: i)])
            }
            var repetitionFound = false
            for item in charBuffer {
                counts[item] = (counts[item] ?? 0) + 1
                if (counts[item] ?? 0) > 1 {
                    repetitionFound = true
                }
            }
            if !repetitionFound {
                pr(charBuffer)
                pr(markerLength-1)
            }
            let start = input.index(input.startIndex, offsetBy: markerLength)
            let end = input.index(input.endIndex, offsetBy: 0)
            let range = start..<end
            let inputSubstring = input[range]
            for (index, char) in inputSubstring.enumerated() {
                if (index) < inputSubstring.count {
                    let firstChar = charBuffer.first ?? Character("a")
                    counts[firstChar] = (counts[firstChar] ?? 0) - 1
                    charBuffer.removeFirst()
                    charBuffer.append(char)
                    counts[char] = (counts[char] ?? 0) + 1
                    var repetitionFound = false
                    for item in charBuffer {
                        if (counts[item] ?? 0) > 1 {
                            repetitionFound = true
                        }
                    }
                    if !repetitionFound {
                        pr(charBuffer)
                        pr(index+markerLength+1)
                        return
                    }
                } else {
                    return
                }
            }
        }
    }
        
    
    func day5() {
        loadInput("day5")
        let stackCount = 9
        var stacks = [[String]]()
        for _ in 0..<stackCount {
            stacks.append([String]())
        }
        let lines = input.components(separatedBy: "\n")
        for i in 0..<lines.count {
            let line = lines[lines.index (lines.startIndex, offsetBy: i)]
            if (line.firstIndex(of: "[") != nil) {
                for j in 0..<stackCount {
                    let charPosition = 1+j*4
                    let contents = String(line[line.index (line.startIndex, offsetBy: charPosition)])
                    if (contents != " ") {
                        stacks[j].append(contents)
                       // pr(String(j) + " " + contents)
                    }
                }
            } else if (line.contains("move")) {
                let start = line.index(line.startIndex, offsetBy: 5)
                let end = line.index(line.endIndex, offsetBy: 0)
                let range = start..<end
                let lineSubstring = line[range]
                let endMoveAmount = lineSubstring.firstIndex(of: " ") ?? lineSubstring.endIndex
                let movementString = lineSubstring[lineSubstring.startIndex..<endMoveAmount]
                //pr(lineSubstring[lineSubstring.index (lineSubstring.startIndex, offsetBy: 0)])
                let moveAmount = Int(movementString) ?? 0
                let fromStack = Int(String(lineSubstring[lineSubstring.index(endMoveAmount, offsetBy: 6)]))!-1
                let toStack = Int(String(lineSubstring[lineSubstring.index(endMoveAmount, offsetBy: 11)]))!-1
                // First part
//                for _ in 0..<moveAmount {
//                    //pr(stacks[fromStack].first)
//                    stacks[toStack].insert(stacks[fromStack].first!, at:stacks[toStack].startIndex)
//                    stacks[fromStack].removeFirst()
//                }
                // Second part
                let setToMove = stacks[fromStack][0...(moveAmount-1)]
                stacks[toStack].insert(contentsOf: setToMove, at:stacks[toStack].startIndex)
                stacks[fromStack].removeFirst(moveAmount)
            }
        }
        for s in 0..<stackCount {
           pr(stacks[s].first)
        }
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

//    func day3() {
//        loadInput("day3")
//        let charValues = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
//                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
//                          "u", "v", "w","x", "y", "z"]
//        let sacks = input.components(separatedBy: "\n")
//        var totalScore = 0
//        pr(sacks.count)
//        for sack in sacks {
//            let sackLength = sack.count
//            let compartment1 = sack.prefix(sackLength/2)
//            let compartment2 = sack.suffix(sackLength/2)
//            for i in 0..<compartment1.count {
//                let char = compartment1[compartment1.index (compartment1.startIndex, offsetBy: i)]
//                if (compartment2.firstIndex(of: char)) != nil {
//                    var adder = 1
//                    var modChar = String(char)
//                    if char.isUppercase {
//                        adder = 27
//                        modChar = char.lowercased()
//                    }
//                    let value = adder + Int(charValues.firstIndex(of: modChar) ?? 0)
//                    totalScore += value
//                    break
//                }
//            }
//        }
//        pr(totalScore)
//
//        var totalScore2 = 0
//        for i in 0..<sacks.count/3 {
//            let sack1 = sacks[i*3]
//            let sack2 = sacks[i*3+1]
//            let sack3 = sacks[i*3+2]
//            for i in 0..<sack1.count {
//                let char = sack1[sack1.index (sack1.startIndex, offsetBy: i)]
//                if (sack2.firstIndex(of: char)) != nil {
//                    if (sack3.firstIndex(of: char)) != nil {
//                        var adder = 1
//                        var modChar = String(char)
//                        if char.isUppercase {
//                            adder = 27
//                            modChar = char.lowercased()
//                        }
//                        let value = adder + Int(charValues.firstIndex(of: modChar) ?? 0)
//                        totalScore2 += value
//                        break
//                    }
//                }
//            }
//        }
//        pr(totalScore2)
//
//    }

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


class TreeNode {
    public var name: String
    public var size: Int
    public var parent: TreeNode?
    public var children: [TreeNode] = []
    
    public init(name: String, size: Int, parent: TreeNode? = nil) {
        self.name = name
        self.size = size
        self.parent = parent ?? nil
    }
    
    public func add(_ child: TreeNode) {
        children.append(child)
    }
    
    public func getSize() -> Int{
        var totalSize: Int = self.size
        for child in children {
            totalSize = totalSize + child.getSize()
        }
        return totalSize
    }
    

    public func getSmallestDirectoryToDelete(size: Int) -> (total: Int, closestSize: Int) {
        var totalSize: Int = self.size
        var closestSize: Int = Int.max
        for child in children {
            let closestSizeData = child.getSmallestDirectoryToDelete(size: size)
            totalSize = totalSize + closestSizeData.total
            if ((closestSizeData.closestSize >= size) && (closestSizeData.closestSize < closestSize)) {
                closestSize = closestSizeData.closestSize
            }
        }
        if ((totalSize >= size) && (totalSize < closestSize) && children.count > 0)  ||
            ((closestSize == 0) && (children.count > 0)){
            closestSize = totalSize
        }
        return (totalSize, closestSize)
    }
                                              
                                              
    public func getSizeUnderMax(max: Int) -> (total: Int, totalUnderMax: Int){
        var totalSize: Int = self.size
        var totalSizeUnderMax: Int = 0
        for child in children {
            let totalValues = child.getSizeUnderMax(max: max)
            totalSizeUnderMax = totalSizeUnderMax + totalValues.totalUnderMax
            totalSize = totalSize + totalValues.total
        }
        if (totalSize < max && children.count > 0) {
            totalSizeUnderMax = totalSizeUnderMax + totalSize
        }
        return (totalSize, totalSizeUnderMax)
    }
                                              
    public func getParent() -> TreeNode{
        return self.parent ?? self
    }
    
    public func getChild(name: String) -> TreeNode{
        for child in children {
            if (child.name == name) {
                return child
            }
        }
        return self
    }
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
