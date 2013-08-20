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
	
	self.window = [DHPMDisplayWindow new];
	self.window.frameAutosaveName = @"PresenterMirror";
	
	[self selectKeepOnTop:self];
		
	
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
		
		if(index < 9)
		{
			item.keyEquivalent = @(index+1).stringValue;
			item.keyEquivalentModifierMask = NSCommandKeyMask;
		}
		
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
	
	//[self.layer setValue:@(screen.displayID) forInputKey:@"Display_ID"];
	
	self.window.mirroredScreen = screen;
	self.window.aspectRatio = newSize;
	[[NSUserDefaults standardUserDefaults] setValue:@(index) forKey:@"displayIndex"];
	
	NSRect newFrame = self.window.frame;
	newFrame.size.height = newFrame.size.width * newSize.height/newSize.width;
	newFrame = [self.window constrainFrameRect:newFrame toScreen:self.window.screen];
	[self.window setFrame:newFrame display:YES animate:NO];
}

- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window
{
	return YES;
}

- (IBAction)selectScreen:(id)sender
{
	[self setScreenIndex:[sender tag]];
}

- (IBAction)scale100:(id)sender
{
	NSRect newFrame = self.window.frame; // contains current origin
	newFrame.size.width = self.selectedScreen.frame.size.width * self.selectedScreen.backingScaleFactor / self.window.screen.backingScaleFactor;
	newFrame.size.height = self.selectedScreen.frame.size.height * self.selectedScreen.backingScaleFactor / self.window.screen.backingScaleFactor;
	
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
