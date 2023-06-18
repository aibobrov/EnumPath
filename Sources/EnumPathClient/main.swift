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
