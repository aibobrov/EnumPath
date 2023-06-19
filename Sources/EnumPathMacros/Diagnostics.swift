import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum EnumPathDiagnostic {
    case requiresEnum
}

extension EnumPathDiagnostic: DiagnosticMessage {
    var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "EnumPath.\(self)")
    }

    var severity: DiagnosticSeverity { .error }

    func diagnose(at node: some SyntaxProtocol, fixIts: [FixIt] = []) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self, fixIts: fixIts)
    }

    var message: String {
        switch self {
        case .requiresEnum:
            return "'EnumPath' macro can only be applied to an enum"
        }
    }
}
