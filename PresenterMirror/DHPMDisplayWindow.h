//
//  DHPMDisplayWindow.h
//  PresenterMirror
//
//  Created by Douglas Heriot on 31/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DHPMDisplayWindow : NSWindow
@property (strong, nonatomic) NSScreen *mirroredScreen;
@end
