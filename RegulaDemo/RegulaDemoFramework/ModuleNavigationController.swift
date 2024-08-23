import UIKit

final class ModuleNavigationController: UINavigationController {
    static let preferredSize = CGSize(width: 450, height: 800)

    /// UIModalPresentationStyle use for modals INSIDE the Onboaring
    static var presentationStyle: UIModalPresentationStyle {
        UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .pageSheet
    }

    override var isModalInPresentation: Bool {
        get {
            true
        }
        set {
            print("isModalInPresentation has been set to: \(newValue)")
        }
    }

    /// ModalPresentationStyle used for launching the Onboarding from hosting app
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
        }
        set {
            print("modalPresentationStyle has been set to: \(newValue)")
        }
    }

    override var preferredContentSize: CGSize {
        get {
            ModuleNavigationController.preferredSize
        }
        set {
            print("preferredContentSize has been set to: \(newValue)")
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { nil }
}
