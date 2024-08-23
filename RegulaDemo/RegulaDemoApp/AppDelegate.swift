import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var demoViewController = DemoViewController()
    private(set) var module: RegulaDemoModule?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        setupRootViewController(of: window)
        return true
    }

    private func setupRootViewController(of window: UIWindow) {
        let mainNavigationController = UINavigationController()
        window.rootViewController = mainNavigationController
        demoViewController = DemoViewController()
        demoViewController.demoDelegate = self
        mainNavigationController.setViewControllers([demoViewController], animated: false)
    }
}

extension AppDelegate: DemoDelegate {
    func launchDemo(_ viewController: DemoViewController) {
        let myModule = RegulaDemoModule()
        self.module = myModule
        guard let moduleViewController = module?.rootViewController else {
            print("Impossible to open demo module")
            return
        }
        viewController.present(moduleViewController, animated: true)
    }
}
