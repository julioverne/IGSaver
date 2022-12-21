#import <objc/runtime.h>
#import <substrate.h>
#import <Foundation/Foundation.h>

#import <prefs.h>

#define NSLog(...)

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static UIViewController *_topMostController(UIViewController *cont)
{
    UIViewController *topController = cont;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    return (topController != cont ? topController : nil);
}
static UIViewController *topMostController()
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *next = nil;
    while ((next = _topMostController(topController)) != nil) {
        topController = next;
    }
    return topController;
}

@interface UIColor ()
+ (id)labelColor;
@end

@interface IGSaverImportListController : PSListController <UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (strong) NSString *path;
@property (strong) NSMutableDictionary *tags;
@property (strong) UIImageView *imageview;
@property (strong) UIActivityViewController *activityViewController;

- (id)initWithPath:(NSString*)pathSt title:(NSString*)titleSt album:(NSString*)albumSt mediaType:(int)mediaType user:(NSString*)user;

- (void)showEdit;
- (void)closeEdit;
- (void)addMediaToRoll;
@end