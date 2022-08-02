import UIKit

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

extension Int {
    func times(_ action: () -> Void) {
        for _ in 1...self {
            action()
        }
    }
}

5.times {
    print("Hello!")
}

var number = 5
10.times {
    number += 5
    print(number)
}

extension Array where Element: Comparable {
    mutating func isDouble(item: Element) {
        let myArray = self.filter({$0 == item}).count
        if myArray > 1 {
            self.remove(at: firstIndex(of: item)!)
        }
        print(self)
    }
    
    
}

var myArray = ["Hello", "Hello", "Hello", "GoodBye"]
myArray.isDouble(item: "Hello")
myArray.isDouble(item: "Hello")
myArray.isDouble(item: "Hello")
myArray.isDouble(item: "Goodbye")
