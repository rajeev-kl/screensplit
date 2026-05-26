# ScreenSplit

ScreenSplit is a lightweight, unobtrusive macOS window manager inspired by the `gTile` extension for GNOME. It allows you to rapidly tile and arrange your windows using a dynamic, screen-adaptive grid overlay.

## Features

- **Dynamic Grid**: The grid size automatically adapts to your screen size and resolution (e.g., automatically scales up for ultrawide monitors).
- **Edge-to-Edge Snapping**: Windows snap perfectly with zero padding or gaps.
- **Global Hotkey**: Press `Command + G` from anywhere to invoke the grid.
- **Mouse Drag**: Simply click and drag across the grid to snap your active window into that exact region.
- **Menu Bar App**: Runs silently in your menu bar without cluttering your dock.

## Installation & Usage

Because ScreenSplit is not distributed through the Mac App Store and is not signed with a paid Apple Developer certificate, macOS will try to block it by default. Please follow these instructions carefully.

1. **Download**: Download the latest `ScreenSplit.dmg` from the [Releases page](https://github.com/rajeev-kl/screensplit/releases).
2. **Install**: Open the DMG and drag `ScreenSplit.app` to your Applications folder.
3. **Bypass Gatekeeper**: 
   - **Do NOT double-click the app to open it the first time.** macOS will say the app is damaged or cannot be verified.
   - Instead, **Right-Click** (or Control-Click) `ScreenSplit.app` in your Applications folder and select **Open**. 
   - A prompt will appear. Click **Open** again to bypass the security warning.
4. **Grant Accessibility Permissions**: 
   - ScreenSplit needs permission to move other apps' windows.
   - The first time you run it, macOS will prompt you for Accessibility access.
   - Go to **System Settings > Privacy & Security > Accessibility**.
   - Toggle the switch next to **ScreenSplit** to turn it on.

## How to Tile Windows

1. Click on the window you want to move (e.g., Safari, Finder) so it is the active foreground window.
2. Press **`Command + G`**.
3. A transparent grid overlay will appear on your screen.
4. Click and drag your mouse across the grid cells to select your desired window size and position.
5. Release the mouse. The active window will instantly snap into place!

## Troubleshooting

**The grid appears, but my window doesn't move when I select a region!**
This means macOS has silently revoked your Accessibility permissions (usually happens if you download a new version of the app). 
To fix this:
1. Open **System Settings > Privacy & Security > Accessibility**.
2. Select ScreenSplit and click the **`-` (minus)** button to remove it entirely.
3. Run the app again to trigger a fresh permission prompt and grant it again.

**How do I quit the app?**
Click the grid icon (`squareshape.split.3x3`) in your top right macOS menu bar and select **Quit ScreenSplit**.
