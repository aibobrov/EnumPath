import SwiftSyntax

internal extension EnumDeclSyntax {
    func enumCaseSyntaxElements() -> [EnumCaseElementSyntax] {
        memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }
    }
}

internal extension EnumDeclSyntax {
    func accessControl() -> TokenSyntax {
        modifiers?.lazy
            .compactMap { $0.as(DeclModifierSyntax.self)?.name }
            .first { $0.tokenKind.isAccessControl }
            ?? .keyword(.internal)
    }
}

private extension TokenKind {
    var isAccessControl: Bool {
        switch self {
        case .keyword(.internal), .keyword(.public), .keyword(.open), .keyword(.private), .keyword(.fileprivate):
            return true
        default:
            return false
        }
    }
}

internal extension EnumCaseParameterClauseSyntax {
    func typeDecl() -> DeclSyntax {
        if parameterList.count == 1, let firstParameter = parameterList.first {
            "\(firstParameter.type)"
        } else {
            "(\(parameterList))"
        }
    }
}

internal extension EnumCaseParameterClauseSyntax {
    func variableNames() -> [TokenSyntax?] {
        parameterList.map(\.firstName)
    }
}
