import EnumPathMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
    "EnumPath": EnumPathMacro.self
]

final class EnumPathTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @EnumPath
            private enum MyEnum {
                case test0(Int)
                case test1(Int, Int)
                case test2(a: Int, Int)
                case test3(x: String)
                case test4, test5(x: String, y: String)
            }
            """,
            expandedSource:
            """

            private enum MyEnum {
                case test0(Int)
                case test1(Int, Int)
                case test2(a: Int, Int)
                case test3(x: String)
                case test4, test5(x: String, y: String)
                private var test0: Int? {
                    get {
                        switch self {
                        case let .test0(__macro_local_10fMu_):
                            (__macro_local_10fMu_)
                        default:
                            nil
                        }
                    }
                    set {
                        if let newValue {
                            self = .test0(newValue)
                        }
                    }
                }
                private var test1: (Int, Int)? {
                    get {
                        switch self {
                        case let .test1(__macro_local_10fMu0_, __macro_local_11fMu_):
                            (__macro_local_10fMu0_, __macro_local_11fMu_)
                        default:
                            nil
                        }
                    }
                    set {
                        if let newValue {
                            self = .test1(newValue.0, newValue.1)
                        }
                    }
                }
                private var test2: (a: Int, Int)? {
                    get {
                        switch self {
                        case let .test2(__macro_local_1afMu_, __macro_local_11fMu0_):
                            (__macro_local_1afMu_, __macro_local_11fMu0_)
                        default:
                            nil
                        }
                    }
                    set {
                        if let newValue {
                            self = .test2(a: newValue.a, newValue.1)
                        }
                    }
                }
                private var test3: String? {
                    get {
                        switch self {
                        case let .test3(__macro_local_1xfMu_):
                            (__macro_local_1xfMu_)
                        default:
                            nil
                        }
                    }
                    set {
                        if let newValue {
                            self = .test3(x: newValue)
                        }
                    }
                }
                private var isTest4: Bool {
                    get {
                        switch self {
                        case .test4:
                            true
                        default:
                            false
                        }
                    }
                    set {
                        if newValue {
                            self = .test4
                        }
                    }
                }
                private var test5: (x: String, y: String)? {
                    get {
                        switch self {
                        case let .test5(__macro_local_1xfMu0_, __macro_local_1yfMu_):
                            (__macro_local_1xfMu0_, __macro_local_1yfMu_)
                        default:
                            nil
                        }
                    }
                    set {
                        if let newValue {
                            self = .test5(x: newValue.x, y: newValue.y)
                        }
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
}
