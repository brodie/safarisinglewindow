#import <WebKit/WebKit.h>
#import <Cocoa/Cocoa.h>
#import <objc/objc-class.h>

BOOL swizzle(Class cls, SEL old_sel, SEL new_sel)
{
    Method old_method = class_getInstanceMethod(cls, old_sel);
    if (!old_method)
        return NO;
    Method new_method = class_getInstanceMethod(cls, new_sel);
    if (!new_method)
        return NO;

    char* old_types = old_method->method_types;
    old_method->method_types = new_method->method_types;
    new_method->method_types = old_types;

    IMP old_imp = old_method->method_imp;
    old_method->method_imp = new_method->method_imp;
    new_method->method_imp = old_imp;

    return YES;
}

@implementation WebView (SafariSingleWindowWebView)

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

@interface SafariSingleWindow: NSObject {}
@end

@implementation SafariSingleWindow

+ (void) load
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    if (!center)
    {
        NSLog(@"[SafariSingleWindow] ERROR: Got nil from "
               "[NSNotificationCenter defaultCenter]");
        return;
    }

    [center addObserver: self
            selector: @selector(applicationDidFinishLaunching:)
            name: NSApplicationDidFinishLaunchingNotification
            object: nil];
}

+ (void) applicationDidFinishLaunching: (NSNotification*) notification
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

    if (!swizzle(cls, @selector(webView:createWebViewWithRequest:windowFeatures:),
            @selector(SafariSingleWindow_webView:createWebViewWithRequest:windowFeatures:))
        && !swizzle(cls, @selector(webView:createWebViewWithRequest:),
            @selector(SafariSingleWindow_webView:createWebViewWithRequest:)))
    {
        NSLog(@"[SafariSingleWindow] WARNING: Failed to swizzle "
               "[BrowserWebView webView:createWebViewWithRequest:]");
    }
}

@end
