#!/bin/bash

APP_NAME="ScreenSplit"
APP_BUNDLE="${APP_NAME}.app"
APP_MACOS="${APP_BUNDLE}/Contents/MacOS"

echo "Creating app bundle structure..."
mkdir -p "${APP_MACOS}"

echo "Copying Info.plist..."
cp Info.plist "${APP_BUNDLE}/Contents/"

echo "Compiling Swift files..."
swiftc Sources/*.swift -o "${APP_MACOS}/${APP_NAME}" \
    -framework Cocoa \
    -framework SwiftUI \
    -framework ApplicationServices \
    -framework Carbon

if [ $? -eq 0 ]; then
    echo "Codesigning app with ad-hoc signature..."
    codesign --force --deep --sign - "${APP_BUNDLE}"
    echo "Build successful! Application is ready at ${APP_BUNDLE}"
else
    echo "Build failed."
    exit 1
fi
