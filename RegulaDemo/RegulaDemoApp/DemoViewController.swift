import UIKit

protocol DemoDelegate: AnyObject {
    func launchDemo(_ viewController: DemoViewController)
}

class DemoViewController: UIViewController {
    weak var demoDelegate: DemoDelegate?

    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Launch Demo", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    @objc
    private func buttonTapped() {
        demoDelegate?.launchDemo(self)
    }
}
