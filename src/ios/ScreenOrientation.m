#import "ScreenOrientation.h"
#import <Cordova/CDVViewController.h>

@interface ScreenOrientation ()
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;
@end

@implementation ScreenOrientation

#pragma mark - Helpers

- (UIInterfaceOrientation)currentOrientation {
    UIWindowScene *scene = (UIWindowScene *)self.viewController.view.window.windowScene;
    return scene ? scene.interfaceOrientation : UIInterfaceOrientationUnknown;
}

#pragma mark - Orientation Handlers

- (UIInterfaceOrientation)orientationForMaskBelowOrEqual15:(NSInteger)mask deviceOrientation:(UIInterfaceOrientation)deviceOrientation {
    if ((UIInterfaceOrientationIsPortrait(deviceOrientation) && ((mask & 1 && deviceOrientation == UIInterfaceOrientationPortrait) || (mask & 2 && deviceOrientation == UIInterfaceOrientationPortraitUpsideDown))) ||
        (UIInterfaceOrientationIsLandscape(deviceOrientation) && ((mask & 4 && deviceOrientation == UIInterfaceOrientationLandscapeRight) || (mask & 8 && deviceOrientation == UIInterfaceOrientationLandscapeLeft)))) {
        return deviceOrientation;
    }

    // Fallback to first allowed orientation
    if (mask & 1) return UIInterfaceOrientationPortrait;
    if (mask & 2) return UIInterfaceOrientationPortraitUpsideDown;
    if (mask & 4) return UIInterfaceOrientationLandscapeRight;
    if (mask & 8) return UIInterfaceOrientationLandscapeLeft;

    return UIInterfaceOrientationUnknown;
}

- (UIInterfaceOrientationMask)maskForMaskAboveOrEqual16:(NSInteger)mask {
    UIInterfaceOrientationMask result = 0;
    if (mask & 1) result |= UIInterfaceOrientationMaskPortrait;
    if (mask & 2) result |= UIInterfaceOrientationMaskPortraitUpsideDown;
    if (mask & 4) result |= UIInterfaceOrientationMaskLandscapeRight;
    if (mask & 8) result |= UIInterfaceOrientationMaskLandscapeLeft;
    return result;
}

- (void)handleOrientationBelowOrEqual15:(NSInteger)mask {
    UIInterfaceOrientation deviceOrientation = [self currentOrientation];

    if (mask == 15) { // Unlock
        if (self.lastOrientation != UIInterfaceOrientationUnknown) {
            [[UIDevice currentDevice] setValue:@(self.lastOrientation) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
        }
        self.isLocked = NO;
        self.lastOrientation = UIInterfaceOrientationUnknown;
        return;
    }

    if (!self.isLocked) self.lastOrientation = deviceOrientation;

    UIInterfaceOrientation targetOrientation = [self orientationForMaskBelowOrEqual15:mask deviceOrientation:deviceOrientation];

    if (targetOrientation != UIInterfaceOrientationUnknown) {
        self.isLocked = YES;
        [[UIDevice currentDevice] setValue:@(targetOrientation) forKey:@"orientation"];
    } else {
        self.isLocked = NO;
    }
}

- (void)handleOrientationAboveOrEqual16:(NSInteger)mask {
    UIWindowScene *scene = (UIWindowScene *)self.viewController.view.window.windowScene;
    if (!scene) return;

    if (mask == 15) { // Unlock
        if (self.lastOrientation != UIInterfaceOrientationUnknown) {
            [[UIDevice currentDevice] setValue:@(self.lastOrientation) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
        }
        self.isLocked = NO;
        self.lastOrientation = UIInterfaceOrientationUnknown;
        return;
    }

    if (!self.isLocked) self.lastOrientation = [self currentOrientation];

    UIInterfaceOrientationMask targetMask = [self maskForMaskAboveOrEqual16:mask];

    if (targetMask != 0) {
        self.isLocked = YES;

        if (@available(iOS 16.0, *)) {
            UIWindowSceneGeometryPreferencesIOS *preferences =
                [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:targetMask];

            dispatch_async(dispatch_get_main_queue(), ^{
                [scene requestGeometryUpdateWithPreferences:preferences errorHandler:^(NSError * _Nonnull error) {
                    if (error) {
                        NSLog(@"Failed to change orientation: %@", error);
                    }
                }];
            });
        }
    } else {
        self.isLocked = NO;
    }
}

- (void)handleOrientationMask:(NSInteger)mask {
    if (@available(iOS 16.0, *)) {
        [self handleOrientationAboveOrEqual16:mask];
        [self.viewController setNeedsUpdateOfSupportedInterfaceOrientations];
    } else {
        [self handleOrientationBelowOrEqual15:mask];
    }
}

#pragma mark - Cordova Plugin Entry

- (void)screenOrientation:(CDVInvokedUrlCommand *)command {
    NSInteger mask = [[command argumentAtIndex:0] integerValue];

    NSMutableArray *allowedOrientations = [NSMutableArray array];
    if (mask & 1) [allowedOrientations addObject:@(UIInterfaceOrientationPortrait)];
    if (mask & 2) [allowedOrientations addObject:@(UIInterfaceOrientationPortraitUpsideDown)];
    if (mask & 4) [allowedOrientations addObject:@(UIInterfaceOrientationLandscapeRight)];
    if (mask & 8) [allowedOrientations addObject:@(UIInterfaceOrientationLandscapeLeft)];

    SEL selector = NSSelectorFromString(@"setSupportedOrientations:");
    if ([self.viewController respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.viewController performSelector:selector withObject:allowedOrientations];
#pragma clang diagnostic pop
    }

    [self handleOrientationMask:mask];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
