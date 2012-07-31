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
@end

@implementation DHPMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.screens = [NSScreen screens];
	
	// Load the custom screen capture plugin
	[QCPlugIn loadPlugInAtPath:[[NSBundle mainBundle] pathForResource:@"v002 Media Tools" ofType:@"plugin"]];
	
	self.window = [[DHPMDisplayWindow alloc] initWithContentRect:NSMakeRect(900, 100, 400, 300) styleMask:NSBorderlessWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask backing:NSBackingStoreRetained defer:NO screen:[NSScreen mainScreen]];
	self.window.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorParticipatesInCycle;
	self.window.frameAutosaveName = @"PresenterMirror";
	self.window.canHide = NO;
	self.window.minSize = NSMakeSize(20, 20);
	
	[self selectKeepOnTop:self];
	
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
	
	_selectedScreen = screen;
	_selectedDisplayId = screen.displayID;
	
	[self.layer setValue:@(screen.displayID) forInputKey:@"Display_ID"];
	self.window.aspectRatio = newSize;
	[[NSUserDefaults standardUserDefaults] setValue:@(index) forKey:@"displayIndex"];
	
	NSRect newFrame = self.window.frame;
	newFrame.size.height = newFrame.size.width * newSize.height/newSize.width;
	newFrame = [self.window constrainFrameRect:newFrame toScreen:self.window.screen];
	[self.window setFrame:newFrame display:YES animate:NO];
}

- (IBAction)selectScreen:(id)sender
{
	[self setScreenIndex:[sender tag]];
}

- (IBAction)scale100:(id)sender
{
	NSRect newFrame = self.window.frame;
	newFrame.size.width = self.selectedScreen.frame.size.width / self.window.screen.backingScaleFactor;
	newFrame.size.height = self.selectedScreen.frame.size.height / self.window.screen.backingScaleFactor;
	
	newFrame = [self.window constrainFrameRect:newFrame toScreen:self.window.screen];
	
	[self.window setFrame:newFrame display:YES animate:NO];
}

- (IBAction)selectKeepOnTop:(id)sender
{
	BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:@"keepOnTop"];
	
	// If we pressed the menu button, the keepOnTop value won't have changed yet, so flip it in here now
	if([sender isKindOfClass:[NSMenuItem class]])
		on = !on;
	
	if(on)
		self.window.level = NSStatusWindowLevel;
	else
		self.window.level = NSNormalWindowLevel;
}

@end
