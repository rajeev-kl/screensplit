import SwiftUI

struct GridSelection {
    var startColumn: Int
    var startRow: Int
    var endColumn: Int
    var endRow: Int
    
    func contains(col: Int, row: Int) -> Bool {
        let minCol = min(startColumn, endColumn)
        let maxCol = max(startColumn, endColumn)
        let minRow = min(startRow, endRow)
        let maxRow = max(startRow, endRow)
        
        return col >= minCol && col <= maxCol && row >= minRow && row <= maxRow
    }
}

struct GridOverlayView: View {
    var onConfirm: (CGRect) -> Void
    
    @State private var selection: GridSelection?
    @State private var dragStart: CGPoint?
    
    let gridPadding: CGFloat = 0
    let gridSpacing: CGFloat = 0
    
    // Dynamic grid size based on screen
    var columns: Int {
        if let screen = NSScreen.main {
            return max(4, Int(screen.frame.width / 400))
        }
        return 8
    }
    
    var rows: Int {
        if let screen = NSScreen.main {
            return max(3, Int(screen.frame.height / 300))
        }
        return 4
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.opacity(0.4)
                
                // Grid
                VStack(spacing: gridSpacing) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: gridSpacing) {
                            ForEach(0..<columns, id: \.self) { col in
                                Rectangle()
                                    .fill(
                                        (selection?.contains(col: col, row: row) == true)
                                        ? Color.blue.opacity(0.8)
                                        : Color.white.opacity(0.2)
                                    )
                                    .border(Color.white.opacity(0.5), width: 1)
                            }
                        }
                    }
                }
                .padding(gridPadding)
            }
            .contentShape(Rectangle()) // Make entire area clickable
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStart == nil {
                            dragStart = value.startLocation
                        }
                        
                        let cellWidth = (geometry.size.width - (gridPadding * 2) - CGFloat(columns - 1) * gridSpacing) / CGFloat(columns)
                        let cellHeight = (geometry.size.height - (gridPadding * 2) - CGFloat(rows - 1) * gridSpacing) / CGFloat(rows)
                        
                        let startCol = max(0, min(columns - 1, Int((value.startLocation.x - gridPadding) / (cellWidth + gridSpacing))))
                        let startRow = max(0, min(rows - 1, Int((value.startLocation.y - gridPadding) / (cellHeight + gridSpacing))))
                        
                        let endCol = max(0, min(columns - 1, Int((value.location.x - gridPadding) / (cellWidth + gridSpacing))))
                        let endRow = max(0, min(rows - 1, Int((value.location.y - gridPadding) / (cellHeight + gridSpacing))))
                        
                        selection = GridSelection(startColumn: startCol, startRow: startRow, endColumn: endCol, endRow: endRow)
                    }
                    .onEnded { value in
                        guard let sel = selection else { return }
                        
                        let cellWidth = (geometry.size.width - (gridPadding * 2) - CGFloat(columns - 1) * gridSpacing) / CGFloat(columns)
                        let cellHeight = (geometry.size.height - (gridPadding * 2) - CGFloat(rows - 1) * gridSpacing) / CGFloat(rows)
                        
                        let minCol = min(sel.startColumn, sel.endColumn)
                        let maxCol = max(sel.startColumn, sel.endColumn)
                        let minRow = min(sel.startRow, sel.endRow)
                        let maxRow = max(sel.startRow, sel.endRow)
                        
                        let windowScreen = NSApp.windows.first(where: { $0.isKeyWindow || $0.level == .floating })?.screen ?? NSScreen.main!
                        
                        let width = CGFloat(maxCol - minCol + 1) * cellWidth + CGFloat(maxCol - minCol) * gridSpacing
                        let height = CGFloat(maxRow - minRow + 1) * cellHeight + CGFloat(maxRow - minRow) * gridSpacing
                        
                        let localX = gridPadding + CGFloat(minCol) * (cellWidth + gridSpacing)
                        let localY = gridPadding + CGFloat(minRow) * (cellHeight + gridSpacing)
                        
                        // Global top-left of the current screen in AX coordinates
                        // AX coordinates: (0,0) is top-left of primary screen.
                        // NSScreen coordinates: (0,0) is bottom-left of primary screen.
                        let primaryScreen = NSScreen.screens[0]
                        let screenTopLeftX = windowScreen.frame.origin.x
                        let screenTopLeftY = primaryScreen.frame.height - (windowScreen.frame.origin.y + windowScreen.frame.height)
                        
                        let globalX = screenTopLeftX + localX
                        let globalY = screenTopLeftY + localY
                        
                        let finalRect = CGRect(x: globalX, y: globalY, width: width, height: height)
                        
                        onConfirm(finalRect)
                        
                        // Reset
                        selection = nil
                        dragStart = nil
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
