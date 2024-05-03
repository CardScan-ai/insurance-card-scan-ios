# InsuranceCardScan

Our `InsuranceCardScan` swift package makes it easy to add health insurance card scanning and eligibility verification to any iOS application in **5 minutes or less.**

## Sandbox API Keys
Create an account on the [dashboard](https://dashboard.cardscan.ai/onboarding) to generate a sandbox API key.

Check out the [End User authentication](https://docs.cardscan.ai/authentication#end-user) section for how to generate short lived user JWTs


## Quick Start
### Installation

Find the [Add Package Dependency](https://developer.apple.com/documentation/swift\_packages/adding\_package\_dependencies\_to\_your\_app) menu item in Xcode,  File > Swift Packages.

Then enter the Github repository for the package:

```bash
https://github.com/CardScan-ai/insurance-card-scan-ios
```

### Usage

Import the package into your Xcode project files:

```swift
import InsuranceCardScan
```

### Basic Example:

Create the `CardScannerViewController` using the generated session token, present in the current view controller and register a callbacks to handle updates and errors.

```swift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardScanButton: UIButton!

    @IBAction private func didTapScanCard(_ sender: UIButton) {
        startCardScanning()
    }

    private func startCardScanning() {
        // Replace <GENERATED_USER_TOKEN> with the user token generated from the server
        // See https://docs.cardscan.ai/authentication#end-user

        let userToken = "<GENERATED_USER_TOKEN>"
        
        let onSuccessCallback: (InsuranceCard) -> Void = { card in
            print("Card Scanned Successfully! - \(card)")
        }

        let onErrorCallback: (CardScanError) -> Void = { error in
            print("Card Scanning Error: \(error.localizedDescription)")
        }
        
        // Configure and present the CardScanViewController
        let config = CardScanConfig(sessionToken: userToken, live: false, onSuccess: onSuccessCallback, onError: onErrorCallback)
        let cardScanViewController = CardScanViewController()
        cardScanViewController.config = config
        
        // Present the CardScanViewController
        present(cardScanViewController, animated: true)
    }
}
```

### Available Properties <a href="#available-properties" id="available-properties"></a>

`CardScanViewController` should be passed a `CardScanConfig` instance with properties for server connection, callback handling and UI customization.

```swift
CardScanConfig(
  // Required
  sessionToken: token,
  live: false,
  onSuccess: onSuccess,

  // Recommended
  onCancel: onCancel,
  onError: onError,

  //eligibility
  eligibility: eligibility,
  onEligibilitySuccess: onEligibilitySuccess,
  onEligibilityError: onEligibilityError,

  // Optional
  backsideSupport: scanBackside,
  onRetry: onRetry,
  onProgress: onProgress,

  // Camera Options
  cameraOptions: cameraOptions,

  // UI Customization
  messages: messages,
  messageStyle: messagesStyle,
  autoSwitchActiveColor: autoSwitchActiveColor,
  autoSwitchInactiveColor: autoSwitchInactiveColor,
  progressBarColor: progressBarColor,
  widgetBackgroundColor: widgetBackgroundColor,
  logging: logging,
)

```

## Documentation
Checkout the [full docs](https://docs.cardscan.ai/) and [iOS / Swift Widget docs](https://docs.cardscan.ai/ui-components/ios).