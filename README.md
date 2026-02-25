# FinBoss iOS

Native iOS application for the FinBoss financial management ecosystem. Built with Swift, SwiftUI, and modern iOS development practices.

## Overview

FinBoss iOS is a native iOS app providing financial management capabilities including transactions, budgets, analytics, and user authentication. The app follows the MVVM architecture pattern with manual constructor-based dependency injection.

## Tech Stack

- **Language:** Swift 6
- **UI Framework:** SwiftUI
- **Minimum iOS:** 16.0 or later
- **Dependency Injection:** Manual constructor-based DI
- **HTTP Client:** URLSession (native)
- **Secure Storage:** iOS Keychain (native)
- **Package Manager:** Swift Package Manager (SPM)

## Project Structure

```
FinBossiOS/
├── FinBoss/
│   ├── App/
│   │   └── FinBossApp.swift          # SwiftUI entry point
│   ├── DI/
│   │   └── DependencyContainer.swift  # Manual DI factory
│   ├── Screens/
│   │   ├── LoginView.swift
│   │   ├── RegisterView.swift
│   │   └── HomeView.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   └── NetworkService.swift
│   ├── ViewModels/
│   │   └── AuthViewModel.swift
│   ├── Utils/
│   │   └── KeychainManager.swift
│   └── Info.plist
├── FinBoss.xcodeproj/
└── .gitignore
```

## Setup Instructions

### Prerequisites

- macOS 12.0 or later
- Xcode 15.0 or later (required for Swift Package Manager support)
- iOS 16.0+ device or simulator

### Installation

1. **Clone and navigate to project:**
   ```bash
   cd FinBossiOS
   ```

2. **Open project (SPM packages managed automatically):**
   ```bash
   open FinBoss.xcodeproj
   ```

3. **Select target and build:**
   - Xcode will automatically resolve SPM packages on first build
   - Select "FinBoss" scheme
   - Select iOS Simulator or device
   - Press Cmd+B to build or Cmd+R to run

## Build & Run

### Using Xcode
```bash
# Open project
open FinBoss.xcodeproj

# Build
xcodebuild -project FinBoss.xcodeproj -scheme FinBoss -configuration Debug

# Build for iPhone Simulator
xcodebuild -project FinBoss.xcodeproj -scheme FinBoss -sdk iphonesimulator
```

### Using Command Line
```bash
# Build
cd FinBossiOS
xcodebuild -project FinBoss.xcodeproj -scheme FinBoss -configuration Debug -sdk iphonesimulator
```

## Architecture

### MVVM Pattern
- **View:** SwiftUI components (LoginView, RegisterView, HomeView)
- **ViewModel:** AuthViewModel managing state with @Published properties
- **Model:** User and API response objects

### Dependency Injection
Uses manual constructor-based dependency injection (enterprise-standard approach):
- `DependencyContainer`: Simple factory class for creating services and ViewModels
- Explicit constructor injection with no runtime reflection
- All dependencies are type-safe and compile-time verified

### Data Flow
1. **Views** trigger actions on **ViewModels**
2. **ViewModels** call **Services** to fetch/process data
3. **Services** use **NetworkService** for API calls
4. **KeychainManager** handles secure token storage
5. **@Published** properties update Views automatically

## Dependencies

The project uses **zero external dependencies**. All functionality is built on native iOS frameworks:
- **Security Framework:** Native iOS Keychain for secure token storage
- **Foundation:** Core utilities and networking (URLSession)
- **SwiftUI:** Native UI framework

This minimizes maintenance burden and reduces attack surface.

## Configuration

### Environment
Configure the backend API URL in `Services/NetworkService.swift`:
```swift
private let baseURL = "https://finbossapi-gx2r7kziwa-uc.a.run.app"
```

For local development, change to:
```swift
private let baseURL = "http://localhost:5000"
```

### Swift Package Manager
Minimum iOS deployment target is configured in the Xcode project settings. SPM dependencies are locked in:
```
FinBoss.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

To update dependencies, use Xcode's package manager UI: `File → Add Packages...`

## Features

- ✅ User Authentication (Login/Register)
- ✅ Secure Token Storage (Keychain)
- ✅ API Integration (URLSession)
- ✅ SwiftUI-based UI
- ✅ MVVM Architecture
- ✅ Dependency Injection
- ✅ iOS 16.0+ Compatibility

## Development Guidelines

### Code Style
- Use Swift naming conventions
- Follow SwiftUI best practices
- Keep Views focused and reusable
- Use @StateObject for ViewModel ownership

### Adding Dependencies
1. Open project: `open FinBoss.xcodeproj`
2. Go to `File → Add Packages...`
3. Enter package repository URL and select version requirement
4. Select "FinBoss" target and click "Add Package"
5. Update `DependencyContainer.swift` if needed to create instances of new services

### Testing
- Unit tests can be added to Xcode test target
- Use mock services for testing ViewModels

## Troubleshooting

### Build Fails
```bash
# Clean build
xcodebuild -project FinBoss.xcodeproj -scheme FinBoss clean

# Remove derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Remove SPM build artifacts
rm -rf .build/
```

### SPM Package Resolution Issues
```bash
# In Xcode, go to File → Packages → Reset Package Caches
# Or from command line:
rm -rf ~/Library/Developer/Xcode/DerivedData/FinBoss-*

# Then rebuild
xcodebuild -project FinBoss.xcodeproj -scheme FinBoss clean build
```

### Simulator Issues
```bash
# Reset simulator
xcrun simctl erase all

# Launch specific simulator
xcrun simctl launch booted com.preetanshumishra.FinBossiOS
```

## FinBoss Ecosystem

This project is part of the FinBoss financial management ecosystem:

- **[FinBossAPI](https://github.com/preetanshumishra/FinBossAPI)** - Node.js/Express backend API with MongoDB
- **[FinBossWeb](https://github.com/preetanshumishra/FinBossWeb)** - React web frontend
- **[FinBossMobile](https://github.com/preetanshumishra/FinBossMobile)** - React Native mobile app (iOS/Android via Expo)
- **[FinBossAndroid](https://github.com/preetanshumishra/FinBossAndroid)** - Native Android app (Kotlin + Jetpack Compose)

## License

Proprietary - FinBoss Ecosystem
