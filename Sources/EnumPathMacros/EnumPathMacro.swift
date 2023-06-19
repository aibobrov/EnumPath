import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EnumPathMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(EnumPathDiagnostic.requiresEnum.diagnose(at: declaration))
            return []
        }

        let accessControl = enumDecl.accessControl()

        return enumDecl.enumCaseSyntaxElements().map { caseElement in
            if let associatedValue = caseElement.associatedValue {
                associatedValueGetSetDecl(
                    caseElement,
                    associatedValue: associatedValue,
                    with: accessControl,
                    in: context
                )
            } else {
                booleanCheckDecl(caseElement, with: accessControl)
            }
        }
    }

    private static func associatedValueGetSetDecl(
        _ caseElement: EnumCaseElementSyntax,
        associatedValue: EnumCaseParameterClauseSyntax,
        with accessControl: TokenSyntax,
        in context: some MacroExpansionContext
    ) -> DeclSyntax {
        let associatedValueNames = associatedValue.variableNames()
        let uniqueNames = associatedValueNames.enumerated().map { context.createUniqueName($0.element?.text ?? $0.offset.description) }
        let argumentsString = uniqueNames.map(\.text).joined(separator: ", ")
        let setArgumentsString = if associatedValueNames.count == 1 {
            if let name = associatedValueNames.first! {
                "\(name): newValue"
            } else {
                "newValue"
            }
        } else {
            associatedValueNames.enumerated().map { offset, name in
                if let name {
                    "\(name): newValue.\(name)"
                } else {
                    "newValue.\(offset)"
                }
            }.joined(separator: ", ")
        }
        return """
        \(inlinableDeclIfNeeded(accessControl)) \(accessControl) var \(caseElement.identifier): \(associatedValue.typeDecl())? {
            get {
                switch self {
                case let .\(caseElement.identifier)(\(raw: argumentsString)):
                    (\(raw: argumentsString))
                default:
                    nil
                }
            }
            set {
                if let newValue {
                    self = .\(caseElement.identifier)(\(raw: setArgumentsString))
                }
            }
        }
        """
    }

    private static func booleanCheckDecl(
        _ caseElement: EnumCaseElementSyntax,
        with accessControl: TokenSyntax
    ) -> DeclSyntax {
        """
        \(inlinableDeclIfNeeded(accessControl)) \(accessControl) var is\(raw: caseElement.identifier.text.capitalized): Bool {
            get {
                switch self {
                case .\(caseElement.identifier):
                    true
                default:
                    false
                }
            }
            set {
                if newValue {
                    self = .\(caseElement.identifier)
                }
            }
        }
        """
    }

    private static func inlinableDeclIfNeeded(_ accessControl: TokenSyntax) -> DeclSyntax {
        switch accessControl.tokenKind {
        case .keyword(.public), .keyword(.open):
            DeclSyntax("@inlinable")
        default:
            DeclSyntax("")
        }
    }
}

@main
struct EnumPathPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumPathMacro.self
    ]
}
