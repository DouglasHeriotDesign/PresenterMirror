//
//  DHPMAppDelegate.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 30/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHPMAppDelegate.h"
#import "NSScreen_Extension.h"

@interface DHPMAppDelegate()
@property (strong) NSWindow *window;
@property (strong) NSArray *screens;
@property (weak) QCCompositionLayer *layer;
@end

@implementation DHPMAppDelegate
@synthesize screenMenu = _screenMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(900, 100, 400, 300) styleMask:NSBorderlessWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask backing:NSBackingStoreRetained defer:NO screen:[NSScreen mainScreen]];
//	self.window.level = NSStatusWindowLevel;
	self.window.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorParticipatesInCycle;
	self.window.frameAutosaveName = @"PresenterMirror";
	self.window.canHide = NO;
	
	self.layer = [[QCCompositionLayer alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Mirror" ofType:@"qtz"]];
	self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
	
	NSView *view = self.window.contentView;
	view.layer = self.layer;
	view.wantsLayer = YES;
	
	[self.window makeKeyAndOrderFront:self];
	
	[self.layer setValue:@478204363 forInputKey:@"Display_ID"];
}

- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu
{
	if(menu == self.screenMenu)
	{
		self.screens = [NSScreen screens];
		return self.screens.count;
	}
	else
		return 0;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
{
	if(menu == self.screenMenu)
	{
		NSScreen *screen = self.screens[index];
		item.title = screen.name;
		item.tag = screen.displayID;
		
		item.target = self;
		item.action = @selector(selectScreen:);
	}
	
	return YES;
}

- (IBAction)selectScreen:(id)sender
{
	[self.layer setValue:@([sender tag]) forInputKey:@"Display_ID"];
	
	NSSize size = NSZeroSize;
	for(NSScreen *screen in self.screens)
	{
		if(screen.displayID == [sender tag])
			size = screen.frame.size;
	}
	
	self.window.aspectRatio = size;
}

@end
