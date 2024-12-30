import SwiftGodot
import AuthenticationServices

#initSwiftExtension (
    cdecl: "swift_entry_point",
    types: [BeatsPassKeyIOS.self]
)

@Godot
class BeatsPassKeyIOS: RefCounted {

    private var authorizationController: ASAuthorizationController?

    @Callable
    func hello() -> Void {
        print("hey!")
    }

    @Callable
    func initiateSignInWithPasskey(requestJson: String) -> Void {
        guard let requestData = requestJson.data(using: .utf8) else {
            emitSignal("sign_in_passkey_error", ["Invalid JSON data"])
            return
        }

        do {
            let credentialRequest = try JSONDecoder().decode(ASAuthorizationPlatformPublicKeyCredentialDescriptor.self, from: requestData)

            let request = ASAuthorizationPlatformPublicKeyCredentialProvider().createCredentialAssertionRequest(descriptor: credentialRequest)

            self.authorizationController = ASAuthorizationController(authorizationRequests: [request])
            self.authorizationController?.delegate = self
            self.authorizationController?.presentationContextProvider = self
            self.authorizationController?.performRequests()

        } catch {
            emitSignal("sign_in_passkey_error", ["Failed to parse request JSON"])
        }
    }

    @Callable
    func createPasskey(requestJson: String) -> Void {
        guard let requestData = requestJson.data(using: .utf8) else {
            emitSignal("create_passkey_error", ["Invalid JSON data"])
            return
        }

        do {
            let descriptor = try JSONDecoder().decode(ASAuthorizationPlatformPublicKeyCredentialDescriptor.self, from: requestData)

            let registrationRequest = ASAuthorizationPlatformPublicKeyCredentialProvider().createCredentialRegistrationRequest(descriptor: descriptor)

            self.authorizationController = ASAuthorizationController(authorizationRequests: [registrationRequest])
            self.authorizationController?.delegate = self
            self.authorizationController?.presentationContextProvider = self
            self.authorizationController?.performRequests()

        } catch {
            emitSignal("create_passkey_error", ["Failed to parse request JSON"])
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension BeatsPassKeyIOS: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredential {
            if let credentialData = credential.rawCredential,
               let responseJson = String(data: credentialData, encoding: .utf8) {
                emitSignal("sign_in_passkey_completed", [responseJson])
            } else {
                emitSignal("sign_in_passkey_error", ["Failed to decode credential data"])
            }
        } else {
            emitSignal("sign_in_passkey_error", ["Unexpected credential type"])
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        emitSignal("sign_in_passkey_error", [error.localizedDescription])
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension BeatsPassKeyIOS: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
