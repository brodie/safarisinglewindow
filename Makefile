CFLAGS=-bundle -framework Cocoa -framework WebKit -O2 -Wall
OBJECTS=JRSwizzle.m SafariSingleWindow.m
NAME=SafariSingleWindow
TARGET=$(NAME).bundle/Contents/MacOS/$(NAME)
DMGFILES=$(NAME).bundle README.txt LICENSE.txt

build:
	mkdir -p $(NAME).bundle/Contents/MacOS
	gcc $(CFLAGS) -arch i386 -arch ppc -arch x86_64 -mmacosx-version-min=10.4 -Xarch_x86_64 -mmacosx-version-min=10.5 $(OBJECTS) -o $(TARGET)
	cp Info.plist $(NAME).bundle/Contents
buildnative:
	mkdir -p $(NAME).bundle/Contents/MacOS
	gcc $(CFLAGS) $(OBJECTS) -o $(TARGET)
	cp Info.plist $(NAME).bundle/Contents
dmg builddmg: build
	rm -rf $(NAME) $(NAME).dmg
	mkdir $(NAME)
	osacompile -o $(NAME)/Install.app Install.scpt
	osacompile -o $(NAME)/Uninstall.app Uninstall.scpt
	cp -R $(DMGFILES) $(NAME)
	hdiutil create -fs HFS+ -imagekey zlib-level=9 -srcfolder $(NAME) -volname $(NAME) $(NAME).dmg
	rm -rf $(NAME)
clean:
	rm -rf $(NAME).bundle
	rm -f $(NAME).dmg
install: build
	mkdir -p $(HOME)/Library/Application\ Support/SIMBL/Plugins
	cp -R $(NAME).bundle $(HOME)/Library/Application\ Support/SIMBL/Plugins
