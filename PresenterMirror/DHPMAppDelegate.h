//
//  DHPMAppDelegate.h
//  PresenterMirror
//
//  Created by Douglas Heriot on 30/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@class DHPMDisplayWindow;

@interface DHPMAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate /*, NSLayerDelegateContentsScaleUpdating*/>

@property (readonly) CGDirectDisplayID selectedDisplayId;
@property (readonly, strong) NSScreen *selectedScreen;

@property (weak) NSMenu *screenMenu;
- (IBAction)selectScreen:(id)sender;
- (IBAction)scale100:(id)sender;
- (IBAction)selectKeepOnTop:(id)sender;
- (IBAction)selectDisableMouseInteraction:(id)sender;


@property (strong, readonly) DHPMDisplayWindow *window;

@end
