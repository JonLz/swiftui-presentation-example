import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var presentationDetector = PresentationDetector()

    var body: some View {
        Text("Swift UI View")
            .sheet(isPresented: self.$presentationDetector.isPresenting) {
                // on dismiss: no-op
            } content: {
                UIViewControllerBox(viewController: presentationDetector.viewControllerToPresent ?? UIViewController())
            }
    }

    func getPresentationContext() -> UIViewController {
        presentationDetector.detector
    }
}

struct UIViewControllerBox: UIViewControllerRepresentable {
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

final class PresentationDetector: ObservableObject {
    @Published var isPresenting = false

    var viewControllerToPresent: UIViewController?

    var detector: UIViewController {
        presentDetectingVC
    }

    private let presentDetectingVC = PresentingDetectingVC()

    init() {
        presentDetectingVC.onDidPresent = {
            self.viewControllerToPresent = $0
            self.isPresenting = true
        }
        presentDetectingVC.onDidDismiss = {
            self.viewControllerToPresent = nil
            self.isPresenting = false
        }
    }
}

final class PresentingDetectingVC: UIViewController {

    var onDidPresent: ((UIViewController) -> Void)?
    var onDidDismiss: (() -> Void)?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        onDidPresent?(viewControllerToPresent)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        onDidDismiss?()
    }
}
