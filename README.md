# Passcode [![Platforms](https://img.shields.io/travis/divadretlaw/Passcode.svg?style=flat-square)](https://travis-ci.org/divadretlaw/Passcode) [![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage) [![Swift](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat-square)](https://swift.org) [![License](https://img.shields.io/github/license/divadretlaw/Passcode.svg?style=flat-square)](LICENSE)

## Usage

```swift
let window = ... // Window to display this on e.g. AppDelegate Window

// Config
let config = PasscodeConfig(passcodeGetter: {
            // Return code as string
        }, passcodeSetter: { code in
            // Save new code
        }, biometricsGetter: {
            // return Should use biometrics (Touch ID or Face ID) as Bool
        })

// window can be nil if you only use it on UIViewControllers
let passcode = Passcode(window: self.window, config: config)
```

Asks for Authentication over current window

```swift
passcode.authenticateWindow()
```

Asks for authentication on ViewController

```swift
passcode.authenticate(on: viewController, animated: true)
```

Asks for code on ViewController

```swift
passcode.askCode(on: viewController, animated: true)
```

Asks changes code on ViewController

```swift
passcode.changeCode(on: viewController, animated: true)
```

All functions have completions if authentication or code change was successful e.g.

```swift
passcode.askCode(on: viewController, animated: true) { success in
	print("Code was entered correctly? \(success)"
}
```

For an example implementation see the Example app.

The default passcode is `1234`

## Installation

Passcode is available through [Carthage](https://github.com/Carthage/Carthage). To install just write into your Cartfile:
 
```
github "divadretlaw/Passcode"
```

## License

See [LICENSE](LICENSE)

Copyright © 2018 David Walter \(www.davidwalter.at)
