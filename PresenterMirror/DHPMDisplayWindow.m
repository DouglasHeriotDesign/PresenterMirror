//
//  DHPMDisplayWindow.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 31/07/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHPMDisplayWindow.h"
#import "DHPMMirrorLayer.h"

@interface DHPMDisplayWindow()
@property (strong) DHPMMirrorLayer *openGLLayer;
@end

@implementation DHPMDisplayWindow

- (id)init
{
	if(self = [super initWithContentRect:NSMakeRect(900, 100, 400, 300) styleMask:NSBorderlessWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask backing:NSBackingStoreRetained defer:NO screen:[NSScreen mainScreen]])
	{
		self.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorParticipatesInCycle;
		self.title = @"Presenter Mirror";
		self.canHide = NO;
		self.minSize = NSMakeSize(20, 20);
		
		self.openGLLayer = [DHPMMirrorLayer new];
		
		// Make the content view layer-hosting
		[self.contentView setLayer:self.openGLLayer];
		[self.contentView setWantsLayer:YES];
	}
	return self;
}

- (void)setMirroredScreen:(NSScreen *)mirroredScreen
{
	_mirroredScreen = mirroredScreen;
	self.openGLLayer.mirroredScreen = mirroredScreen;
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (BOOL)canBecomeVisibleWithoutLogin
{
	return YES;
}

- (BOOL)isMovableByWindowBackground
{
	return YES;
}

@end
