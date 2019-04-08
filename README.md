# APIPlayground
The iOS application to test your API

### Requirements
- XCode 10.2
- Swift 5

### Installation
Clone or download this project to your computer

By SSH: `git@github.com:maios/APIPlayground.git`\
By HTTPS: `https://github.com/maios/APIPlayground.git`

In `Terminal`, navigate to the project directory and run: `./bootstrap.sh`
This step will setup all the necessary dependencies of the project i.e install/update [Homebrew](https://brew.sh) and install/upgrade [Carthage](https://github.com/Carthage/Carthage)

Open the project in XCode and you should be able to build the application in both simulator and devices.

### Frameworks of use
- [Eureka](https://github.com/xmartlabs/Eureka) for building inputs form.
- [Moya](https://github.com/Moya/Moya) for network requests
- [RxSwift](https://github.com/ReactiveX/RxSwift)

### Architecture
This project is following MVVM architecture

### Design Patterns

- Coordinator/Navigator

  This project is using the basic `Navigator` pattern to handle the navigation of the application.
  Source: [Navigation in Swift - Swift by Sundell](https://www.swiftbysundell.com/posts/navigation-in-swift)
