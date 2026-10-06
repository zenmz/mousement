#!/bin/bash
set -e

echo "Downloading Mousement v1.0.0..."
curl -sL "https://github.com/zenmz/mousement/releases/download/v1.0.0/Mousement.zip" -o /tmp/Mousement.zip

echo "Extracting..."
unzip -q /tmp/Mousement.zip -d /tmp/MousementAppTmp

echo "Installing to /Applications..."
killall Mousement 2>/dev/null || true
rm -rf /Applications/Mousement.app ~/Applications/Mousement.app
cp -R /tmp/MousementAppTmp/Mousement.app /Applications/

echo "Cleaning up..."
rm -rf /tmp/Mousement.zip /tmp/MousementAppTmp
xattr -cr /Applications/Mousement.app

echo "Successfully installed Mousement!"
echo "You can now launch it from Launchpad or by running: open /Applications/Mousement.app"
