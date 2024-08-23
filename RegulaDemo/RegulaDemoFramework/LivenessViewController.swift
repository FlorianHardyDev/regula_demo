import FaceSDK

protocol RegulaLivenessDelegate: AnyObject {
    func onRegulaLiveness(transactionId: String?, error: Error?)
}

class LivenessViewController: UIViewController {
    let button = UIButton()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGreen
        label.text = "We should land on this screen when the liveness close button is tapped.\n\nPress button below to launch the liveness:"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Launch Liveness", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(label)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: button.topAnchor),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    @objc
    private func buttonTapped() {
        initializeAndPresentRegulaLiveness()
    }

    private func initializeAndPresentRegulaLiveness() {
        FaceSDK.service.initialize { [weak self] success, error in
            if let error {
                FaceSDK.service.deinitialize()
                self?.initializeAndPresentRegulaLiveness()
                print(error.localizedDescription)
            } else {
                self?.presentRegulaLiveness()
            }
        }
    }

    private func presentRegulaLiveness() {
        guard let navigationController else {
            print("No navigationController")
            return
        }

        let configuration = LivenessConfiguration {
            $0.isCloseButtonEnabled = true
            $0.stepSkippingMask = [.onboarding, .success]
        }

        FaceSDK.service.startLiveness(
            from: navigationController,
            animated: true,
            configuration: configuration,
            onLiveness: { [weak self] response in
                guard let self else { return }
                FaceSDK.service.customization.configuration = nil
                FaceSDK.service.requestInterceptingDelegate = nil
                if let error = response.error {
                    // There is an error. Lets see what type is it.
                    print("FaceSDK.service.deinitialize()")
                    FaceSDK.service.deinitialize()
                    onRegulaLiveness(transactionId: nil, error: error)
                }
                switch response.liveness {
                case .passed:
                    guard let transactionId = response.transactionId else {
                        print("Regula Liveness: no transactionId")
                        onRegulaLiveness(transactionId: nil, error: nil)
                        return
                    }
                    onRegulaLiveness(transactionId: transactionId, error: nil)
                    print("Regula Liveness: passed")
                case .unknown:
                    onRegulaLiveness(transactionId: nil, error: nil)
                    print("Regula Liveness: unknown")
                @unknown default:
                    onRegulaLiveness(transactionId: nil, error: nil)
                    print("Regula Liveness: default")
                }
            },
            completion: {
                print("liveness presented")
            }
        )
    }

    func onRegulaLiveness(transactionId: String?, error: (any Error)?) {
        if let transactionId {
            print("transactionId: \(transactionId)")
        } else if let error {
            print("\(error)")
            switch error {
            case LivenessError.notInitialized:
                print("Liveness not initialized.")
            case LivenessError.noLicense:
                print("There is no valid license on the service.")
            case LivenessError.apiCallFailed:
                print("Web Service API call failed due to networking error or backend internal error.")
            case LivenessError.sessionStartFailed:
                print("Session start failed.")
            case LivenessError.cancelled:
                print("User cancelled liveness processing.")
            case LivenessError.processingTimeout:
                print("Processing finished by timeout.")
            case LivenessError.processingFailed:
                // retry close button pressed ?
                print("Processing failed. Liveness service received the attempt but it failed to pass validation.")
            case LivenessError.processingFrameFailed:
                print("Reached the number of possible attempts. See `RFSLivenessConfiguration.attemptsCount` for more information.")
            case LivenessError.applicationInactive:
                // App went to the background, Retry screen is shown, and user pressed the Close button of the retry screen
                print("Client application did enter the background, liveness process interrupted.")
            case LivenessError.cameraNotAvailable:
                print("Camera not available, check premissions.")
            default:
                print("what happened here ?")
            }
        } else {
            print("What happened?")
        }
    }
}
