# Aqueduct

Aqueduct is a lightweight, high-performance macOS window manager inspired by the `gTile` extension for GNOME. Named after the structures designed to channel and guide water flow, Aqueduct allows you to smoothly direct and snap your window flows using a dynamic, screen-adaptive layout grid and global keyboard controls.

## Features

- **Flow Configuration (Grid)**: Adapt and divide your screen into horizontal **Ripples** (rows) and vertical **Channels** (columns) to structure your layout.
- **Riverbanks (Window Gaps)**: Specify custom window margins (None, Trickle, Brook, Stream, River, Torrent) to separate window layouts with aesthetic transparent gaps.
- **Confluences (Layout Templates)**: Quickly set standard grids like **Forked Stream** (1:1 vertical split), **Tiered Pools** (1:1 horizontal split), and **Trifurcated Delta** (1:1:1 / 1:2 thirds).
- **Workspace Snapshots**: Instantly capture the exact positions and sizes of all running GUI windows, and restore them with a single click later.
- **Instant Hotkeys**: Snap windows to halves, maximize, or "Center & Float" (60% width, 80% height) with global keyboard shortcuts without opening the grid overlay.
- **Accessibility & Native Integration**: Interacts directly with macOS Window APIs via `AXUIElement` for lightweight and instant window snapping.

---

## Global Shortcuts

- `Cmd+G` ➔ **Toggle Flow Grid Overlay**
- `Ctrl+Option+Left Arrow` ➔ **Snap Left Half**
- `Ctrl+Option+Right Arrow` ➔ **Snap Right Half**
- `Ctrl+Option+Up Arrow` ➔ **Snap Top Half**
- `Ctrl+Option+Down Arrow` ➔ **Snap Bottom Half**
- `Ctrl+Option+Enter` ➔ **Maximize Window**
- `Ctrl+Option+C` ➔ **Center & Float** (60% width, 80% height)
- `Ctrl+Option+Cmd+Right Arrow` ➔ **Throw Window to Next Monitor**
- `Ctrl+Option+Cmd+Left Arrow` ➔ **Throw Window to Previous Monitor**

---

## Installation & Usage

Because Aqueduct is not signed with a paid Apple Developer certificate, macOS Gatekeeper may try to restrict it by default. Follow these steps:

1. **Build the Binary**:
   Run the build script in your terminal to compile the code and code-sign it with your local keychain certificate:
   ```bash
   ./build.sh
   ```
2. **Bypass Gatekeeper**: 
   Right-Click (or Control-Click) `Aqueduct.app` and select **Open**. Click **Open** again to bypass the security warning.
3. **Grant Accessibility Permissions**: 
   Aqueduct needs window control access. Go to **System Settings > Privacy & Security > Accessibility** and toggle on the switch next to **Aqueduct**.

---

## How to Tile Windows

1. Focus the window you want to arrange.
2. Press **`Command + G`** to show the flow grid.
3. Click and drag across the cells to draw the region, or use **Arrow Keys** (plus **Shift** to resize) and **Enter** to confirm.
4. Release or press Enter, and the window will snap perfectly!
