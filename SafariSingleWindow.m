#import <WebKit/WebKit.h>
#import <Cocoa/Cocoa.h>
#import <objc/objc-class.h>

#import "JRSwizzle.h"

@implementation WebView (SafariSingleWindowWebView)

- (void) SafariSingleWindow_webView: (WebView*) sender
         setFrame: (NSRect) frameRect {}
- (void) SafariSingleWindow_webView: (WebView*) sender
         setToolbarsVisible: (BOOL) toggle {}
- (void) SafariSingleWindow_webView: (WebView*) sender
         setStatusBarVisible: (BOOL) toggle {}

- (WebView*) SafariSingleWindow_webView: (WebView*) sender
             createWebViewWithRequest: (NSURLRequest*) request
{
    NSWindow* window = [self window];
    if (!window)
        goto failed;
    NSWindowController* controller = [window windowController];
    if (!controller)
        goto failed;
    WebView* tab = [controller createTab];
    if (!tab)
        goto failed;
    WebFrame* frame = [tab mainFrame];
    if (!frame)
    {
        NSLog(@"[SafariSingleWindow] Got nil mainFrame for createTab, "
               "attempting closeTab");
        [controller closeTab: tab];
        goto failed;
    }

succeeded:
    [frame loadRequest: request];
    return tab;
failed:
    return [self SafariSingleWindow_webView: sender
                 createWebViewWithRequest: request];
}

- (WebView*) SafariSingleWindow_webView: (WebView*) sender
             createWebViewWithRequest: (NSURLRequest*) request
             windowFeatures: (NSDictionary*) features
{
    NSWindow* window = [self window];
    if (!window)
        goto failed;
    NSWindowController* controller = [window windowController];
    if (!controller)
        goto failed;
    WebView* tab = [controller createTab];
    if (!tab)
        goto failed;
    WebFrame* frame = [tab mainFrame];
    if (!frame)
    {
        NSLog(@"[SafariSingleWindow] Got nil mainFrame for createTab, "
               "attempting closeTab");
        [controller closeTab: tab];
        goto failed;
    }

succeeded:
    [frame loadRequest: request];
    return tab;
failed:
    return [self SafariSingleWindow_webView: sender
                 createWebViewWithRequest: request
                 windowFeatures: features];
}

@end

@interface SafariSingleWindow: NSObject
@end

@implementation SafariSingleWindow

+ (void) swizzle
{
    @synchronized(self)
    {
    Class cls = NSClassFromString(@"BrowserWindowController");
    if (!cls)
    {
        NSLog(@"[SafariSingleWindow] ERROR: Got nil Class for "
               "BrowserWindowController");
        return;
    }
    if (!class_getInstanceMethod(cls, @selector(createTab)))
    {
        NSLog(@"[SafariSingleWindow] ERROR: Got nil Method for "
               "[BrowserWindowController createTab]");
        return;
    }
    if (!class_getInstanceMethod(cls, @selector(closeTab:)))
        NSLog(@"[SafariSingleWindow] WARNING: Got nil Method for "
               "[BrowserWindowController closeTab]");
    cls = NSClassFromString(@"BrowserWebView");
    if (!cls)
    {
        NSLog(@"[SafariSingleWindow] ERROR: Got nil Class for BrowserWebView");
        return;
    }

    if (![cls jr_swizzleMethod: @selector(webView:createWebViewWithRequest:windowFeatures:)
              withMethod: @selector(SafariSingleWindow_webView:createWebViewWithRequest:windowFeatures:)
              error: nil]
        &&
        ![cls jr_swizzleMethod: @selector(webView:createWebViewWithRequest:)
              withMethod: @selector(SafariSingleWindow_webView:createWebViewWithRequest:)
              error: nil])
    {
        NSLog(@"[SafariSingleWindow] WARNING: Failed to swizzle "
               "[BrowserWebView webView:createWebViewWithRequest:]");
    }
    if (![cls jr_swizzleMethod: @selector(webView:setFrame:)
              withMethod: @selector(SafariSingleWindow_webView:setFrame:)
              error: nil])
        NSLog(@"[SafariSingleWindow] WARNING: Failed to swizzle "
               "[BrowserWebView webView:setFrame:]");
    if (![cls jr_swizzleMethod: @selector(webView:setToolbarsVisible:)
              withMethod: @selector(SafariSingleWindow_webView:setToolbarsVisible:)
              error: nil])
        NSLog(@"[SafariSingleWindow] WARNING: Failed to swizzle "
               "[BrowserWebView webView:setToolbarsVisible:]");
    if (![cls jr_swizzleMethod: @selector(webView:setStatusBarVisible:)
              withMethod: @selector(SafariSingleWindow_webView:setStatusBarVisible:)
              error: nil])
        NSLog(@"[SafariSingleWindow] WARNING: Failed to swizzle "
               "[BrowserWebView webView:setStatusBarVisible:]");
    }
}

+ (IBAction) toggle: (NSMenuItem*) sender
{
    [sender setState: ![sender state]];
    [self swizzle];
}

+ (void) insertMenu
{
    NSMenu* mainMenu = [NSApp mainMenu];
    if (!mainMenu)
        return;
    NSMenuItem* safariMenuItem = [mainMenu itemAtIndex: 0];
    if (!safariMenuItem)
        return;
    NSMenu* safariMenu = [safariMenuItem submenu];
    if (!safariMenu)
        return;
    NSArray* itemArray = [safariMenu itemArray];
    if (!itemArray)
        return;

    NSInteger count = 0;
    NSEnumerator* enumerator = [itemArray objectEnumerator];
    NSMenuItem* item = nil;
    while ((item = [enumerator nextObject]))
    {
        if ([item isSeparatorItem])
            ++count;
        if (count == 2)
            break;
    }

    if (count != 2)
        return;

    item = [safariMenu insertItemWithTitle: @"Single Window Mode"
                       action: @selector(toggle:)
                       keyEquivalent: @""
                       atIndex: [safariMenu indexOfItem: item]];
    if (!item)
        return;

    [item setTarget: self];
    [item setState: NSOnState];
    [item setEnabled: YES];
}

+ (void) load
{
    [self swizzle];
    [self insertMenu];
}

@end
