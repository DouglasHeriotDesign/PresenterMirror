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

@interface DHPMAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>
@property (weak) NSMenu *screenMenu;
- (IBAction)selectScreen:(id)sender;
@end
