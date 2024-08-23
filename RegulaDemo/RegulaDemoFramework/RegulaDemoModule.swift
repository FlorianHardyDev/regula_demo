import Foundation
import UIKit

public class RegulaDemoModule: NSObject {
    public let rootViewController: UINavigationController

    public override init() {
        rootViewController = ModuleNavigationController()
        let livenessViewController =  LivenessViewController()
        rootViewController.setViewControllers([livenessViewController], animated: false)
        super.init()
    }
}
