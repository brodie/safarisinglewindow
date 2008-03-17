all: build

build:
	mkdir -p SafariSingleWindow.bundle/Contents/MacOS
	gcc -bundle -framework Cocoa -framework WebKit SafariSingleWindow.m -o SafariSingleWindow.bundle/Contents/MacOS/SafariSingleWindow
	cp Info.plist SafariSingleWindow.bundle/Contents
clean:
	rm -rf SafariSingleWindow.bundle
install:
	mkdir -p $(HOME)/Library/Application\ Support/SIMBL/Plugins
	cp -R SafariSingleWindow.bundle $(HOME)/Library/Application\ Support/SIMBL/Plugins
