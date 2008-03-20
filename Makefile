CFLAGS=-U__OBJC2__ -bundle -framework Cocoa -framework WebKit -arch i386 -arch x86_64 -arch ppc -arch ppc64

all: build

build:
	mkdir -p SafariSingleWindow.bundle/Contents/MacOS
	gcc $(CFLAGS) SafariSingleWindow.m -o SafariSingleWindow.bundle/Contents/MacOS/SafariSingleWindow
	cp Info.plist SafariSingleWindow.bundle/Contents
clean:
	rm -rf SafariSingleWindow.bundle
install:
	mkdir -p $(HOME)/Library/Application\ Support/SIMBL/Plugins
	cp -R SafariSingleWindow.bundle $(HOME)/Library/Application\ Support/SIMBL/Plugins
