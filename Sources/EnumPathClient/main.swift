import SwiftUI

@available(macOS 11.0, *)
struct EnumPathApp: App {
    @State private var model: MyEnum = .test0(0)
    var body: some Scene {
        WindowGroup {
            
        }
    }
}

struct ContentView: View {
    @State private var model: MyEnum = .test0(0)
    
    var body: some View {
        if let counter = Binding($model.test0) {
            DetailView(counter: counter)
        }
    }
}

struct DetailView: View {
    @Binding var counter: Int
    var body: some View {
        Stepper(value: $counter) {
            Text("Count")
        }
//        Button("Count: \(counter)") {
//            counter += 1
//        }
    }
}

import EnumPath

@EnumPath
public enum MyEnum {
    case test0(Int)

    case test1(Int, Int)

    case test2(a: Int, Int)

    case test3(x: String)

    case test4, test5(x: String, y: String)
}

var value: MyEnum = .test0(0)

value.test2 = (1, 1)

print(value, value.isTest4)
