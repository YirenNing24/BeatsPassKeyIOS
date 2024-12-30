import SwiftGodot
import AuthenticationServices

#initSwiftExtension (
    cdecl: "swift_entry_point",
    types: [BeatsPassKeyIOS.self]
)

@Godot
class BeatsPassKeyIOS: RefCounted {
    
    @Callable
    func hello() -> Void {
        print("hey!")
    }

    
}
