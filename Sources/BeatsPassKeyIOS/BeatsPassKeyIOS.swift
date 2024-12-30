import SwiftGodot
import AuthenticationServices

#initSwiftExtension (
    cdecl: "swift_entry_point",
    types: [BeatsPassKeyIOS.self]
)

@Godot
class BeatsPassKeyIOS: RefCounted {

	private var authenticationAnchor: ASPresentationAnchor?

	@Callable
	func hello() -> Void {
		print("hey!")
	}

	@Callable
	func initiateSignInWithPasskey(requestJson: String) {
		guard let requestData = requestJson.data(using: .utf8) else {
			emitSignal("sign_in_passkey_error", "Invalid JSON format.")
			return
		}

		do {
			let request = try ASAuthorizationPlatformPublicKeyCredentialAssertionRequest(fromJSON: requestData)
			let authController = ASAuthorizationController(authorizationRequests: [request])
			authController.delegate = self
			authController.presentationContextProvider = self
			authController.performRequests()
		} catch {
			emitSignal("sign_in_passkey_error", "Failed to parse request JSON: \(error.localizedDescription)")
		}
	}

	@Callable
	func createPasskey(requestJson: String) {
		guard let requestData = requestJson.data(using: .utf8) else {
			emitSignal("create_passkey_error", "Invalid JSON format.")
			return
		}

		do {
			let request = try ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest(fromJSON: requestData)
			let authController = ASAuthorizationController(authorizationRequests: [request])
			authController.delegate = self
			authController.presentationContextProvider = self
			authController.performRequests()
		} catch {
			emitSignal("create_passkey_error", "Failed to parse request JSON: \(error.localizedDescription)")
		}
	}

	private func emitSignal(_ signalName: String, _ data: String) {
		let signalInfo = SignalInfo(name: signalName, arguments: [String.self])
		try? Godot.emit(signalInfo, withArguments: [data])
	}
}

extension BeatsPassKeyIOS: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredential {
			if let assertionResponse = credential.authenticationResponseJSON {
				emitSignal("sign_in_passkey_completed", assertionResponse)
				return
			}
			if let registrationResponse = credential.registrationResponseJSON {
				emitSignal("create_passkey_completed", registrationResponse)
				return
			}
		}
			emitSignal("create_passkey_error", "Unexpected credential type.")
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		emitSignal("create_passkey_error", error.localizedDescription)
	}
}

extension BeatsPassKeyIOS: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
	}
}
