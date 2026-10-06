# Mousement

A lightweight, native macOS menu bar application that simulates natural mouse movements and scrolls to prevent your computer from going idle. Perfect for time-tracking apps (like Cattr).

## Features
- Runs silently in the background (Menu Bar only, no Dock icon).
- Simulates human-like small cursor movements and slight scrolling.
- Global shortcut `Cmd + Option + Control + M` to toggle on/off.
- Configurable interval via dropdown menu (1, 3, 5, 10, or 15 minutes).
- Visual status indicator in the menu bar (Gray = Inactive, White = Active).

## Installation

### Option 1: Using Homebrew (Recommended)
You can install Mousement directly via Homebrew using our custom tap:
```bash
brew tap zenmz/mousement https://github.com/zenmz/mousement
brew install --cask mousement
```

### Option 2: Using Curl (Automated Script)
Run this command in your terminal to automatically download and install:
```bash
curl -sL https://raw.githubusercontent.com/zenmz/mousement/main/install.sh | bash
```

### Option 3: Manual Installation
1. Go to the [Releases](https://github.com/zenmz/mousement/releases) page.
2. Download `Mousement.zip`.
3. Extract the ZIP file and drag `Mousement.app` into your `Applications` folder.

## Permissions
On the first launch, macOS will ask for **Accessibility Permissions**.
1. Click **Open System Settings**.
2. Go to **Privacy & Security > Accessibility**.
3. Turn on the toggle for `Mousement`.
4. Restart the app.

## Building from source
```bash
cd MousementApp
./build.sh
```

## License
MIT
