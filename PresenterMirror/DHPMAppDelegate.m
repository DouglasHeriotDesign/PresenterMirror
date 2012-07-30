//
//  DHPMAppDelegate.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 30/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHPMAppDelegate.h"

@interface DHPMAppDelegate()
@property (strong) IBOutlet NSWindow *window;
@end

@implementation DHPMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(900, 100, 400, 300) styleMask:NSBorderlessWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen]];
	self.window.level = NSStatusWindowLevel;
	self.window.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces;
	self.window.frameAutosaveName = @"PresenterMirror";
	
	QCCompositionLayer *layer = [[QCCompositionLayer alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Mirror" ofType:@"qtz"]];
	layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
	
	NSView *view = self.window.contentView;
	view.layer = layer;
	view.wantsLayer = YES;
	
	[self.window makeKeyAndOrderFront:self];
	
	[layer setValue:@478204363 forInputKey:@"Display_ID"];
}

@end
