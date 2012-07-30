//
//  DHPMAppDelegate.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 30/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHPMAppDelegate.h"
#import "NSScreen_Extension.h"
#import "DHPMDisplayWindow.h"

@interface DHPMAppDelegate()
@property (strong) DHPMDisplayWindow *window;
@property (strong) NSArray *screens;
@property (weak) QCCompositionLayer *layer;
@property (readonly) CGDirectDisplayID selectedDisplayId;
@end

@implementation DHPMAppDelegate
@synthesize screenMenu = _screenMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.screens = [NSScreen screens];
	
	self.window = [[DHPMDisplayWindow alloc] initWithContentRect:NSMakeRect(900, 100, 400, 300) styleMask:NSBorderlessWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask backing:NSBackingStoreRetained defer:NO screen:[NSScreen mainScreen]];
//	self.window.level = NSStatusWindowLevel;
	self.window.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorParticipatesInCycle;
	self.window.frameAutosaveName = @"PresenterMirror";
	self.window.canHide = NO;
	
	self.layer = [[QCCompositionLayer alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Mirror" ofType:@"qtz"]];
	self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
	
	NSView *view = self.window.contentView;
	view.layer = self.layer;
	view.wantsLayer = YES;
	
	[self setScreenIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"displayIndex"]];
	
	[self.window makeKeyAndOrderFront:self];
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
		item.tag = index;
		
		item.state = screen.displayID == self.selectedDisplayId;
		
		item.target = self;
		item.action = @selector(selectScreen:);
	}
	
	return YES;
}

- (void)setScreenIndex:(NSInteger)index
{
	if(index >= self.screens.count)
		index = self.screens.count - 1;
	
	if(index < 0)
		return;
	
	NSScreen *screen = self.screens[index];
	NSSize newSize = screen.frame.size;
	
	_selectedDisplayId = screen.displayID;
	
	[self.layer setValue:@(screen.displayID) forInputKey:@"Display_ID"];
	self.window.aspectRatio = newSize;
	[[NSUserDefaults standardUserDefaults] setValue:@(index) forKey:@"displayIndex"];
	
	NSRect newFrame = self.window.frame;
	newFrame.size.height = newFrame.size.width * newSize.height/newSize.width;
	newFrame = [self.window constrainFrameRect:newFrame toScreen:screen];
	[self.window setFrame:newFrame display:YES animate:NO];
}

- (IBAction)selectScreen:(id)sender
{
	[self setScreenIndex:[sender tag]];
}

@end
